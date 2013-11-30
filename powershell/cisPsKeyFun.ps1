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
# Pass - ESMSv3weA2KeMnrAu3Esq
# Salt - ESMSv3By3BumRaNai2eRa

# VMWare - t2p7OtiHKgjhtaRNih8ZM5hFy2O+hekNgcMywx/wcn1ZvdVTQMTIomurw2wbameQ
# Vbox - t2p7OtiHKgjhtaRNih8ZM0tCCLQjO2IsEDBZ7y2I1wYWyUZo6sm5hMyce6HzHky3
# TADDM - t2p7OtiHKgjhtaRNih8ZM9+35LV2UwPgjxlZ5HI/9/Xm2MSrSMQHLyM7znYJW3wA
# JIRA - t2p7OtiHKgjhtaRNih8ZM4ykRD2QWwXQmz8+5c2ScPvrewPG5b07G2youk7X83g0

[ESMS.esmsLibrary]::Encrypt("chrisknight@fs.fed.us#VMWare vSphere SDK","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")
[ESMS.esmsLibrary]::Encrypt("chrisknight@fs.fed.us#VirtualBox API","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")
[ESMS.esmsLibrary]::Encrypt("chrisknight@fs.fed.us#TADDM MQL API","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")
[ESMS.esmsLibrary]::Encrypt("chrisknight@fs.fed.us#JIRA REST API","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")

[ESMS.esmsLibrary]::Decrypt("t2p7OtiHKgjhtaRNih8ZM5hFy2O+hekNgcMywx/wcn1ZvdVTQMTIomurw2wbameQ","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")
[ESMS.esmsLibrary]::Decrypt("t2p7OtiHKgjhtaRNih8ZM0tCCLQjO2IsEDBZ7y2I1wYWyUZo6sm5hMyce6HzHky3","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")
[ESMS.esmsLibrary]::Decrypt("t2p7OtiHKgjhtaRNih8ZM9+35LV2UwPgjxlZ5HI/9/Xm2MSrSMQHLyM7znYJW3wA","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")
[ESMS.esmsLibrary]::Decrypt("t2p7OtiHKgjhtaRNih8ZM4ykRD2QWwXQmz8+5c2ScPvrewPG5b07G2youk7X83g0","@1B2c3D4e5F6g7H8","ESMSv3By3BumRaNai2eRa","ESMSv3weA2KeMnrAu3Esq","SHA1",1,128,"")