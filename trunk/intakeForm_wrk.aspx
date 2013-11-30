<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-12-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void Page_Load(Object o, EventArgs e)
{
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();

	sql= "";
//	dat=readDb(sql);

	if (IsPostBack)
	{

	}
	titleSpan.InnerHtml="AHS Intake Questionnaire";
}
</SCRIPT>
</HEAD>

<!--#include file='body.inc' -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file='banner.inc' -->
	<DIV id='popContent' class='center'>
		<SPAN id='titleSpan' runat='server'/>

		<TABLE border='1' class='datatable center'>
			<TR><TD class='center'>
				<TABLE>
					<TR>
						<TD class='inputform'>&#xa0;</TD>
						<TD class='inputform left middle' style='width:5px;'>&#xa0;</TD>
						<TD class='whiteRowFill' style='width:450px;'><DIV class='center'>Please answer all of these questions to the best of your ability.<BR/>Click on <IMG src='./img/help.png' alt='help' class='middle'> to get a more detailed explanation of the information requested.<BR/></DIV></TD>
					</TR>
					<TR>
						<TD class='intakeHeading' colspan='3'>Basic Engagement Information</TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Customer</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeCustomer' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Customer' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Service Request<BR/>(SR) Number</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeSR'	runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: SR Number' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Name of <BR/>Application</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeAppName' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: App. Name' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>App. Version</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeAppVer' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: App. Version' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Brief Description<BR/>(incl. DB type)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeAppDesc' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: App Description' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Desired Development<BR/> Start Date</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeDevStart' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Desired Dev. Date' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Desired Test(QA)<BR/>Start Date</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeTestStart' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Desired QA Date' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Desired Production<BR/> Start Date</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeProdStart' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Desired Prod. Date' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'>&#xa0;</TD>
						<TD class='lightColorFill right  middle' style='width:5px;'>&#xa0;</TD>
						<TD class='whiteRowFill'>&#xa0;</TD>
					</TR>
					<TR>
						<TD class='intakeHeading' colspan='3'>Engagement Contact Information</TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Business Unit Owner</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeBusUnitOwner' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Business Unit Owner' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Sponsor Name</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeSponsorName' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Sponsor' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Sponsor Email</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeSponsorEmail' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Sponsor Email' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Sponsor Office Phone</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeSponsorOfcPhone' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Sponsor Office Phone' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Sponsor Cell Phone</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeSponsorCellPhone' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Sponsor Cell Phone' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Technical Contact Name</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeTechContName' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Tech Contact' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Technical Contact Email</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeTechContEmail' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Tech Contact Email' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Technical Contact Office Phone</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeTechContOfcPhone' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Tech Contact Office Phone' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Technical Contact Cell Phone</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='text' size='30' id='intakeTechContCellPhone' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Tech Contact Cell Phone' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'>&#xa0;</TD>
						<TD class='lightColorFill right middle' style='width:5px;'>&#xa0;</TD>
						<TD class='whiteRowFill'>&#xa0;</TD>
					</TR>
					<TR>
						<TD class='intakeHeading' colspan='3'>Application Software Components</TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Oracle Application Server(10g R2, Linux)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='radio' id='intakeAppORAS' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: Oracle Application Server' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Microsoft IIS(Win2k3)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='radio' id='intakeAppMSIIS' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: MsIIS' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>ESRI ArcIMS(9.1, 9.2, Linux)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='radio' id='intakeAppArcIMS' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help:ArcIMS' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>ESRI ArcGIS(Java, Linux)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='radio' id='intakeAppArcGISJava' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help:ArcGIS' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>ESRI ArcGIS(.NET, Win2k3)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='radio' id='intakeAppArcGISdotNet' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help:ArcGIS' border='0'></SPAN></TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'>&#xa0;</TD>
						<TD class='lightColorFill right middle' style='width:5px;'>&#xa0;</TD>
						<TD class='whiteRowFill'>&#xa0;</TD>
					</TR>
					<TR>
						<TD class='lightColorFill right'><SPAN class='bold'>Oracle Database Server(10g R2)</SPAN></TD>
						<TD class='lightColorFill right middle' style='width:5px;'>:</TD>
						<TD class='whiteRowFill left middle' style='width:450px;'><INPUT type='radio' id='intakeAppORDB' runat='server'><SPAN  onclick="window.open('help.aspx','helpWin','width=200,height=200,menubar=no,status=yes,scrollbars=yes')"  class='nodec'><IMG src='./img/help.png' alt='Get Help: SR Number' border='0'></SPAN></TD>
					</TR>
				</TABLE>
		</TABLE>

	</DIV> <!-- End: popContent -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>