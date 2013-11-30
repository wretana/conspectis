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

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Switch Port Detail";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sql1, sql2;
	DataSet dat, dat1, dat2;
	HttpCookie cookie;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill=false;
	bool sqlSuccess=true;
	string access="", port="", accessStr="", dcPrefix="";
	string v_userclass="", v_userrole="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		access=Request.QueryString["switch"].ToString();
	}
	catch (System.Exception ex)
	{
		access="";
	}

	try
	{
		port=Request.QueryString["portid"].ToString();
	}
	catch (System.Exception ex)
	{
		port="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

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

	if (!IsPostBack)
	{
//		Response.Write(access+", ");
//		Response.Write(port);
		sql ="SELECT * FROM "+access+" WHERE portId="+port;
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			switch (access)
			{
				case "accessA":
					accessStr="Access A";
					break;
				case "accessB":
					accessStr="Access B";
					break;
				case "accessC":
					accessStr="Access C";
					break;
				case "accessD":
					accessStr="Access D";
					break;
			}
//			Response.Write(dat.Tables[0].Rows[0]["comment"].ToString());
			switchPort.InnerHtml=accessStr+"<BR/>Slot "+dat.Tables[0].Rows[0]["slot"].ToString()+", Port "+dat.Tables[0].Rows[0]["portNum"].ToString();
			if (dat.Tables[0].Rows[0]["reserved"].ToString()!="1")
			{
				sql1="SELECT * FROM "+dcPrefix+"rackspace WHERE rackspaceId="+dat.Tables[0].Rows[0]["cabledTo"].ToString();
				try
				{
					dat1=readDb(sql1);
				}
				catch (System.Exception ex)
				{
					dat1=null;
				}
				if (!emptyDataset(dat1))
				{
					fill=false;
					tr = new HtmlTableRow();    //Output <TR>
						tr.Attributes.Add("class","blackheading");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("colspan","7");
							td.InnerHtml = "Directly Cabled to Port";
						tr.Cells.Add(td);         //Output </TD>
					directTbl.Rows.Add(tr);           //Output </TR>
					tr = new HtmlTableRow();    //Output <TR>
						tr.Attributes.Add("class","tableheading");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "Class";
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
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "NIC";
						tr.Cells.Add(td);         //Output </TD>
					directTbl.Rows.Add(tr);           //Output </TR>
					foreach (DataTable dt in dat1.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							tr = new HtmlTableRow();    //Output <TR>
							if (fill)
							{
								tr.Attributes.Add("class","altrow");
							} else tr.Attributes.Add("class","whiteRowFill");
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","center");
									if (dr["class"].ToString()=="")
									{
										td.InnerHtml = "&#xa0;";
									}
									else
									{
										td.InnerHtml = dr["class"].ToString();
									}
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","center");
									if (dr["rack"].ToString()=="")
									{
										td.InnerHtml = "&#xa0;";
									}
									else
									{
										td.InnerHtml = "Row:"+dr["rack"].ToString().Substring(0,2)+", Cabinet:"+dr["rack"].ToString().Substring(2,2);
									}
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","center");
									if (dr["bc"].ToString()=="")
									{
										td.InnerHtml = "&#xa0;";
									}
									else
									{
										td.InnerHtml = dr["bc"].ToString();
									}
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","center");
									if (dr["slot"].ToString()=="")
									{
										td.InnerHtml = "&#xa0;";
									}
									else
									{
										td.InnerHtml = dr["slot"].ToString();
									}
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","center");
									if (dat.Tables[0].Rows[0]["comment"].ToString()=="")
									{
										td.InnerHtml = "&#xa0;";
									}
									else
									{
										td.InnerHtml = dat.Tables[0].Rows[0]["comment"].ToString();
									}
								tr.Cells.Add(td);         //Output </TD>
							directTbl.Rows.Add(tr);           //Output </TR>
							fill=!fill;
						}
					}
					if (dat1.Tables[0].Rows[0]["bc"].ToString()!="")
					{
						sql2="SELECT * FROM (SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE bc='"+dat1.Tables[0].Rows[0]["bc"].ToString()+"') WHERE slot<>'00'";
						try
						{
							dat2=readDb(sql2);
						}
						catch (System.Exception ex)
						{
							dat2=null;
						}
						if (!emptyDataset(dat2))
						{
							fill=false;
							tr = new HtmlTableRow();    //Output <TR>
								tr.Attributes.Add("class","blackheading");
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("colspan","7");
									td.InnerHtml = "Indirectly Associated";
								tr.Cells.Add(td);         //Output </TD>
							indirectTbl.Rows.Add(tr);           //Output </TR>
							tr = new HtmlTableRow();    //Output <TR>
								tr.Attributes.Add("class","tableheading");
								td = new HtmlTableCell(); //Output <TD>
									td.InnerHtml = "HostName";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.InnerHtml = "Class";
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
							indirectTbl.Rows.Add(tr);           //Output </TR>
							foreach (DataTable dt in dat2.Tables)
							{
								foreach (DataRow dr in dt.Rows)
								{
									tr = new HtmlTableRow();    //Output <TR>
									if (fill)
									{
										tr.Attributes.Add("class","altrow");
									} else tr.Attributes.Add("class","whiteRowFill");
										td = new HtmlTableCell(); //Output <TD>
											td.Attributes.Add("class","center");
											if (dr["serverName"].ToString()=="")
											{
												td.InnerHtml = "&#xa0;";
											}
											else
											{
												td.InnerHtml = dr["serverName"].ToString();
											}
										tr.Cells.Add(td);         //Output </TD>
										td = new HtmlTableCell(); //Output <TD>
											td.Attributes.Add("class","center");
											if (dr["class"].ToString()=="")
											{
												td.InnerHtml = "&#xa0;";
											}
											else
											{
												td.InnerHtml = dr["class"].ToString();
											}
										tr.Cells.Add(td);         //Output </TD>
										td = new HtmlTableCell(); //Output <TD>
											td.Attributes.Add("class","center");
											if (dr["rack"].ToString()=="")
											{
												td.InnerHtml = "&#xa0;";
											}
											else
											{
												td.InnerHtml = "Row:"+dr["rack"].ToString().Substring(0,2)+", Cabinet:"+dr["rack"].ToString().Substring(2,2);
											}
										tr.Cells.Add(td);         //Output </TD>
										td = new HtmlTableCell(); //Output <TD>
											td.Attributes.Add("class","center");
											if (dr["bc"].ToString()=="")
											{
												td.InnerHtml = "&#xa0;";
											}
											else
											{
												td.InnerHtml = dr["bc"].ToString();
											}
										tr.Cells.Add(td);         //Output </TD>
										td = new HtmlTableCell(); //Output <TD>
											td.Attributes.Add("class","center");
											if (dr["slot"].ToString()=="")
											{
												td.InnerHtml = "&#xa0;";
											}
											else
											{
												td.InnerHtml = dr["slot"].ToString();
											}
										tr.Cells.Add(td);         //Output </TD>
									indirectTbl.Rows.Add(tr);           //Output </TR>
									fill=!fill;
								}
							}
						}
					}
				}
			}
			else
			{
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Administrative Reservation";
					tr.Cells.Add(td);         //Output </TD>
				directTbl.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","tableheading");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = dat.Tables[0].Rows[0]["comment"].ToString();
					tr.Cells.Add(td);         //Output </TD>	
				directTbl.Rows.Add(tr);           //Output </TR>					
			}
		}
	}

	if (v_userrole.Contains("datacenter") || v_userclass=="3")
	{
	deleteButton.InnerHtml="<INPUT type='image' style='border: 2px;' src='./img/disconnect.png' onclick=\"window.open('deleteCabling.aspx?sw="+access+"&amp;port="+port+"&amp;dc="+dcPrefix+"','deleteCablingWin','width=315,height=275,menubar=no,status=yes')\" ALT='Delete Cabling' />";
	}
	
	if (IsPostBack)
	{
	}	
	titleSpan.InnerHtml="Port Detail";
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
				<DIV id='switchPort' class='center' runat='server'/>
			</DIV>
			<DIV class='center'>
				<BR/>
				<TABLE id='directTbl' class='datatable' style='width:250px;' runat='server' />
				<BR/><BR/>
				<TABLE id='indirectTbl' class='datatable' style='width:250px;' runat='server' />
				<DIV id='deleteButton' runat='server' />
				<BR/>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>