<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-14-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

 </head>
 <!--#include file="body.inc" -->

 <% Add-PSSnapin VMware.VimAutomation.Core %>
 <% $username = 'root' %>
 <% $vc       = '192.168.1.107' %>
 <% $profile  = 'C:\Log\' %>
 <% $password = 'B0n35mu66l3r' %>

 <% Connect-VIServer -Server $vc -User $username -Password $password %>

 <table>
 <tr>

 <% Get-VM | Select Name, powerstate, host, MemoryMB %>

 </tr>
 </table>

 <% Disconnect-VIServer * %>

 </body>
</html>