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

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (bc!="")
	{
		titleSpan.InnerHtml="Servers in "+dcPrefix.ToUpper().Replace("_","")+" BladeCenter #"+bc;

		sql = "SELECT  * FROM (SELECT serverName, serverLanIP, serverOS, serverPurpose, class, rack, bc, slot, "+dcPrefix+"rackspace.rackspaceId, reserved FROM "+dcPrefix+"rackspace LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE bc='"+bc+"') AS bc WHERE reserved='0' ORDER BY slot ASC";
		dat=readDb(sql);

		if (!emptyDataset(dat))
		{
			string rackString="";
			string sqlRack="";
			DataSet datRack=new DataSet();
			sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE RackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
//			Response.Write(sqlRack+"<BR/>");
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
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","6");
					td.InnerHtml = dcPrefix.ToUpper().Replace("_","")+" BladeCenter #"+bc+", Rack		#"+rackString;
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
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = drr["serverName"].ToString();
							}
							td.Attributes.Add("class","printable center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
	string sql,sql1, sql2="";
	DataSet dat, dat1;
//	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
//	bool emptySlot=false;
	string rack, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="";

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

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

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

//	Response.Write("Works! "+rack);
	if (rack!="")
	{
		string rackString="";
		string sqlRack="";
		DataSet datRack=new DataSet();
		sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE RackId='"+rack+"'";
//		Response.Write(sqlRack+"<BR/>");
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
		titleSpan.InnerHtml="Servers in "+rackString;

		int rowCount=0;
		bool mixedOrBc=false;
		sql2="SELECT COUNT(*) FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND bc IS NOT NULL) AS a WHERE model<>'ESX' AND reserved<>'1'";
//		Response.Write(sql2+"<BR/>");
		dat=readDb(sql2);
		if (!emptyDataset(dat))
		{
			try
			{
				switch (sqlDialect)
				{
					case "MSJET":
						rowCount=Convert.ToInt32(dat.Tables[0].Rows[0]["Expr1000"].ToString());
					break;
					case "MSSQL":
						rowCount=Convert.ToInt32(dat.Tables[0].Rows[0]["Column1"].ToString());
					break;
				}
			}
			catch (System.Exception ex)
			{
				rowCount=0;
			}
			
		}
		
		if (rowCount>0)
		{
			mixedOrBc=true;
		}
		else
		{
			mixedOrBc=false;
		}

		if (mixedOrBc)
		{
			order="ORDER BY bc ASC, slot ASC";
			sql="SELECT * FROM (SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND slot<>'00') AS a WHERE bc IS NULL) WHERE reserved<>'1' ORDER BY slot DESC";
			sql1="SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND slot<>'00') AS a WHERE bc IS NOT NULL AND model<>'ESX' AND reserved<>'1' "+order;
//			Response.Write(sql+"<BR/>");
//			Response.Write(sql1+"<BR/>");
			dat=readDb(sql);
			dat1=readDb(sql1);
			if (!emptyDataset(dat))
			{
				dat.Merge(dat1);
			}
			else
			{
				dat=dat1;
			}	
		}
		else
		{
			order="ORDER BY slot DESC";
			sql="SELECT * FROM (SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND slot<>'00') AS a WHERE bc IS NULL) AS b WHERE model<>'ESX' AND reserved<>'1' "+order;
//			Response.Write(sql+"<BR/>");
			dat=readDb(sql);
		}

		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Rack "+rackString;
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
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = drr["serverName"].ToString();
							}
							td.Attributes.Add("class","printable center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
							{
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
		
		if (env=="All")
		{
			sql = "SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, class, bc, slot, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId ORDER BY serverName ASC";
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
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
	} 
}

public void showSrch(string view)
{
	string sql,sql1;
	DataSet dat=new DataSet();
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string term, order;
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
		term=Request.Cookies["srchSql"].Value;
	}
	catch (System.Exception ex)
	{
		term = "";
	}	
	
	
	if (view=="svr")
	{
		dat=readDb(term);
		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Server Search";
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
								td.InnerHtml = "Unassigned";
							}
							else
							{
								td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
							}
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
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
							td.Attributes.Add("class","printable center");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
	}
	else
	{
		if (term!="")
		{
			try
			{
				dat=readDb(term);
				if (!emptyDataset(dat))
				{
					titleSpan.InnerHtml="Custom Report";
					sqlResult.DataSource=dat;
					sqlResult.DataBind();
				}
			}
			catch (System.Exception ex)
			{
				errmsg.InnerHtml = ex.ToString();
				sqlResult.DataSource=null;
				sqlResult.DataBind();
			}
		}	
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Printable Page";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string bc, rack, os, env, srch;
	string v_userclass, v_hostname, v_ip, v_desc;

	DateTime dateStamp = DateTime.Now;

	try
	{
		bc=Request.QueryString["bc"].ToString();
	}
	catch (System.Exception ex)
	{
		bc = "";
	}	

	try
	{
		rack=Request.QueryString["rack"].ToString();
	}
	catch (System.Exception ex)
	{
		rack = "";
	}

	try
	{
		os=Request.QueryString["os"].ToString();
	}
	catch (System.Exception ex)
	{
		os = "";
	}

	try
	{
		env=Request.QueryString["env"].ToString();
	}
	catch (System.Exception ex)
	{
		env = "";
	}

	try
	{
		srch=Request.QueryString["srch"].ToString();
	}
	catch (System.Exception ex)
	{
		srch = "";
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
		v_hostname=Request.Cookies["hostname"].Value;
	}
	catch (System.Exception ex)
	{
		v_hostname="";
	}

	try
	{
		v_ip=Request.Cookies["ip"].Value;
	}
	catch (System.Exception ex)
	{
		v_ip="";
	}

	if (bc!="" || bc!=null)
	{
		if (v_hostname =="" && v_ip=="")
		{
			showBc();
		}
	}
	

	if (rack!="" || rack!=null)
	{
		if (v_hostname =="" && v_ip=="")
		{
			showRack();
		}
	}


	if (os!="" || os!=null)
	{
		if (v_hostname =="" && v_ip=="")
		{
			showOs();
		}

	}
	
	if (env!="" || env!=null)
	{
		if (v_hostname =="" && v_ip=="")
		{
			showEnv();
		}
	}

	if (srch!="" || srch!=null)
	{
		if (v_hostname =="" && v_ip=="")
		{
			showSrch(srch);
		}
	}

	if (IsPostBack)
	{
	}
	

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
			&nbsp;<BR/>
			<DIV class='center'>
				<TABLE id="svrTbl" runat="server" class="datatable" />
				<BR/><BR/>
				<TABLE id="svrTbl1" runat="server" class="datatable" />
				<ASP:datagrid id="sqlResult" runat="server" BackColor="White" HorizontalAlign="Center" Font-Size="8pt" CellPadding="2" BorderColor="#336633" BorderStyle="Solid" BorderWidth="2px">
					<HeaderStyle BackColor="#336633" ForeColor="White" Font-Bold="True" HorizontalAlign="Center" />
					<AlternatingItemStyle BackColor="#edf0f3" />
				</ASP:datagrid>
			</DIV>
			<INPUT type="button" value="Print" onclick="printWin()"/>&#xa0;<INPUT type="button" value="Cancel &amp; Close" onclick="refreshParent()"/>
			<BR/> &nbsp;
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>