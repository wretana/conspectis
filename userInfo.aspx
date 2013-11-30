<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 STatus:  -->
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
//UNCOMMENT this line to force login to access this page.
//	lockout(); 
	Page.Header.Title=shortSysName+": Login - Missing User Info Needed";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string  v_username="", v_password, sql;
	string firstName="", lastName="", officePhone="", userClass="", userRole="";
	string sqlErr="";
	DataSet dat=new DataSet();
	HttpCookie cookie;

	try
	{
		v_username=Decrypt(Request.Cookies["username"].Value);
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	try
	{
		userClass=Request.Cookies["class"].Value;
	}
	catch (System.Exception ex)
	{
		userClass="";
	}	
	
	try
	{
		userRole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		userRole="";
	}

	// If by chance a user is already registered &amp; logged in, redirect away from this page
	try
	{
		firstName=Request.Cookies["firstname"].Value;
		lastName=Request.Cookies["lastname"].Value;
		officePhone=Request.Cookies["officephone"].Value;
	}
	catch (System.Exception ex)
	{
	}

	if (firstName!="" && lastName!="" && officePhone!="")
	{
		Response.Redirect("main.aspx");
	}

	if (!IsPostBack)
	{
		if (firstName!="")
		{
			formFirst.Value=Decrypt(firstName);
		}

		if (lastName!="")
		{
			formLast.Value=Decrypt(lastName);
		}

		if (officePhone!="")
		{
			formPhone.Value=Decrypt(officePhone);
		}
	}
//	Response.Write(v_username);



	if(IsPostBack)
	{
		firstName=formFirst.Value;
		lastName=formLast.Value;
		officePhone=formPhone.Value;

		if (firstName!="" && lastName!="" && officePhone !="")
		{
			Response.Write("UserId:"+v_username+"<BR/>");
			Response.Write("First Name:"+firstName+"<BR/>");
			Response.Write("Last Name:"+lastName+"<BR/>");
			Response.Write("First Name:"+officePhone+"<BR/>");
			Response.Write("User Class:"+userClass+"<BR/>");
			Response.Write("User Role:"+userRole+"<BR/><BR/>");
			sql="UPDATE users SET userFirstName='"+Encrypt(firstName)+"', userLastName='"+Encrypt(lastName)+"', userOfficePhone='"+Encrypt(officePhone)+"' WHERE userId='"+Encrypt(v_username)+"'";
			Response.Write(sql+"<BR/><BR/>");
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				cookie=new HttpCookie("username",Encrypt(v_username));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("firstname",Encrypt(firstName));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("lastname",Encrypt(lastName));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("officephone",Encrypt(officePhone));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("class",userClass);
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("role",userRole);
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				if (lastpage!="")
					Response.Redirect(lastpage);
				else
					Response.Redirect("main.aspx");				
			}
			else
			{
				Response.Write(sqlErr);
			}
		}
	}
}
</SCRIPT>

</HEAD>

<!--#include file="body.inc" -->
<TABLE width="100%" border="" cellpadding="0" cellspacing="0">
<TR>
	<TD width="15%" valign="top" bgcolor="#669966" align="center">&#xa0;
	</TD>
	<TD width="85%" valign="top">
		<TABLE width="100%" height="100%" border="" cellpadding="2" cellspacing="0">
		<TR>
			<TD bgcolor="#ffffff" valign="top">
				<BR/>
<!--				<DIV class='center'>
					<A HREF="intakeForm.aspx" class="nodec"><IMG src="./img/intake.png" border=""></A>
				</DIV> -->
				<BR/>
				<SPAN class='heading1'>Need User Info to Complete Login</SPAN>
				<FORM runat="server">
					<P>It looks like this is your first logon to the system and we may have had some trouble pulling all of your user info from Active Directory.  Please fill out the following fields.</P>
					<SPAN class='heading2'></SPAN>
					<DIV class='center'>
						<P><SPAN class='italic'><SPAN class='bold'>NOTE:</SPAN> At every logon the system will try to pull this info from Active Directory, so this may get updated / changed at a later time.</SPAN></P>
						<TABLE border="1" class="datatable" cellpadding="0" cellspacing="0">
						<TR><TD>
							<TABLE cellspacing="0">
								<TR><TD class="inputform" colspan="2"><DIV id="errmsg" class="errorLine" runat="server"/></TD></TR>
								<TR><TD class="inputform"><SPAN class='bold'>First Name:</SPAN></TD><TD><INPUT type="text" id="formFirst" size="14" runat="server"></TD></TR>
								<TR><TD class="inputform"><SPAN class='bold'>Last Name:</SPAN></TD><TD><INPUT type="text" id="formLast" size="14" runat="server"></TD></TR>
								<TR><TD class="inputform"><SPAN class='bold'>Office Phone:</SPAN></TD><TD><INPUT type="text" id="formPhone" size="14" runat="server"></TD></TR>
							</TABLE>
						</TABLE><BR/><INPUT type="submit" value="Continue Login ..." runat="server">
						<BR/><BR/><BR/>
					</DIV>
				</FORM>
<!--#include file="closer.inc"-->
</BODY>
</HTML>