##################################################
#                                                #
# ESMS Powershell Script Template                #
#                                                #
#   Desc:                                        #
# Author:                                        #
#   Date:                                        #
#                                                #
##################################################

## This brings the ESMS.esmsLibrary class into our Powershell session. 
## All STATIC properties and methods from esmsLibrary.cs can be used in PowerShell
Import-Module c:\inetpub\ESMS-ABQDC\powershell\Get-EsmsLibrary.psm1 -ArgumentList 'ABQDC-DEV'

## EXAMPLE
# [ESMS.esmsLibrary]::doPing("170.144.133.90")