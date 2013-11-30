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
public void storeDC(object sender, EventArgs e)
{
	string code="", sql="", cookieVal="";
	code=formDc.Value;
//	Response.Write(code+"<BR/>");
	preLoadForm();
}

public void preLoadForm()
{
	string sqlTablePrefix="", sqlDialect="", sql="";
	int maxRack=0, thisRack=0, maxRow=0, thisRow=0;
	DataSet dat = new DataSet();

	sqlTablePrefix=formDc.Value;
	sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	if (sqlTablePrefix!="*")
	{
		if (sqlDialect=="MSJET")
		{
			sql="SELECT MAX(Row) FROM (SELECT MID(rackId,1,2) AS Row FROM "+sqlTablePrefix+"racks)";
		}
		else
		{
			sql="SELECT MAX(Row) FROM (SELECT SUBSTRING(rackId,1,2) AS Row FROM "+sqlTablePrefix+"racks) AS MaxRow";
		}
	}
	else
	{
		if (sqlDialect=="MSJET")
		{
			sql="SELECT MAX(Row) FROM (SELECT MID(rackId,1,2) AS Row FROM racks)";
		}
		else
		{
			sql="SELECT MAX(Row) FROM (SELECT SUBSTRING(rackId,1,2) AS Row FROM racks) AS MaxRow";
		}			
	}
//	Response.Write(sql+"<BR/>");
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (sqlDialect=="MSJET")
		{
			try
			{
				maxRow=Convert.ToInt32(dat.Tables[0].Rows[0]["Expr1000"].ToString());
			}
			catch (System.Exception ex)
			{
				maxRow=0;
			}
		}
		else
		{
			try
			{
				maxRow=Convert.ToInt32(dat.Tables[0].Rows[0]["Column1"].ToString());
			}
			catch (System.Exception ex)
			{
				maxRow=0;
			}
		}
	}
	thisRow=maxRow+1;
	formRackRow.Value=thisRack.ToString();	

	if (sqlTablePrefix!="*")
	{
		if (sqlDialect=="MSJET")
		{
			sql="SELECT MAX(Rack) FROM (SELECT MID(rackId,3,2) AS Rack FROM "+sqlTablePrefix+"racks)";
		}
		else
		{
			sql="SELECT MAX(Rack) FROM (SELECT SUBSTRING(rackId,3,2) AS Rack FROM "+sqlTablePrefix+"racks) AS MaxRack";
		}
	}
	else
	{
		if (sqlDialect=="MSJET")
		{
			sql="SELECT MAX(Rack) FROM (SELECT MID(rackId,3,2) AS Rack FROM racks)";
		}
		else
		{
			sql="SELECT MAX(Rack) FROM (SELECT SUBSTRING(rackId,3,2) AS Rack FROM racks) AS MaxRack";
		}
	}
//	Response.Write(sql+"<BR/>");
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (sqlDialect=="MSJET")
		{
			try
			{
				maxRack=Convert.ToInt32(dat.Tables[0].Rows[0]["Expr1000"].ToString());
			}
			catch (System.Exception ex)
			{
				maxRack=0;
			}
		}
		else
		{
			try
			{
				maxRack=Convert.ToInt32(dat.Tables[0].Rows[0]["Column1"].ToString());
			}
			catch (System.Exception ex)
			{
				maxRack=0;
			}
		}
	}
	thisRack=maxRack+1;
	formRackNum.Value=thisRack.ToString();

	formRackLoc.Value="";
	if (sqlTablePrefix!="*")
	{
		if (sqlDialect=="MSJET")
		{
			sql="SELECT TOP 1 * FROM (SELECT COUNT(location) AS num,location FROM "+sqlTablePrefix+"racks GROUP BY location) ORDER BY num DESC";
		}
		else
		{
			sql="SELECT TOP 1 * FROM (SELECT COUNT(location) AS num,location FROM "+sqlTablePrefix+"racks GROUP BY location) AS MaxLoc ORDER BY num DESC";
		}
	}
	else
	{
		if (sqlDialect=="MSJET")
		{
			sql="SELECT TOP 1 * FROM (SELECT COUNT(location) AS num,location FROM racks GROUP BY location) ORDER BY num DESC";
		}
		else
		{
			sql="SELECT TOP 1 * FROM (SELECT COUNT(location) AS num,location FROM racks GROUP BY location) AS MaxLoc ORDER BY num DESC";
		}
	}
