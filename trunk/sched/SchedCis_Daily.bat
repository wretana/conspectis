@ECHO OFF

set esmsDir=C:\inetpub\ESMS-ABQDC\
set esmsUrl=http://localhost/esms-abqdc/

powershell -command "& '%esmsDir%vmware\ESMS-VICExport.ps1' "

del %esmsDir%vmware\import\-*.csv

REM CMD /C "C:\Program Files\Internet Explorer\iexplore.exe" %esmsUrl%import_vmware.aspx
START %esmsUrl%import_vmware.aspx
REM taskkill /IM iexplore.exe
