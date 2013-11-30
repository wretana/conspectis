<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 1-29-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
/// <summary>
///   The <see cref="doLogin(Object, EventArgs)"/> non-static void method is an event handler used authenticate a user against LDAP / Active Directory.
/// </summary>
/// <param name="s">
///   A <see cref="System.Object"/> containing the sender of the handled event.
/// </param>
/// <param name="s">
///   A <see cref="System.EventArgs"/> containing the EventArgs from the handled event.
/// </param>
/// <remarks>
///    This method performs an authentication against LDAP/AD.
/// </remarks>
public void doLogin(Object s, EventArgs e) 
{
	resultSpan.InnerHtml="";

	string sql="";
	DataSet dat = new DataSet();

	DateTime dateStamp = DateTime.Now;

	string adErrors="";
	string dbErrors="";
	string logErrors="";
	string username="", password="";

	username=formUser.Value;
	password=formPass.Value;

	string mail="";
	string firstName="";
	string lastName="";
	string userPhone="";
	string userClass="";
	string foundGroups="";
	string userRole="";

	bool result=false;
	bool conspectisSuper=false;
	bool conspectisAdmin=false;
	bool conspectisUser=false;
	bool conspectisWoDAdmin=false;
	bool conspectisWoDUser=false;

	bool needMail=false;
	bool needFirst=false;
	bool needLast=false;
	bool needPhone=false;
	bool foundUID=false;

	bool getUserInfo=false;

	StringCollection userGroups = new StringCollection();

	HttpCookie cookie;

//  Try LDAP/AD Authentication
	result=doADAuth(Encrypt(username), Encrypt(password));
	if (result==true)
	{
		conspectisSuper=isADUserGroupMember(username,ADSuperGroup);
		conspectisAdmin=isADUserGroupMember(username,ADAdminsGroup);
		conspectisUser=isADUserGroupMember(username,ADUsersGroup);
		conspectisWoDAdmin=isADUserGroupMember(username,ADWoDAdminsGroup);
		conspectisWoDUser=isADUserGroupMember(username,ADWoDUsersGroup);

		userClass =	(conspectisSuper)		? "99"	:
					(conspectisWoDAdmin)	? "5"	:
					(conspectisAdmin)		? "3"	:
					(conspectisWoDUser)	? "4"	:
					(conspectisUser)		? "1"	:				
									  "" ;

		foundGroups = 	(conspectisSuper)		? foundGroups+ADSuperGroup+" "	:
						(conspectisWoDAdmin)	? foundGroups+ADWoDAdminsGroup+" "	:
						(conspectisAdmin)		? foundGroups+ADAdminsGroup+" "	:
						(conspectisWoDUser)	? foundGroups+ADWoDUsersGroup+" "	:
						(conspectisUser)		? foundGroups+ADUsersGroup+" "	:
									  "" ;

		if (userClass!="") 
		{

			logErrors=writeChangeLog(dateStamp.ToString(), "AD-Auth", ""+sysName+" User '"+username+"' successfully logged in and granted access by following groups: "+foundGroups+".")+"<BR/>";

			sql=sqlEngine("adAuthGetAppUserInfoById",Encrypt(username));
			dat=readDb(sql);
			if (emptyDataset(dat))
			{
				sql=sqlEngine("adAuthAddAppUserId",Encrypt(username));
				dbErrors=writeDb(sql);
				if (dbErrors!="")
				{
					dbErrors=dbErrors+"SQL Update Error (Insert userId)"+dbErrors+"<BR/>";
					logErrors=writeChangeLog(dateStamp.ToString(), "AD-Auth", "Could not add user "+Encrypt(username)+" to "+sysName+" USERS Table:"+dbErrors)+"<BR/>";

				}
				else
				{
					foundUID=true;
				}
			}
			else
			{
				foundUID=true;
			}

			try
			{
				mail=getADUserProperty(username,"mail");
			}
			catch (Exception ex)
			{
				if (foundUID)
				{
					sql=sqlEngine("adAuthGetAppUserEmail",Encrypt(username));
					dat=readDb(sql);
					if (emptyDataset(dat))
					{
						mail = "" ;
					}
					else
					{
						needMail=false;
						mail=dat.Tables[0].Rows[0]["email"].ToString();
					}
				}
			}
			if (foundUID)
			{
				if (mail!="") 
				{
					sql=sqlEngine("adAuthUpdateAppUserEmailById",Encrypt(mail),Encrypt(username));
					dbErrors=writeDb(sql);
					if (dbErrors!="")
					{
						dbErrors=dbErrors+"SQL Update Error (Insert email)"+dbErrors+"<BR/>";
					}
					else
					{
						dbErrors=writeChangeLog(dateStamp.ToString(), "AD-Auth", ""+sysName+" local user record '"+username+"' synced 'EMAIL' with AD")+"<BR/>";
					}
				}
				else //Despite our best efforts,email is still empty ...
				{
				}
			}


			try
			{
				firstName=getADUserProperty(username,"givenName");
			}
			catch (Exception ex)
			{
				if (foundUID)
				{
					sql=sqlEngine("adAuthGetAppUserFirstById",Encrypt(username));
					dat=readDb(sql);
					if (emptyDataset(dat))
					{
						needFirst=true;
					}
					else
					{
						needFirst=false;
						firstName=dat.Tables[0].Rows[0]["userFirstName"].ToString();
					}
				}
			}
			if (foundUID)
			{
				if (firstName!="") //Despite our best efforts, firstName is still empty ...
				{
					sql=sqlEngine("adAuthUpdateAppUserFirstById",Encrypt(firstName),Encrypt(username));
					dbErrors=writeDb(sql);
					if (dbErrors!="")
					{
						dbErrors=dbErrors+"SQL Update Error (Insert userFirstName)"+dbErrors+"<BR/>";
					}
					else
					{
						dbErrors=writeChangeLog(dateStamp.ToString(), "AD-Auth", ""+sysName+" local user record '"+username+"' synced 'FIRSTNAME' with AD")+"<BR/>";
					}
				}
				else 
				{
					needFirst=true;
				}
				Response.Write(firstName+"<BR/>");
			}

		
			try
			{
				lastName=getADUserProperty(username,"sn");
			}
			catch (Exception ex)
			{
				if (foundUID)
				{
					sql=sqlEngine("adAuthGetAppUserLastById",Encrypt(username));
					dat=readDb(sql);
					if (emptyDataset(dat))
					{
						needLast=true;
					}
					else
					{
						needLast=false;
						lastName=dat.Tables[0].Rows[0]["userLastName"].ToString();
					}
				}
			}
			if (foundUID)
			{
				if (lastName!="") //Despite our best efforts, firstName is still empty ...
				{
					sql=sqlEngine("adAuthUpdateAppUserLastById",Encrypt(lastName),Encrypt(username));
					dbErrors=writeDb(sql);
					if (dbErrors!=null)
					{
						dbErrors=dbErrors+"SQL Update Error (Insert userLastName)"+dbErrors+"<BR/>";
					}
					else
					{
						dbErrors=writeChangeLog(dateStamp.ToString(), "AD-Auth", ""+sysName+" local user record '"+username+"' synced 'LASTNAME' with AD")+"<BR/>";
					}
				}
				else 
				{
					needLast=true;
				}
			}

		
			try
			{
				userPhone=getADUserProperty(username,"telephoneNumber");
			}
			catch (Exception ex)
			{
				if (foundUID)
				{
					sql=sqlEngine("adAuthGetAppUserPhoneById",Encrypt(username));
					dat=readDb(sql);
					if (emptyDataset(dat))
					{
						needPhone=true;	
					}
					else
					{
						needPhone=false;
						userPhone=dat.Tables[0].Rows[0]["userOfficePhone"].ToString();
					}
				}
			}
			if (foundUID)
			{
				if (userPhone!="") //Despite our best efforts, firstName is still empty ...
				{
					sql=sqlEngine("adAuthUpdateAppUserPhoneById",Encrypt(userPhone),Encrypt(username));
					dbErrors=writeDb(sql);
					if (dbErrors!=null)
					{
						dbErrors=dbErrors+"SQL Update Error (Insert userPhone)"+dbErrors+"<BR/>";
					}
					else
					{
						dbErrors=writeChangeLog(dateStamp.ToString(), "AD-Auth", ""+sysName+" local user record '"+username+"' synced 'PHONE' with AD")+"<BR/>";
					}
				}
				else
				{
					needPhone=true;
				}
			}

			try
			{
				userGroups=getADUserGroups(username);
			}
			catch (Exception ex)
			{
				Response.Write("Error fetching Groups: "+ex);
			}
			if (userGroups!=null)
			{
				sql = sqlEngine("adAuthGetRoleGroupValue");
				dat=readDb(sql);
				if (!emptyDataset(dat))
				{
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (userGroups.Contains("CN="+dr["roleGroup"]))
							{
								userRole=userRole+dr["roleValue"]+" ";
							}
						}
					}
				}
			}
			if (foundUID)
			{
				sql=sqlEngine("adAuthGetUserRoleById",Encrypt(username));
				dat=readDb(sql);
				if (!emptyDataset(dat))
				{
					try
					{
						userRole=userRole+dat.Tables[0].Rows[0]["userRole"].ToString();
					}
					catch (Exception ex)
					{
						userRole="";
					}
					
				}
			}
			if (needMail || needFirst || needLast || needPhone)
			{
				ViewState["userId"] = Encrypt(username);
				if (needMail)
				{
					Response.Write("Need EMail!<BR/>");
				}
				else
				{
					ViewState["userEmail"] = Encrypt(mail);
				}

				if (needFirst)
				{
					Response.Write("Need First Name!<BR/>");
				}
				else
				{
					ViewState["userFirst"] = Encrypt(firstName);
					cookie=new HttpCookie("firstname",Encrypt(firstName));
					cookie.Expires=DateTime.Now.AddDays(3);
					Response.Cookies.Add(cookie);
				}

				if (needLast)
				{
					Response.Write("Need Last Name!<BR/>");
				}
				else
				{
					ViewState["userLast"] = Encrypt(lastName);
					cookie=new HttpCookie("lastname",Encrypt(lastName));
					cookie.Expires=DateTime.Now.AddDays(3);
					Response.Cookies.Add(cookie);
				}

				if (needPhone)
				{
					Response.Write("Need Phone!<BR/>");
				}
				else
				{
					ViewState["userPhone"] = Encrypt(userPhone);
					cookie=new HttpCookie("officephone",Encrypt(userPhone));
					cookie.Expires=DateTime.Now.AddDays(3);
					Response.Cookies.Add(cookie);
				}

				if (userRole=="")
				{
					Response.Write("Need Role!<BR/>");
				}
				else
				{
					ViewState["userRole"] = userRole;
				}


				cookie=new HttpCookie("username",Encrypt(username));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("class",userClass);
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("role",userRole);
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				Response.Redirect("userInfo.aspx");
			}
			else
			{
				cookie=new HttpCookie("username",Encrypt(username));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("firstname",Encrypt(firstName));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("lastname",Encrypt(lastName));
				cookie.Expires=DateTime.Now.AddDays(3);
				Response.Cookies.Add(cookie);
				cookie=new HttpCookie("officephone",Encrypt(userPhone));
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

		} // if userClass
		else
		{
			adErrors="AD Auth was successful, but <SPAN class='italic'>"+username+"</SPAN> has not been granted access to this system!  Please contact "+sysEmail+"";
		}
	}
	else // Try Local Windows Authentication
	{
	}
	adErr.InnerHtml="AD: "+adErrors;
	dbErr.InnerHtml="DB: "+dbErrors;
	resultSpan.InnerHtml="AD Logon for user '"+username+"' :"+result.ToString();
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
//	lockout();
	Page.Header.Title=shortSysName+": Login";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string  v_username, v_password, sql;
	DataSet dat=new DataSet();

			
	// If by chance a user is already registered & logged in, redirect away from this page
	try
	{
		v_username=Request.Cookies["username"].Value;
		Response.Redirect("main.aspx");
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	if(IsPostBack)
	{
		v_username = fix_txt(formUser.Value);
		v_password = fix_txt(formPass.Value);

		formUser.Style["background"]="white";
		formPass.Style["background"]="white";
		errmsg.InnerHtml="";
		if (v_username!="" && v_password!="")
		{
		}
		else
		{
			errmsg.InnerHtml="Please enter your username and password!";
			if (v_username=="") formUser.Style["background"]="red";
			if (v_password=="") formPass.Style["background"]="red";
		}
	}
	titleSpan.InnerHtml="Login to "+sysName;
	advisorySpan.InnerHtml="&nbsp";
	noteSpan.InnerHtml="&nbsp;";
	resultSpan.InnerHtml="&nbsp;";
//	MOVE TO SETTINGS TABLE!!
	warnDiv.InnerHtml="<DIV class='center bold'>THIS IS A PRIVATE COMPUTER SYSTEM.</DIV><DIV class='justify'>This computer system including all related equipment, network devices  (specifically including Internet access), are provided only for authorized use. All computer systems may be  monitored for all lawful purposes, including to ensure that their use is authorized, for management of the  system, to facilitate protection against unauthorized access, and to verify security procedures, survivability  and operational security. Monitoring includes active attacks by authorized personnel and their entities to test  or verify the security of the system. During monitoring, information may be examined, recorded, copied and used  for authorized purposes. All information including personal information, placed on or sent over this system may  be monitored. Uses of this system, authorized or unauthorized, constitutes consent to monitoring of this system. Unauthorized use may subject you to criminal prosecution. Evidence of any such unauthorized use collected during monitoring may be used for administrative, criminal or other adverse action. Use of this system constitutes  consent to monitoring for these purposes.</DIV>";
	
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file="banner.inc" -->

	<DIV id='menu'>
	</DIV> <!-- End: menu -->

	<DIV id='content'>
		<BR/>
		<DIV class='center'>
			<SPAN id='titleSpan' class='heading1' runat='server'/>
			<SPAN class='heading2'></SPAN>
			<DIV id='adErr' class='errorLine' runat='server'/>
			<DIV id='dbErr' class='errorLine' runat='server'/>
			<SPAN id='errmsg' class='errorLine' runat='server'/>
			<SPAN id='resultSpan' class='statusLine' runat='server'/>
			<BR/>
			<SPAN id='advisorySpan' runat='server' />
			<SPAN id='noteSpan' class='italic' runat='server'/>
			<DIV id='adAuthLogonBox' class='paleColorFill'>
				<DIV>
					<SPAN class='bold'>Username:</SPAN>
					<SPAN><INPUT type='text' id='formUser' size='25' runat='server'></SPAN>
				</DIV>
				<DIV>
					<SPAN class='bold'>Password:</SPAN>
					<SPAN><INPUT type='password' id='formPass' size='25' runat='server'></SPAN>
				</DIV>
				<DIV>
					<BR/>
					<BUTTON id='loginButton' OnServerClick='doLogin' runat='server' UseSubmitBehavior='true'>&nbsp; &nbsp; &nbsp; Login &nbsp; &nbsp; &nbsp;</BUTTON>
				</DIV>			
			</DIV> 
			<BR/><BR/><BR/><BR/><BR/><BR/><BR/><BR/><BR/><BR/><BR/>
			
			<BR/><BR/><BR/>
			<DIV id='warnDiv' class='justify' style='padding:0px 20px;' runat='server' />
		</DIV>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>