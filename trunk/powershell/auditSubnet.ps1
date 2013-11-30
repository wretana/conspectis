##################################################
#                                                #
# ESMS Powershell IP Audit Script                #
#                                                #
#   Desc: Audits IP Addresses for all subnets	 #
#         via NSLOOKUP and PING requests         #
# Author: Chris Knight                           #
#   Date: 5/30/12                                #
#                                                #
##################################################

## C:\Inetpub\ESMS-ABQDC\powershell\auditSubnet.ps1
##
## This brings the ESMS.esmsLibrary class into our Powershell session. 
## All STATIC properties and methods from esmsLibrary.cs can be used in PowerShell
Import-Module c:\inetpub\ESMS-ABQDC\powershell\Get-EsmsLibrary.psm1 -ArgumentList 'ABQDC-DEV'

Function strColl_to_commaString ([System.Collections.Specialized.StringCollection]$sc)
{
   [string]$outString=""
   if ($sc -ne $null)
   {
      foreach ($str in $sc)
      {
         if ($outString -ne "")
         {
            $outString=$outString+","
         }
         $outString=$outString+$str
      }
   }
   return $outString
}

$fetchSubnet=$args[0]

if (($fetchSubnet -ne $null) -And ($fetchSubnet -ne ""))
{
    $date = Get-Date
    $dateStamp = $date.Month.ToString() + $date.Day.ToString() + $date.Year.ToString() + "-" + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()

    $dnsResult = New-Object -TypeName System.Collections.Specialized.StringCollection
    [string]$sql=""
    [string]$pingStat=""
    [string]$dnsStat=""
    [string]$ipComment=""
    [string]$sqlErr=""
    [string]$line=""
    [string]$dnsStr=""
    [string]$ipDom=""
    [string]$outfile="c:\inetpub\ESMS-ABQDC\log\ipMaint_"+$fetchSubnet+".log"
    $dat = New-Object -TypeName System.Data.DataTable
    $dat2= New-Object -TypeName System.Data.DataTable
    [string]$sql="ALTER TABLE "+$fetchSubnet+" ALTER COLUMN comment text(255)"
    [string]$sqlErr=Write-EsmsDb($sql)
    $sql="SELECT ipAddr, comment FROM "+$fetchSubnet
    $dat=Read-EsmsDbDT($sql)
    if ($dat -ne $Null)
    {
        $sw = New-Object -TypeName System.IO.StreamWriter($outfile, $false)
        foreach ($dr in $dat)
        {
            if ($dr["comment"].ToString() -eq "")
            {
                $ipComment="## Last Checked:"+$dateStamp
            }
            else
            {
		$line="APPENDING: "+$dr["comment"].ToString()+"\r\n"
                $sw.Write($line)
                $ipComment=$dr["comment"].ToString()+" ## Last Checked:"+$dateStamp
            }
            if ($dr["comment"].ToString().Contains("##"))
            {
		$line="UPDATING: "+$dr["comment"].ToString().Substring(0,$dr["comment"].ToString().IndexOf("##"))+"\r\n"
                $sw.Write($line)
                $ipComment=$dr["comment"].ToString().Substring(0,$dr["comment"].ToString().IndexOf("##"))+" ## Last Checked:"+$dateStamp
            }
	    $line=$dr["ipAddr"].ToString()+":"+$fetchSubnet+"\r\n"
            $sw.Write($line)
	    $ipDom=Write-EsmsFixIp($dr["ipAddr"].ToString())

##NOW, try to reverse lookup a hostname with this IP address ...
            $dnsResult=Invoke-EsmsDnsRevLookup($ipDom)

##No hostname found, mark subnet table dnsStatus RED (0) ...
	    if ( $dnsResult -eq $ipDom )
                { 
                    $dnsStat="0"
		    $line=$dr["ipAddr"].ToString()+":No NSLOOKUP\r\n"
                    $sw.Write($line)
                }
	##Hostname found, now verify we have a matching server ...
                else
                { 
                    $dnsStat="tbd"
		    $line=$dr["ipAddr"].ToString()+":DNS Result Count - "+ $dnsResult.Count +"\r\n"
                    $sw.Write($line)
                    if ($dnsResult.Count -gt 1)
                    {
                        $dnsStat="2" ##BAD: Multiple name resolution for this IP.
                        $ipComment=$ipComment+" - ERR: Multiple DNS name resolution."
                    }
                    else
                    {
                        $sql="SELECT serverName FROM servers WHERE serverLanIp='"+$dr["ipAddr"].ToString()+"'"
                        $dat2=Read-EsmsDbDT($sql)
                        if ($dat2 -ne $null)
                        {
			    $line=$dr["ipAddr"].ToString()+":DNS Results - "+$dat2["serverName"].ToString()+" / "+$dnsResult.Substring(0,$dnsResult.IndexOf(".")).ToUpper()+" \r\n"
                            $sw.Write($line)
                            if ($dat2["serverName"].ToString() -eq $dnsResult.Substring(0,$dnsResult.IndexOf(".")).ToUpper())
                            {
                                $dnsStat="1" ##GOOD: DNS Hostname matches ESMS hostname.
                            }
                            else 
                            {
                                $dnsStat="2" ##BAD: Mismatching name resolution (DNS hostname does not match ESMS hostname).
                                $ipComment=$ipComment+" - ERR: DNS name does not match ESMS name."
                            }
                        }
                        else
                        {
                            $dnsStat="2" ##BAD: Some odd error occurred.
                            $ipComment=$ipComment+" - ERR: Unexpected servername/IP Error."
                        }
                    }
		    $dnsStr=strColl_to_commaString($dnsResult)
		    $line=$dr["ipAddr"].ToString() + ":DNS FOUND - " + $dnsStr + "\r\n"
                    $sw.Write($line)
                }

	##FINALLY, ping this IP address ...
                if (Test-EsmsPing($ipDom))
                { ##Its pinging, mark subnet table pingStatus GREEN (1) ...
                    $pingStat="1"
		    $line=$dr["ipAddr"].ToString()+":PING OK\r\n"
                    $sw.Write($line)
                }
                else
                { ##Not pinging, mark subnet table pingStatus RED (0) ...
                    $pingStat="0"
		    $line=$dr["ipAddr"].ToString()+":NOT PINGING!\r\n"
                    $sw.Write($line)
                }
		if ($dnsStat -eq "tbd")
		{
		    $dnsStat="2"
		}
                $sql="UPDATE "+$fetchSubnet+" SET pingStatus='"+$pingStat+"', dnsStatus='"+$dnsStat+"', comment='"+$ipComment+"' WHERE ipAddr='"+$dr["ipAddr"].ToString()+"'"
		$line="SQL: "+$sql+"  \r\n"
                $sw.Write($line)
                $sqlErr=Write-EsmsDb($sql)
                if ($sqlErr -eq "")
                {
		    $line="DB Updated OK!\r\n"
                    $sw.Write($line)
                }
                else
                {
		    $line="DB ERROR:"+$sqlErr+"\r\n"
                    $sw.Write($line)
                }
                $sw.Write("\r\n\r\n")
            }
        }
    $sw.Close()
}
else
{
   write-host "ERR: Correct syntax is auditSubnet.ps1 <subnetName>"
   exit
}
