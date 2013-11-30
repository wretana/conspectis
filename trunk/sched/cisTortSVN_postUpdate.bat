@echo off
rem TortoiseSVN Client Side post-update hook script
rem Put this into a Hooks folder on your workstation
rem with the accompanying script
rem
rem Tortoise SVN will call this script with the following parameters
rem after the commit action
rem
rem script <PATH> <DEPTH> <REVISION> <ERROR> <CWD>

set tsvnPath=%~1
set tsvnDepth=%~2
set tsvnRevision=%~3
set tsvnError=%~4
set tsvnCwd=%~5

echo powershell -command "& '%tsvnCwd%\powershell\ESMS_tortSVN_postUpdate.ps1' %tsvnRevision% %tsvnCwd%" > c:\tmp\lastEsmsPostUpdate.log
powershell -command "& '%tsvnCwd%\powershell\ESMS_tortSVN_postUpdate.ps1' %tsvnRevision% %tsvnCwd%"