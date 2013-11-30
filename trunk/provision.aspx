<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-14-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void showReq(string sql, string scope)
{
	DataSet dat=new DataSet();
	string scopeStr="";
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;

	string v_userclass="", v_userrole="";
	try
	{
		v_userclass=Request.Cookies["class"].Value;
	}
	catch (System.Exception ex)
	{
		v_userclass="1";
	}

	try
	{
		v_userrole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		v_userrole="";
	}

	if (v_userclass!="99" && v_userclass!="3") errmsg.InnerHtml="NOTE: You are not permitted to provision new servers. <BR/>You may only view available rackspace.";

//	bool sqlSuccess=true;
	switch (scope)
	{
	case "any":
		scopeStr="All Available Rackspace";
		break;
	case "blades":
		scopeStr="Available Blades";
		break;
	case "xseries":
		scopeStr="Available Rackmounts";
		break;
	case "aix":
		scopeStr="P-Series Available Rackspace";
		break;
	}

	if (sql!="")
	{
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","7");
					td.InnerHtml = scopeStr;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Model";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "SAN";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Row/Cabinet";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "BC";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Slot";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							if (v_userclass=="3" || v_userclass=="99")
							{
								if (drr["serverName"].ToString()=="")
								{
									td.InnerHtml = "<P class='center blackLink'  onclick=\"window.open('newServer.aspx?rackspace="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">New Server</P></DIV>";
								}
								else
								{
									td.InnerHtml = "<P class='center blackLink'  onclick=\"window.open('editServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
								}
							}
							else
							{
								if (drr["serverName"].ToString()=="")
								{
									td.InnerHtml = "Unassigned";
								}
								else
								{
									td.InnerHtml = "<P class='center blackLink'  onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','showServerWin','width=315,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["class"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = "<DIV class='center'>"+drr["class"].ToString()+"</DIV>";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["sanAttached"].ToString()=="")
							{
								td.InnerHtml = "<DIV class='center'>--</DIV>";
							}
							else
							{
								if (drr["sanAttached"].ToString()=="1")
								{
									td.InnerHtml="<DIV class='center'>Yes</DIV>";
								}
								else
								{
									td.InnerHtml="<DIV class='center'>No</DIV>";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["rack"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								string sqlRack="", rackString="";
								DataSet datRack=new DataSet();
								sqlRack="SELECT location, rackId FROM "+drr["dcPrefix"].ToString()+"racks WHERE rackId='"+drr["rack"].ToString()+"'";
//								Response.Write(sqlRack+"<BR/>");
								datRack=readDb(sqlRack);
								if (datRack!=null)
								{
									try
									{
										rackString=datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
									}
									catch (System.Exception ex)
									{
										rackString="ERR";
									}
								}
								td.InnerHtml = "<DIV class='center'>"+rackString+"</DIV>";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["bc"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = "<DIV class='center'>"+drr["bc"].ToString()+"</DIV>";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = "<DIV class='center'>"+drr["slot"].ToString()+"</DIV>";
							}
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
		else
		{
			errmsg.InnerHtml="Empty Dataset!<BR/>"+sql;
		}
	}
	else
	{
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = scopeStr;
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Model";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "SAN";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Row/Cabinet";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "BC";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Slot";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml="<SPAN class='center errorBox'>No free rackspace found.</SPAN>";
				td.Attributes.Add("colspan","4");
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
	}
}

public void goProvision(object sender, EventArgs e)
{
	Response.Write("<script>window.location.href='"+rackChoice.Value+"';<"+"/script>");
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Provision New Server";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql="";
	DataSet dat = new DataSet();
	HttpCookie cookie;

	string req="";
	string scope="";

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	try
	{
		req=Request.QueryString["req"].ToString();
	}
	catch (System.Exception ex)
	{
		req="";
	}

	string dcArg="";
	try
	{
		dcArg=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcArg= "";
	}

	if (req!="" && dcArg!="")
	{
		switch (req)
		{
		case "any":
			switch (sqlDialect)
			{
				case "MSJET" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM ("+dcArg+"rackspace LEFT JOIN [SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2']. AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND class<>'Virtual' AND serverName IS NULL ORDER BY class ASC, rack ASC, bc ASC, slot ASC) WHERE rack<>'0000'";
					break;
				case "MSSQL" :
					sql="SELECT * FROM (SELECT * FROM (SELECT E1.serverName, "+dcArg+"rackspace.rack, "+dcArg+"rackspace.bc, "+dcArg+"rackspace.slot, "+dcArg+"rackspace.class, "+dcArg+"rackspace.sanAttached, "+dcArg+"rackspace.dcPrefix, "+dcArg+"rackspace.rackspaceId, "+dcArg+"rackspace.reserved FROM "+dcArg+"rackspace LEFT JOIN (SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2') AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId) AS a WHERE reserved<>'1' AND class<>'Virtual' AND serverName IS NULL) AS b WHERE rack<>'0000' ORDER BY class ASC, rack ASC, bc ASC, slot ASC";
					break;
			}
			if (sql!="")
			{
				showReq(sql,req);
			}
			else
			{
				errmsg.InnerHtml="<BR/>No SQL query for '"+req+"' on "+sqlDialect+"<BR/>";
			}
			scope="Any";
			break;
		case "blades":
			switch (sqlDialect)
			{
				case "MSJET" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM ("+dcArg+"rackspace LEFT JOIN [SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2']. AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND class<>'Virtual' AND serverName IS NULL) WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Blade') ORDER BY bc ASC, slot ASC";
					break;
				case "MSSQL" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT E1.serverName, "+dcArg+"rackspace.rack, "+dcArg+"rackspace.bc, "+dcArg+"rackspace.slot, "+dcArg+"rackspace.class, "+dcArg+"rackspace.sanAttached, "+dcArg+"rackspace.dcPrefix, "+dcArg+"rackspace.rackspaceId, "+dcArg+"rackspace.reserved FROM "+dcArg+"rackspace LEFT JOIN (SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2') AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId) AS a WHERE reserved<>'1' AND class<>'Virtual' AND serverName IS NULL) AS b WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Blade')) AS c WHERE rack<>'0000' ORDER BY bc ASC, slot ASC";
					break;
			}
			if (sql!="")
			{
				showReq(sql,req);
			}
			else
			{
				errmsg.InnerHtml="<BR/>No SQL query for '"+req+"' on "+sqlDialect+"<BR/>";
			}
			scope="Blades";
			break;
		case "xseries":
			switch (sqlDialect)
			{
				case "MSJET" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM ("+dcArg+"rackspace LEFT JOIN [SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2']. AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND class<>'Virtual' AND serverName IS NULL ) WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Server' AND hwClassName<>'Virtual' AND hwClassName<>'B50' AND hwClassName NOT LIKE 'RSA%' AND hwClassName NOT LIKE 'P%')ORDER BY class ASC, rack ASC, bc ASC, slot ASC) WHERE rack<>'0000'";
					break;
				case "MSSQL" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT E1.serverName, "+dcArg+"rackspace.rack, "+dcArg+"rackspace.bc, "+dcArg+"rackspace.slot, "+dcArg+"rackspace.class, "+dcArg+"rackspace.sanAttached, "+dcArg+"rackspace.dcPrefix, "+dcArg+"rackspace.rackspaceId, "+dcArg+"rackspace.reserved FROM "+dcArg+"rackspace LEFT JOIN (SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2') AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId) AS a WHERE reserved <>'1' AND class <>'Virtual' AND serverName IS NULL) AS b WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Server' AND hwClassName<>'Virtual' AND hwClassName<>'B50' AND hwClassName NOT LIKE 'RSA%' AND hwClassName NOT LIKE 'P%')) AS c WHERE rack<>'0000' ORDER BY class ASC, rack ASC, bc ASC, slot ASC";
					break;
			}
			if (sql!="")
			{
				showReq(sql,req);
			}
			else
			{
				errmsg.InnerHtml="<BR/>No SQL query for '"+req+"' on "+sqlDialect+"<BR/>";
			}
			scope="Rackmounts";
			break;
		case "aix":
			switch (sqlDialect)
			{
				case "MSJET" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM ("+dcArg+"rackspace LEFT JOIN [SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2']. AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND serverName IS NULL) WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Server' AND hwClassName<>'B50' AND hwClassName NOT LIKE 'RSA%' AND hwClassName LIKE 'P%') OR model LIKE 'P%Virtual' ORDER BY class ASC, rack ASC, bc ASC, slot ASC) WHERE rack<>'0000'";
					break;
				case "MSSQL" :
					sql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT E1.serverName, "+dcArg+"rackspace.rack, "+dcArg+"rackspace.bc, "+dcArg+"rackspace.slot, "+dcArg+"rackspace.class, "+dcArg+"rackspace.model, "+dcArg+"rackspace.sanAttached, "+dcArg+"rackspace.dcPrefix, "+dcArg+"rackspace.rackspaceId, "+dcArg+"rackspace.reserved FROM "+dcArg+"rackspace LEFT JOIN (SELECT * FROM "+dcArg+"servers WHERE serverOS<>'RSA2') AS E1 ON "+dcArg+"rackspace.rackspaceId = E1.rackspaceId) AS a WHERE reserved<>'1' AND serverName IS NULL) AS b WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Server' AND hwClassName<>'B50' AND hwClassName NOT LIKE 'RSA%' AND hwClassName LIKE 'P%') OR model LIKE 'P%Virtual') AS c WHERE rack<>'0000' ORDER BY class ASC, rack ASC, bc ASC, slot ASC";
					break;
			}
			if (sql!="")
			{
				showReq(sql,req);
			}
			else
			{
				errmsg.InnerHtml="<BR/>No SQL query for '"+req+"' on "+sqlDialect+"<BR/>";
			}
			scope="pSeries";
			break;
		}
	}
	if (scope!="")
	{
		titleSpan.InnerHtml=dcArg.ToUpper().Replace("_","")+" - "+scope;
	}
	else
	{
		titleSpan.InnerHtml=dcArg.ToUpper().Replace("_","");
	}

//	Response.Write(req);
	if (IsPostBack)
	{
//		Response.Write("Hola...");
	}

	if (!IsPostBack)
	{
		ListItem li0 = new ListItem("None","provision.aspx");
		ListItem li1 = new ListItem("Any Available Rackspace","provision.aspx?req=any&dc="+dcArg);
		ListItem li2 = new ListItem("Available Blades","provision.aspx?req=blades&dc="+dcArg);
		ListItem li3 = new ListItem("Available Rackmounts","provision.aspx?req=xseries&dc="+dcArg);
		ListItem li4 = new ListItem("P-Series Avail. Rackspace","provision.aspx?req=aix&dc="+dcArg);
		rackChoice.Items.Add(li0);
		rackChoice.Items.Add(li1);
		rackChoice.Items.Add(li2);
		rackChoice.Items.Add(li3);
		rackChoice.Items.Add(li4);
//		rackChoice.SelectedIndex=rackChoice.Items.IndexOf(rackChoice.Items.FindByValue("provision.aspx")); 
	}
	titleSpan.InnerHtml="Provision Server";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		<DIV class='center paleColorFill'>
			&nbsp;<BR/>
			<DIV class='center'>
				<SPAN class='center heading2'>Provision New Server In:</SPAN><BR/>
				<SELECT id='rackChoice' onchange='javascript:baseform.submit();' onserverchange='goProvision' runat='server' />
				<BR/><BR/>
				<DIV class='center'>
					<TABLE id='svrTbl' runat='server' class='datatable'/>
				</DIV>
				<BR/>
				<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
			&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>