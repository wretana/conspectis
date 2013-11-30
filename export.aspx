<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
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

public void showBc()
{
	string sql,sql1;
	DataSet dat=new DataSet();
//	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string bc;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="";
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
		bc=Request.QueryString["bc"].ToString();
	}
	catch (System.Exception ex)
	{
		bc = "";
	}	



	if (bc!="")
	{
		titleSpan.InnerHtml="Servers in BladeCenter #"+bc;

		sql = "SELECT  * FROM (SELECT serverName, serverLanIP, serverOS, serverPurpose, class, rack, bc, slot, rackspace.rackspaceId, reserved FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE bc='"+bc+"' ORDER BY slot ASC) WHERE reserved='0'";
		dat=readDb(sql);

		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","6");
					td.InnerHtml = "BladeCenter #"+bc+", Rack		#"+dat.Tables[0].Rows[0]["rack"].ToString();
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HostName";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Public IP";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HW Class";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Purpose";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Slot";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>	
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverName"].ToString()=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = drr["serverName"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["class"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["class"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "BladeCenter #"+bc;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "No servers or available rackspace found.";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
		}		
	}
}


public void showRack()
{
	string sql,sql1;
	DataSet dat=new DataSet();
//	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
//	bool emptySlot=false;
	string rack, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="";
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
		rack=Request.QueryString["rack"].ToString();
	}
	catch (System.Exception ex)
	{
		rack = "";
	}	

//	Response.Write("Works! "+rack);
	if (rack!="")
	{
		if (rack=="08" || rack=="09" || rack=="18" || rack=="19" || rack=="20")
		{
			order="slot DESC";
		}
		else
		{
			order="bc ASC, slot ASC";
		}

		titleSpan.InnerHtml="Servers in Rack #"+rack;

		sql = "SELECT * FROM (SELECT  * FROM (SELECT serverName, serverLanIP, serverOS, serverPurpose, class, rack, bc, slot, rackspace.rackspaceId, reserved FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE rack='"+rack+"' ORDER BY "+order+") WHERE reserved='0') WHERE serverOS='AIX' OR  serverOS='Linux' OR  serverOS='Windows' OR  serverOS IS NULL";
		dat=readDb(sql);

		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Rack #"+rack;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HostName";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Public IP";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HW Class";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Purpose";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "BC";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Slot";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverName"].ToString()=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = drr["serverName"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["class"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["class"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["bc"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["bc"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Rack #"+rack;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "No servers or available rackspace found.";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
		}
	}
}


public void showOs()
{
	string sql,sql1;
	DataSet dat, dat1;
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string os, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="";
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
		os=Request.QueryString["os"].ToString();
	}
	catch (System.Exception ex)
	{
		os = "";
	}	


	if (os!="")
	{
		titleSpan.InnerHtml=os+" Servers in ABQDC";

		if (os=="Network" || os=="RSA2")
		{
			order="serverName ASC";
		}
		else
		{
			order="rack, bc, slot ASC";
		}
		sql = "SELECT * FROM(SELECT serverName, serverLanIP, serverOS, serverPurpose, class, rack, bc, slot, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='"+os+"' ORDER BY servername ASC, rack ASC) WHERE serverName LIKE '%PHE%'";
		dat=readDb(sql);
		sql1 = "SELECT * FROM(SELECT serverName, serverLanIP, serverOS, serverPurpose, class, rack, bc, slot, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='"+os+"' ORDER BY servername ASC, rack ASC) WHERE serverName LIKE '%PRP%'";
		dat1=readDb(sql1);

		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = os+" Servers - PHE";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HostName";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Public IP";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HW Class";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Purpose";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Row/Cabinet";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "BC";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Slot";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = drr["serverName"].ToString();
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["class"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["class"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["rack"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = "Row:"+drr["rack"].ToString().Substring(0,2)+", Cabinet:"+drr["rack"].ToString().Substring(2,2);
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["bc"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["bc"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}

		}
		if (!emptyDataset(dat1))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = os+" Servers - PRP";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl1.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HostName";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Public IP";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HW Class";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Purpose";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Row/Cabinet";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "BC";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Slot";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
			svrTbl1.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat1.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = drr["serverName"].ToString();
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["class"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["class"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["rack"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = "Row:"+drr["rack"].ToString().Substring(0,2)+", Cabinet:"+drr["rack"].ToString().Substring(2,2);
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["bc"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["bc"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl1.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
	} 
}


public void showEnv()
{
	string sql,sql1;
	DataSet dat=new DataSet();
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string env, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="";
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
		env=Request.QueryString["env"].ToString();
	}
	catch (System.Exception ex)
	{
		env = "";
	}	


	if (env!="")
	{
		titleSpan.InnerHtml="Servers in "+env;
		
		if (env=="QA")
		{
			sql = "SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName LIKE 'SV"+env+"%' OR serverName LIKE 'SL"+env+"%' OR serverName LIKE 'SX"+env+"%' ORDER BY serverName ASC";
		}
		else
		{
			sql = "SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, class, bc, slot, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName LIKE '%"+env+"%' ORDER BY serverName ASC";
		}
		dat=readDb(sql);

		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = env+" Servers";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HostName";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Public IP";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "HW Class";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Purpose";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Row/Cabinet";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "BC";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Slot";
					td.Attributes.Add("class","printable-heading");
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = drr["serverName"].ToString();
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "<DIV class='center'>Unassigned</DIV>";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["class"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["class"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
							td.Attributes.Add("class","printable");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["rack"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = "Row:"+drr["rack"].ToString().Substring(0,2)+", Cabinet:"+drr["rack"].ToString().Substring(2,2);
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["bc"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["bc"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
							td.Attributes.Add("class","printable");
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
	} 
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Export";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string access="", port="";

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
		port=Request.QueryString["portId"].ToString();
	}
	catch (System.Exception ex)
	{
		port="";
	}
	
	if (IsPostBack)
	{
	}
	
	Response.Write(access);
	Response.Write(port);

}
</SCRIPT>
</HEAD>
<!--#include file="body.inc" -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		
		<DIV class='center paleColorFill'>
		&#xa0;<BR/>
			<DIV class='center'>
<!--		<TABLE border="1" class="datatable" cellpadding="0" cellspacing="0">
			<TR><TD align="center">
				<TABLE cellspacing="0">
					<TR><TD class="inputform">&#xa0;</TD><TD style="background-color:#ffffff">&#xa0;</TD></TR>

					<TR><TD class="inputform">&#xa0;</TD><TD style="background-color:#ffffff">&#xa0;</TD></TR> 
				</TABLE>
			</TABLE> -->
			</DIV>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>