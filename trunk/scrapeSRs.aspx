<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="iTextSharp.text.pdf"%> 

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-15-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void storeDC(object sender, EventArgs e)
{
	string code="", sql="", cookieVal="";
	code=dcSelector.Value;

//	Fetch cookie to determine if it needs to be set anew, or just updated ...
	try
	{
		cookieVal=Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		cookieVal="";
	}
	if (cookieVal=="") // Set new cookie ...
	{
		HttpCookie cookie=new HttpCookie("selectedDc",code);
		cookie.Expires=DateTime.Now.AddDays(3);
		Response.Cookies.Add(cookie);
	}
	else // Update existing coolie ...
	{
		HttpCookie cookie=Request.Cookies["selectedDc"];
		cookie.Value=code;
		Response.Cookies.Add(cookie);
	}
	Response.Write("<script type='text/JavaScript'>document.location.reload("+"true);<"+"/script>");
}

public void Page_Load(Object o, EventArgs e)
{

/* Do all this to prepare ESMS for automated SR Database Updates
   ------------------------------------------------------------------------------------------------------------------
		CREATE TABLE serviceRequests (Id COUNTER PRIMARY KEY, srNum text(10), srTitle text(50), srDetailURL text(170), srCategory text(35), srRequestor text(150), srLastActionDate text(15), srStatus text(15))
		   ALTER TABLE serviceRequests ALTER COLUMN srRequestor text(150)
		   ALTER TABLE serviceRequests ALTER COLUMN srTitle text(50)

   ------------------------------------------------------------------------------------------------------------------ 


   Resultant DataTable Columns are:
	dt.Columns.Add("SRNumber")
	dt.Columns.Add("SRTitle")
	dt.Columns.Add("SRDetail")
	dt.Columns.Add("SRLastActionDate")
	dt.Columns.Add("SRStatus")
	dt.Columns.Add("SRCategory")
	dt.Columns.Add("SRRequestor")


   SR Base Categories - 3/8/11
   AHS Hostable
   -----------------------------
     Architecture &amp; Engineering
     Desktop and Office Automation
     Network
     Server

   Not AHS Hostable by Default 
   (No policy exists to make these categories unhostable, its just more efficient to assume these aren't for AHS)
   -----------------------------
     Service Level Attainment
     Business &amp; Investment
     Facilities Moves
     Telecom - Radio
     Telecom - Data and Voice

*/

		
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Scrape SRs";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", sqlCheck="", status="", sqlErr="", srSql="";
	string siteToScrape="", scrapedText="", scraped="";
	DataSet dat = new DataSet();
	DataSet datCheck= new DataSet();

	scrapeResult.DataSource=null;
	scrapeResult.DataBind();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	titleSpan.InnerHtml="<SPAN class='heading1'>SR Page Scraped</SPAN>";
//	siteToScrape = "http://sxpheesms002-dev.phe.fs.fed.us/srlist.html";
	siteToScrape = "http://fswebas.wo.fs.fed.us:7777/reports/pm_tracking/pm_rfc_status.jsp?pm_tracking";
	try
	{
		dat=getSRDataSet(siteToScrape);
		if (!emptyDataset(dat))
		{
			scrapeResult.DataSource=dat;
			scrapeResult.DataBind();
		}
	}
	catch (Exception ex)
	{
		scraped = "Cannot make a connection to " + siteToScrape + "<BR/><BR/> EXCEPTION: " + ex;
	}

	string srNum_fixed="", srTitle_fixed="", srDetailURL_fixed="", srCategory_fixed="", srRequestor_fixed="", srLastActionDate_fixed="", srStatus_fixed="";
	if (!emptyDataset(dat))
	{
//		scrapeResult.DataSource=dat;
//		scrapeResult.DataBind();

		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				if (dr["SRNumber"].ToString().Length > 10)
				{
					srNum_fixed=dr["SRNumber"].ToString().Substring(0,10).Trim();
				}
				else
				{
					srNum_fixed=dr["SRNumber"].ToString();
				}

				if (dr["SRTitle"].ToString().Length > 50)
				{
					srTitle_fixed=fix_txt(dr["SRTitle"].ToString().Substring(0,50).Trim());
				}
				else
				{
					srTitle_fixed=fix_txt(dr["SRTitle"].ToString());
				}

				if (dr["SRDetail"].ToString().Length > 170)
				{
					srDetailURL_fixed=dr["SRDetail"].ToString().Substring(0,170).Trim();
				}
				else
				{
					srDetailURL_fixed=dr["SRDetail"].ToString();
				}

				if (dr["SRCategory"].ToString().Length > 35)
				{
					srCategory_fixed=dr["SRCategory"].ToString().Substring(0,35).Trim();
				}
				else
				{
					srCategory_fixed=dr["SRCategory"].ToString();
				}

				if (dr["SRRequestor"].ToString().Length > 150)
				{
					srRequestor_fixed=Encrypt(dr["SRRequestor"].ToString().Substring(0,150).Trim());
				}
				else
				{
					srRequestor_fixed=Encrypt(dr["SRRequestor"].ToString());
				}

				if (dr["SRLastActionDate"].ToString().Length > 15)
				{
					srLastActionDate_fixed=dr["SRLastActionDate"].ToString().Substring(0,15).Trim();
				}
				else
				{
					srLastActionDate_fixed=dr["SRLastActionDate"].ToString();
				}

				if (dr["SRStatus"].ToString().Length > 15)
				{
					srStatus_fixed=dr["SRStatus"].ToString().Substring(0,15).Trim();
				}
				else
				{
					srStatus_fixed=dr["SRStatus"].ToString();
				}
				sqlErr="";
				sqlCheck="SELECT * FROM serviceRequests WHERE srNum='"+srNum_fixed+"'";
				datCheck=readDb(sqlCheck);
				if (datCheck!=null)
				{
					
					if (srLastActionDate_fixed!=datCheck.Tables[0].Rows[0]["srLastActionDate"].ToString())
					{
						srSql="UPDATE serviceRequests SET srTitle='"+srTitle_fixed+"', srDetailURL='"+srDetailURL_fixed+"', srCategory='"+srCategory_fixed+"', srRequestor='"+srRequestor_fixed+"', srLastActionDate='"+srLastActionDate_fixed+"', srStatus='"+srStatus_fixed+"' WHERE srNum='"+srNum_fixed+"'";
						Response.Write(srSql+"<BR/><BR/>");
						sqlErr=writeDb(srSql);
						if (sqlErr==null || sqlErr=="")
						{
							Response.Write("<SPAN class='italic'>UPDATE: Service Request Record Updated for SR"+srNum_fixed+"<BR/></SPAN>");
//							sqlSuccess=true;
						}
						else
						{
							Response.Write("<SPAN class='italic errorLine'>UPDERR: Service Request Record Update for SR"+srNum_fixed+". (Detail:"+sqlErr+")</SPAN><BR/>");
							writeChangeLog(dateStamp.ToString(), "ESMS-SRImport", "UPDERR: Service Request Record Update for SR"+srNum_fixed+". Detail:"+sqlErr+"("+sql+")", "E", 4444);
						}	
					}
					else
					{
						Response.Write("<SPAN class='italic'>NOACTION: SR"+srNum_fixed+" exists and has not been changed. <BR/></SPAN>");
					}
				}
				else
				{
					srSql="INSERT INTO serviceRequests(srNum,srTitle,srDetailURL,srCategory,srRequestor,srLastActionDate,srStatus) VALUES('"+srNum_fixed+"','"+srTitle_fixed+"','"+srDetailURL_fixed+"','"+srCategory_fixed+"','"+srRequestor_fixed+"','"+srLastActionDate_fixed+"','"+srStatus_fixed+"')";
					Response.Write(srSql+"<BR/><BR/>");
					sqlErr=writeDb(srSql);
					if (sqlErr==null || sqlErr=="")
					{
						Response.Write("<SPAN class='italic'>ADD: Service Request Record Added for SR"+srNum_fixed+"<BR/></SPAN>");
//						sqlSuccess=true;
					}
					else
					{
						Response.Write("<SPAN class='italic errorLine'>ADDERR: Service Request Record Added for SR"+srNum_fixed+" . (Detail:"+sqlErr+")</SPAN><BR/>");
						writeChangeLog(dateStamp.ToString(), "ESMS-SRImport", "ADDERR: Service Request Record Added for SR"+srNum_fixed+". Detail:"+sqlErr+"("+sql+")", "E", 4444);
					}	
				}
			}
		}
	}

	sql= "";
//	dat=readDb(sql);

	if (IsPostBack)
	{
	}
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file='banner.inc' -->
<!--#include file='menu.inc' -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<DIV>
				<ASP:datagrid id='scrapeResult' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
					<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
					<AlternatingItemStyle BackColor='#edf0f3' />
				</ASP:datagrid>
			</DIV>
		</DIV>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>