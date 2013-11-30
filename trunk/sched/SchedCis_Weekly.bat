@ECHO OFF

set esmsDir=C:\inetpub\ESMS-ABQDC\
set esmsUrl=http://localhost/esms-abqdc/

powershell -command "& '%esmsDir%powershell\maintIp_singleThread.ps1' "