//	Response.Write(sql+"<BR/>");
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		try
		{
			formRackLoc.Value=dat.Tables[0].Rows[0]["location"].ToString();
		}
		catch (System.Exception ex)
		{
			formRackLoc.Value="";
		}			
	}
//	formRackLoc.Value="CRNT";
//	Response.Write(formDc.Value);
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Add New Rack";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql, sqlErr="";

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	DataSet dat = new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string v_rack="", v_topU, v_botU, v_loc;
	string v_username="", defaultDc="", sqlTablePrefix="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}



	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);
	string optionDesc="", optionVal="";
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			if (dr["dcDesc"].ToString().Length>24)
			{
				optionDesc=dr["dcDesc"].ToString().Substring(0,20)+"...";
			}
			else
			{
				optionDesc=dr["dcDesc"].ToString();
			}
			optionVal=dr["dcPrefix"].ToString();
			ListItem lfind = null;
			lfind = formDc.Items.FindByValue(dr["dcPrefix"].ToString());
			if (lfind==null)
			{
				ListItem ladd = new ListItem(optionDesc, optionVal);
				formDc.Items.Add(ladd);
			}
		}	
	}

	
	titleSpan.InnerHtml="<SPAN class='heading1'>New Rack</SPAN>";

	if (!IsPostBack)
	{
		try
		{
			defaultDc = Request.Cookies["selectedDc"].Value;
		}
		catch (System.Exception ex)
		{
			defaultDc = "";
		}
		if (defaultDc=="*" || defaultDc=="")
		{
			sqlTablePrefix="*";
		}
		else
		{
			sqlTablePrefix=defaultDc;
		}

		formDc.SelectedIndex=formDc.Items.IndexOf(formDc.Items.FindByValue(sqlTablePrefix));

		if (sqlTablePrefix!="*")
		{
			formDc.Disabled=true;
		}

		preLoadForm();

	}
	
	
	if (IsPostBack)
	{
		sqlSuccess=false;
		string v_Dc="";
		v_Dc=formDc.Value;
		string rackRow=formRackRow.Value.ToString();
		string rackNum=formRackNum.Value.ToString();
		bool rowIsNum = true;
		bool rackIsNum = true;
		bool checkState=false;
		int i;

		v_topU=fix_txt(formRackTopU.Value.ToString()); 
		v_botU=fix_txt(formRackBotU.Value.ToString());
		v_loc=fix_txt(formRackLoc.Value.ToString());

		rowIsNum = isNumber(rackRow);
		rackIsNum = isNumber(rackNum); 

//		Response.Write("DC1:"+v_Dc+"<BR/>");
		if (v_Dc=="*") { v_Dc=""; }
//		Response.Write("DC2:"+v_Dc+"<BR/>");

		if (rowIsNum)
		{
			i = Convert.ToInt32(rackRow);
			if (i<100)
			{
				checkState=true;
				rackRow = 	rackRow =="1"	? "01"	:
							rackRow =="2"	? "02"	:
							rackRow =="3"	? "03"	:
							rackRow =="4"	? "04"	:
							rackRow =="5"	? "05"	:
							rackRow =="6"	? "06"	:
							rackRow =="7"	? "07"	:
							rackRow =="8"	? "08"	:
							rackRow =="9"	? "09"	:
							rackRow =="0"	? "00"	:
											  rackRow ;
			}
			else
			{
				checkState=false;
			}
		}


		if (rackIsNum)
		{
			i = Convert.ToInt32(rackNum);
			if (i<100)
			{
				checkState=true;
				rackNum = 	rackNum =="1"	? "01"	:
							rackNum =="2"	? "02"	:
							rackNum =="3"	? "03"	:
							rackNum =="4"	? "04"	:
							rackNum =="5"	? "05"	:
							rackNum =="6"	? "06"	:
							rackNum =="7"	? "07"	:
							rackNum =="8"	? "08"	:
							rackNum =="9"	? "09"	:
							rackNum =="0"	? "00"	:
											  rackNum ;
			}
			else
			{
				checkState=false;
			}
		}

		if (rackRow.Length>2)
		{
			rackRow="";
			checkState=false;
		}

		if (rackNum.Length>2)
		{
			rackNum="";
			checkState=false;
		}

		if (rackIsNum && rowIsNum && checkState && rackRow!="" && rackNum!="")
		{
			v_rack=rackRow+rackNum;
		}
//		Response.Write("RackRow:"+rackRow+",RackNum:"+rackNum+"<BR/>");

//		Response.Write("DC:"+v_Dc+"<BR/>");
		if (v_Dc=="")
		{
			checkState=false;
		}

		if( v_topU=="")
		{
			checkState=false;
		}
		
		if(v_botU=="")
		{
			checkState=false;
		}

		if (v_rack=="")
		{
			checkState=false;
		}
//		Response.Write("Rack:"+v_rack+","+checkState+"<BR/>");

		sql="SELECT * FROM "+v_Dc+"racks WHERE rackId='"+v_rack+"'";
		dat=readDb(sql);
//		Response.Write(sql+"<BR/>");
		if (!emptyDataset(dat))
		{
			checkState=false;
		}

		if (checkState)
		{
			sql="INSERT INTO "+v_Dc+"racks(rackId,uMax,uMin,dcPrefix,location) VALUES("
								+"'" +v_rack+ "',"
								+"'" +v_topU+  "',"
								+"'" +v_botU+   "',"
								+"'" +v_Dc+   "',"
								+"'" +v_loc+   "')";
			sqlErr=writeDb(sql);
//			Response.Write(sql+"<BR/>");
			if (sqlErr==null || sqlErr=="")
			{
				errmsg.InnerHtml = "Rack Record Updated.";
				sqlSuccess=true;
			}
			else
			{
				errmsg.InnerHtml = "SQL Update Error - Racks<BR/>"+sqlErr;
				sqlErr="";
			}
			if (sqlSuccess) 
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Rack #"+v_rack+" created");
				if (sqlErr==null || sqlErr=="")
				{
					Response.Write("<script>refreshParent("+");<"+"/script>");
				}
				else
				{
					errmsg.InnerHtml = "WARNING: "+sqlErr;
				}
			}
		}
		else 
		{
			if (v_topU == "") formRackTopU.Style["background"]="yellow";
			if (v_botU == "") formRackBotU.Style["background"]="yellow";
			if (v_loc == "") formRackLoc.Style["background"]="yellow";
			if (v_rack == "") formRackRow.Style["background"]="yellow";
			if (v_rack == "") formRackNum.Style["background"]="yellow";
			if (v_Dc == "") formDc.Style["background"]="yellow";
			string errStr = "Please enter valid data in all required fields!";
			errmsg.InnerHtml=errStr;
		}
	}
	
//	Response.Write(rack);

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
				<TABLE class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>DataCenter:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formDc' style='width:157px;' runat='server' onchange='javascript:popupform.submit();' onserverchange='storeDC'>
											<OPTION Value='*'>All</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Row #:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formRackRow' size='25' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Cabinet #:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formRackNum' size='25' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Room / Area:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formRackLoc' size='25' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>Rack Bottom 'U':&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formRackBotU' size='25' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Rack Top 'U':&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formRackTopU' size='25' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
				</TABLE><BR/>
				<INPUT type='submit' value='Save Changes' runat='server'>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'>
				<BR/>&nbsp;
			</DIV>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>