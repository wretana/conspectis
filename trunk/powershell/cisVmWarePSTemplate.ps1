##################################################
#                                                #
# ESMS & vSphere Powershell Script Template      #
#                                                #
#   Desc:                                        #
# Author:                                        #
#   Date:                                        #
#                                                #
##################################################

## This brings the ESMS.esmsLibrary class into our Powershell session. 
## All STATIC properties and methods from esmsLibrary.cs can be used in PowerShell
Import-Module c:\inetpub\esms\powershell\Get-EsmsLibrary.psm1

## This brings the "vmware.vim" class and the VIToolkit for Windows Community Extensions into our Powershell session. 
## http://vitoolkitextensions.codeplex.com/
Import-Module c:\inetpub\esms\powershell\viToolkitExtensions.psm1

## EXAMPLE
# [ESMS.esmsLibrary]::doPing("170.144.133.90")