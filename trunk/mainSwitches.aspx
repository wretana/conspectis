<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-7-13 CK -->
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
}

public void getSwPorts(string access, string slot, string dcPrefix)
{
	string sql="", sqlOdd="", sqlEven="";
	DataSet dat, datOdd, datEven;
	int fillMax=24, filler=1;

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	HtmlTableRow tr;
	HtmlTableCell td;

	switch (sqlDialect)
	{
	case "MSJET":
		sqlOdd="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') AS swRow WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC";
		sqlEven="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') AS swRow WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC";
		break;
	case "MSSQL":
		sqlOdd="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') AS swRow WHERE CONVERT(int,portNum) % 2 = 1 ORDER BY portId ASC";
		sqlEven="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') AS swRow WHERE CONVERT(int,portNum) % 2 = 0 ORDER BY portId ASC";
		break;
	}
	datOdd=readDb(sqlOdd);
	datEven=readDb(sqlEven);
	int oddNum=1, evenNum=2, count=1;

	if (datOdd!=null && datEven!=null)
	{
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading txtAlignMiddleCenter sw45wide");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("rowspan","3");
				td.InnerHtml = slot;
			tr.Cells.Add(td);         //Output </TD>
			while (count<=24)
			{
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
				tr.Cells.Add(td);         //Output </TD>	
				oddNum=oddNum+2;
				evenNum=evenNum+2;
				count++;
			}
		switchTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			if (datOdd!=null)
			{
				foreach (DataTable dt in datOdd.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter sw30wide");
							td.Attributes.Add("style","border:1px solid gray");
						if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
						{
							sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
							td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/jackOddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
						}
						else
						{
							td.InnerHtml="<A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/jackOddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
						}
						tr.Cells.Add(td);         //Output </TD>
					}
				}
			}
			else
			{
				while (filler<fillMax)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml="&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
					filler++;
				}
				filler=1;
			}
		switchTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			if (datEven!=null)
			{
				foreach (DataTable dt in datEven.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter sw30wide");
							td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/jackEvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/jackEvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
					tr.Cells.Add(td);         //Output </TD>
					}
				}
			}
			else
			{
				while (filler<fillMax)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml="&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
					filler++;
				}
				filler=1;
			}
		switchTbl.Rows.Add(tr);           //Output </TR>
	}
}

public void fillSlot(string slot, int width)
{
	int fillMax=width, filler=1;
	HtmlTableRow tr;
	HtmlTableCell td;

	tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("rowspan","3");
			td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
			td.InnerHtml = slot;
		tr.Cells.Add(td);         //Output </TD>
		while (filler<=fillMax)
		{
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml="&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
			filler++;
		}
		filler=1;
	switchTbl.Rows.Add(tr);           //Output </TR>
	tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		while (filler<=fillMax)
		{
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml="&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
			filler++;
		}
		filler=1;
	switchTbl.Rows.Add(tr);           //Output </TR>
	tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		while (filler<=fillMax)
		{
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml="&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
			filler++;
		}
		filler=1;
	switchTbl.Rows.Add(tr);           //Output </TR>
}

public void getCatalystFiber(string access, string slot, string dcPrefix)
{
	string sql="";

	int fillMax=24, filler=1;
	int count=1;

	DataSet dat=new DataSet();
	HtmlTableRow tr;
	HtmlTableCell td;

	sql="SELECT * FROM "+access+" WHERE slot='"+slot+"'";
	dat=readDb(sql);

	if (dat!=null)
	{
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("rowspan","4");
			td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
			td.InnerHtml = slot;
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			tr.Attributes.Add("style","border:1px solid black"); 
			td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","24");
				td.InnerHtml ="&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("class","sw140wide");
			td.Attributes.Add("colspan","8");
		tr.Cells.Add(td);         //Output </TD>
		if (dat!=null)
		{
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","4");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.Attributes.Add("style","border:1px solid gray"); 
					if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
					{
						td.InnerHtml="<SPAN style='font-size:6pt;'>"+count+"</SPAN><BR/><A class='black'  onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/fiberUsed.png' border='0' ALT=''/></A>";
					}
					else
					{
						td.InnerHtml="<SPAN style='font-size:6pt;'>"+count+"</SPAN><BR/><A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/fiberOpen.png' border='0' ALT=''/></A>";
					}
					count++;
					tr.Cells.Add(td);         //Output </TD>
				}
			}
		}
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("class","sw140wide");
			td.Attributes.Add("colspan","8");
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","24");
				td.InnerHtml ="&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
	}
}

public void getFiber(string access, string slot, int rows, int portsInRow, int groupBy, string dcPrefix)
{
	string sql="", sqlOdd="", sqlEven="";
	DataSet dat, datOdd, datEven;
	int filler=1, portCount=1;

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	HtmlTableRow tr;
	HtmlTableCell td;
	if (rows % 2==0)
	{
		switch (sqlDialect)
		{
			case "MSJET":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC";
			break;
		case "MSSQL":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') AS swRow WHERE CONVERT(int,portNum) % 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+" WHERE slot='"+slot+"') AS swRow WHERE CONVERT(int,portNum) % 2 = 0 ORDER BY portId ASC";
			break;
		}
		
		datOdd=readDb(sqlOdd);
		
		datEven=readDb(sqlEven);
		int oddNum=1, evenNum=2, count=1;

		if (datOdd!=null && datEven!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("rowspan","3");
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.InnerHtml = slot;
				tr.Cells.Add(td);         //Output </TD>
				while (count<=portsInRow)
				{

					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==groupBy)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				if (datOdd!=null)
				{
					foreach (DataTable dt in datOdd.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray");
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/gbicOddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/gbicOddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							portCount++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				if (datEven!=null)
				{
					foreach (DataTable dt in datEven.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
								if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
								{
									td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/gbicEvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
								}
								else
								{
									td.InnerHtml="<A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/gbicEvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
								}
								tr.Cells.Add(td);         //Output </TD>
								if (portCount==groupBy)
								{
									td = new HtmlTableCell(); //Output <TD>
										td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
										td.Attributes.Add("style","border:1px black"); 
										td.InnerHtml="&#xa0;";
									tr.Cells.Add(td);         //Output </TD>
									portCount=0;
								}
								portCount++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
		}
	}

	else
	{
		int count=1;
		portCount=1;

		sql="SELECT * FROM "+access+" WHERE slot='"+slot+"'";
		dat=readDb(sql);

		if (dat!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("rowspan","3");
				td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
				td.InnerHtml = slot;
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				tr.Attributes.Add("style","border:1px solid black"); 
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","26");
					td.InnerHtml ="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","sw25wide");
				td.Attributes.Add("colspan","8");
			tr.Cells.Add(td);         //Output </TD>
			bool console=false;
			if (dat!=null)
			{
				foreach (DataTable dt in dat.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("colspan","4");
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.Attributes.Add("style","border:1px solid gray"); 
						if (dr["portNum"].ToString()=="Mgt" || dr["portNum"].ToString()=="Con")
						{
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								td.InnerHtml="<SPAN style='font-size:6pt;'>"+dr["portNum"].ToString().ToUpper()+"</SPAN><BR/><A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/jackEvenUsed.png' border='0' ALT=''/></A>";
							}
							else
							{
								td.InnerHtml="<SPAN style='font-size:6pt;'>"+dr["portNum"].ToString().ToUpper()+"</SPAN><BR/><A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/jackEvenOpen.png' border='0' ALT=''/></A>";
							}
							console=true;
						}
						else
						{
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								td.InnerHtml="<SPAN style='font-size:6pt;'>"+count+"</SPAN><BR/><A class='black'  onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/gbicEvenUsed.png' border='0' ALT=''/></A>";
							}
							else
							{
								td.InnerHtml="<SPAN style='font-size:6pt;'>"+count+"</SPAN><BR/><A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/gbicEvenOpen.png' border='0' ALT=''/></A>";
							}
							count++;
						}
						tr.Cells.Add(td);         //Output </TD>
						if (console)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw8wide");
								td.Attributes.Add("style","border:1px black"); 
								td.InnerHtml="&#xa0;";
							tr.Cells.Add(td);         //Output </TD>
						}
						else
						{
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw15wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							portCount++;
						}
						console=false;

					}
				}
			}
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","sw25wide");
				td.Attributes.Add("colspan","8");
			tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan",portsInRow+1.ToString());
					td.InnerHtml ="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
		}
	}
}

public void getNexus(string access, string type, string dcPrefix)
{
	string sql="",sql1="",sql2="", sqlOdd="", sqlEven="";
	DataSet dat, dat1,dat2, datOdd, datEven;
	int filler=1, portCount=1;

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	HtmlTableRow tr;
	HtmlTableCell td;
	if (type=="nexus2232pp")
	{
//		Response.Write(type);
		switch (sqlDialect)
		{
			case "MSJET":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+") WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+") WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC";
			break;
		case "MSSQL":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+") AS swRow WHERE CONVERT(int,portNum) % 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+") AS swRow WHERE CONVERT(int,portNum) % 2 = 0 ORDER BY portId ASC";
			break;
		}
		
		datOdd=readDb(sqlOdd);
		
		datEven=readDb(sqlEven);
		int oddNum=1, evenNum=2, count=1;
		int portsInRow=20, groupBy=4;

		if (datOdd!=null && datEven!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
			sql1="SELECT DISTINCT(slot) FROM "+access;
			dat1=readDb(sql1);
			if (dat1!=null)
			{
//				Response.Write(dat1.Tables[0].Rows.Count.ToString());
				foreach (DataTable dt in dat1.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						sql2="SELECT COUNT(*) FROM "+access+" WHERE slot='"+dr["slot"].ToString()+"'";
						dat2=readDb(sql2);
//						Response.Write(sql2);
						if (dat2!=null)
						{
							tr.Attributes.Add("class","blackheading");
							td = new HtmlTableCell(); //Output <TD>
							int colVal=0;
							switch (sqlDialect)
							{
								case "MSJET":
									colVal=Convert.ToInt32(dat2.Tables[0].Rows[0]["Expr1000"])/2;
								break;
								case "MSSQL":
									colVal=Convert.ToInt32(dat2.Tables[0].Rows[0]["Column1"])/2;
								break;
							}
							
							colVal=colVal+4;
								td.Attributes.Add("colspan",colVal.ToString());
								td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
								td.InnerHtml = "<SPAN style='font-size:7pt;'>"+dr["slot"].ToString()+"</SPAN>";
							tr.Cells.Add(td);         //Output </TD>						
						}
					}
				}
			}
			switchTbl.Rows.Add(tr); 
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("rowspan","3");
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.InnerHtml = "&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				while (count<=portsInRow)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==groupBy)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				if (datOdd!=null)
				{
					foreach (DataTable dt in datOdd.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' 	onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							portCount++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				if (datEven!=null)
				{
					foreach (DataTable dt in datEven.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
								if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
								{
									td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
								}
								else
								{
									td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
								}
								tr.Cells.Add(td);         //Output </TD>
								if (portCount==groupBy)
								{
									td = new HtmlTableCell(); //Output <TD>
										td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
										td.Attributes.Add("style","border:1px black"); 
										td.InnerHtml="&#xa0;";
									tr.Cells.Add(td);         //Output </TD>
									portCount=0;
								}
								portCount++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
		}
	}
	if (type=="nexus2248tp")
	{
//		Response.Write(type);

		switch (sqlDialect)
		{
			case "MSJET":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+") WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+") WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC";
			break;
		case "MSSQL":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+") AS swRow WHERE CONVERT(int,portNum) % 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+") AS swRow WHERE CONVERT(int,portNum) % 2 = 0 ORDER BY portId ASC";
			break;
		}
		datOdd=readDb(sqlOdd);
		datEven=readDb(sqlEven);
		int oddNum=1, evenNum=2, count=1;
		int portsInRow=26, groupBy=4;

		if (datOdd!=null && datEven!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
			sql1="SELECT DISTINCT(slot) FROM "+access;
			dat1=readDb(sql1);
			if (dat1!=null)
			{
//				Response.Write(dat1.Tables[0].Rows.Count.ToString());
				foreach (DataTable dt in dat1.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						sql2="SELECT COUNT(*) FROM "+access+" WHERE slot='"+dr["slot"].ToString()+"'";
						dat2=readDb(sql2);
//						Response.Write(sql2);
						if (dat2!=null)
						{
							tr.Attributes.Add("class","blackheading");
							td = new HtmlTableCell(); //Output <TD>
							int colVal=0;
							switch (sqlDialect)
							{
								case "MSJET":
									colVal=Convert.ToInt32(dat2.Tables[0].Rows[0]["Expr1000"])/2;
								break;
								case "MSSQL":
									colVal=Convert.ToInt32(dat2.Tables[0].Rows[0]["Column1"])/2;
								break;
							}
							colVal=colVal+7;
								td.Attributes.Add("colspan",colVal.ToString());
								td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
								td.InnerHtml = "<SPAN style='font-size:7pt;'>"+dr["slot"].ToString()+"</SPAN>";
							tr.Cells.Add(td);         //Output </TD>						
						}
					}
				}
			}
			switchTbl.Rows.Add(tr); 
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("rowspan","3");
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.InnerHtml = "&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				while (count<=portsInRow)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==groupBy)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				if (datOdd!=null)
				{
					foreach (DataTable dt in datOdd.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' 	onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							portCount++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				if (datEven!=null)
				{
					foreach (DataTable dt in datEven.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
								if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
								{
									td.InnerHtml="<A class='black'  onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
								}
								else
								{
									td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
								}
								tr.Cells.Add(td);         //Output </TD>
								if (portCount==groupBy)
								{
									td = new HtmlTableCell(); //Output <TD>
										td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
										td.Attributes.Add("style","border:1px black"); 
										td.InnerHtml="&#xa0;";
									tr.Cells.Add(td);         //Output </TD>
									portCount=0;
								}
								portCount++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
		}
	}
	if (type=="nexus5020")
	{
//		Response.Write(type);
//		Response.Write(type);
		int oddNum=1, evenNum=2, count=1;
		int portsInRow=26, groupBy=4;
		string sqlOdd1="", sqlEven1="", sqlOdd2="",sqlEven2="";
		DataSet datOddTwo, datEvenTwo, datOddMgt, datEvenMgt;

		switch (sqlDialect)
		{
			case "MSJET":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '1%') WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '1%') WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC";
				sqlOdd1="SELECT * FROM (SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '2%') WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC) WHERE slot NOT IN ('2-Mgt','2-Con')";
				sqlEven1="SELECT * FROM (SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '2%') WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC) WHERE slot NOT IN ('2-Mgt','2-Con')";
				sqlOdd2="SELECT * FROM (SELECT * FROM "+access+" WHERE slot IN ('2-Mgt','2-Con')) WHERE CInt(portNum) MOD 2 = 1 ORDER BY portId ASC";
				sqlEven2="SELECT * FROM (SELECT * FROM "+access+" WHERE slot IN ('2-Mgt','2-Con')) WHERE CInt(portNum) MOD 2 = 0 ORDER BY portId ASC";
			break;
		case "MSSQL":
				sqlOdd="SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '1%') AS swRow WHERE CONVERT(int,portNum) % 2 = 1 ORDER BY portId ASC";
				sqlEven="SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '1%') AS swRow WHERE CONVERT(int,portNum) % 2 = 0 ORDER BY portId ASC";
				sqlOdd1="SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '2%') AS bulkRow WHERE CONVERT(int,portNum) % 2 = 1 AND slot NOT IN ('2-Mgt','2-Con') ORDER BY portId ASC";
				sqlEven1="SELECT * FROM (SELECT * FROM "+access+" WHERE slot LIKE '2%') AS bulkRow WHERE CONVERT(int,portNum) % 2 = 0 AND slot NOT IN ('2-Mgt','2-Con') ORDER BY portId ASC";
				sqlOdd2="SELECT * FROM (SELECT * FROM "+access+" WHERE slot IN ('2-Mgt','2-Con')) AS swRow WHERE CONVERT(int,portNum) % 2 = 1 ORDER BY portId ASC";
				sqlEven2="SELECT * FROM (SELECT * FROM "+access+" WHERE slot IN ('2-Mgt','2-Con')) AS swRow WHERE CONVERT(int,portNum) % 2 = 0 ORDER BY portId ASC";
			break;
		}
/*		Response.Write(sqlOdd+"<BR/><BR/>");
		Response.Write(sqlEven+"<BR/><BR/>");
		Response.Write(sqlOdd1+"<BR/><BR/>");
		Response.Write(sqlEven1+"<BR/><BR/>");
		Response.Write(sqlOdd2+"<BR/><BR/>");
		Response.Write(sqlEven2+"<BR/><BR/>"); */
		datOdd=readDb(sqlOdd);
		datEven=readDb(sqlEven);
		datOddTwo=readDb(sqlOdd1);	
		datEvenTwo=readDb(sqlEven1);
		datOddMgt=readDb(sqlOdd2);
		datEvenMgt=readDb(sqlEven2);
		if (datOdd!=null && datEven!=null & datOddTwo!=null && datEvenTwo!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.InnerHtml = "&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.Attributes.Add("colspan","5");
					td.InnerHtml = "<SPAN style='font-size:7pt;'>Mgt / Console</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.Attributes.Add("colspan","13");
					td.InnerHtml = "<SPAN style='font-size:7pt;'>Base 10G</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.Attributes.Add("colspan","7");
					td.InnerHtml = "<SPAN style='font-size:7pt;'>Expansion</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr); 
// SLOT 1 BEGIN
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("rowspan","3");
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.InnerHtml = "1";
				tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
				while (count<=10)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==groupBy)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				count=1;
				portCount=1;
				oddNum=1;
				evenNum=2;
				while (count<=3)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==2)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
				tr.Attributes.Add("class","blackheading");
				count=1;
				if (datOdd!=null)
				{
					foreach (DataTable dt in datOdd.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							if (count==10)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								groupBy=2;
								portCount=0;
							}
							portCount++;
							count++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","txtAlignMiddleCenter");
				td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","txtAlignMiddleCenter");
				td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
			tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			groupBy=4;
			tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
				tr.Attributes.Add("class","blackheading");
				count=1;
				if (datEven!=null)
				{
					foreach (DataTable dt in datEven.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black'	onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							if (count==10)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								groupBy=2;
								portCount=0;
							}
							portCount++;
							count++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","txtAlignMiddleCenter");
				td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","txtAlignMiddleCenter");
				td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
			tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
// SLOT 2
			count=1;
			portCount=1;
			oddNum=1;
			evenNum=2;
			groupBy=4;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("rowspan","3");
					td.Attributes.Add("class","txtAlignMiddleCenter sw45wide");
					td.InnerHtml = "2";
				tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD> 
				while (count<=10)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==groupBy)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","txtAlignMiddleCenter");
					td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
				tr.Cells.Add(td);         //Output </TD>
				count=1;
				portCount=1;
				oddNum=1;
				evenNum=2;
				while (count<=4)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "<SPAN style='font-size:5pt;'>"+oddNum.ToString()+" / "+evenNum.ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>	
					oddNum=oddNum+2;
					evenNum=evenNum+2;
					count++;
					if (portCount==2)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","txtAlignMiddleCenter");
							td.InnerHtml = "<SPAN style='font-size:5pt;'>&#xa0;</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						portCount=0;
					}
					portCount++;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			groupBy=4;
			tr = new HtmlTableRow();    //Output <TR>
				if (datOddMgt !=null)
				{
					foreach (DataTable dt in datOddMgt.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (dr["slot"].ToString().Contains("Con"))
							{
								td = new HtmlTableCell(); //Output <TD>
//									td.Attributes.Add("colspan","5");
									td.Attributes.Add("class","txtAlignMiddleCenter");
									td.InnerHtml = "&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
							}
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' 	onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black'  onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							if (count==10)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								groupBy=2;
								portCount=0;
							}
							portCount++;
							count++;
						}
					}
				}
					td = new HtmlTableCell(); //Output <TD>
//						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD> 				
				tr.Attributes.Add("class","blackheading");
				count=1;
				portCount=1;
				groupBy=4;
				if (datOddTwo!=null)
				{
					foreach (DataTable dt in datOddTwo.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"OddOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							if (count==10)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								groupBy=2;
								portCount=0;
							}
							portCount++;
							count++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
			portCount=1;
			groupBy=2;

			tr = new HtmlTableRow();    //Output <TR>
				if (datEvenMgt!=null)
				{
					foreach (DataTable dt in datEvenMgt.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray"); 
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>

							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							if (count==10)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								groupBy=2;
								portCount=0;
							}
							portCount++;
							count++;
						}
					}
				}
					td = new HtmlTableCell(); //Output <TD>
//						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
//						td.Attributes.Add("colspan","5");
						td.Attributes.Add("class","txtAlignMiddleCenter");
						td.InnerHtml = "&#xa0;";
					tr.Cells.Add(td);         //Output </TD>
				tr.Attributes.Add("class","blackheading");
				count=1;
				groupBy=4;
				if (datEvenTwo!=null)
				{
					foreach (DataTable dt in datEvenTwo.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
								td.Attributes.Add("style","border:1px solid gray");
							if (dr["reserved"].ToString()!="0" || dr["cabledTo"].ToString()!="")
							{
								sql="SELECT * FROM rackspace WHERE rackspaceId="+dr["cabledTo"].ToString();
								td.InnerHtml="<A class='black' onclick=\"window.open('portDetail.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portDetailWin','width=315,height=650,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenUsed.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							else
							{
								td.InnerHtml="<A class='black' onclick=\"window.open('portAssign.aspx?switch="+access+"&amp;portid="+dr["portId"].ToString()+"&amp;dc="+dcPrefix+"','portAssignWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/"+dr["mode"]+"EvenOpen.png' border='0' ALT='Slot "+dr["slot"]+", Port "+dr["portNum"]+"'/></A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							if (portCount==groupBy)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								portCount=0;
							}
							if (count==10)
							{
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black");
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.Attributes.Add("class","txtAlignMiddleCenter sw25wide");
									td.Attributes.Add("style","border:1px black"); 
									td.InnerHtml="&#xa0;";
								tr.Cells.Add(td);         //Output </TD>
								groupBy=2;
								portCount=0;
							}
							portCount++;
							count++;
						}
					}
				}
				else
				{
					while (filler<portsInRow)
					{
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="&#xa0;";
						tr.Cells.Add(td);         //Output </TD>
						filler++;
					}
					filler=1;
				}
			switchTbl.Rows.Add(tr);           //Output </TR>
		}
	}
	if (type=="")
	{
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Manage Switches";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	bool noTable=false, fill=false;
	int countBc, countSw;
	string sql,sql1, sqlBc="", sqlSw="", defaultDc="", sqlTablePrefix="";
	DataSet datBc, datSw;
	string v_username;
	string arg, name, dcArg="";
	string v_userclass="";
	HtmlTableRow tr;
	HtmlTableCell td;

	DataSet dat = new DataSet();

	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);
	string optionDesc="", optionVal="";
	if (dat!=null)
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
			lfind = dcSelector.Items.FindByValue(dr["dcPrefix"].ToString());
			if (lfind==null)
			{
				ListItem ladd = new ListItem(optionDesc, optionVal);
				dcSelector.Items.Add(ladd);
			}
		}	
	}


	if (!IsPostBack)
	{
 
		string v_selectedDc="";
		try
		{
			v_selectedDc = Request.Cookies["selectedDc"].Value;
		}
		catch (System.Exception ex)
		{
			v_selectedDc = "";
		}
		dcSelector.SelectedIndex=dcSelector.Items.IndexOf(dcSelector.Items.FindByValue(v_selectedDc));
	}

	try
	{
		arg=Request.QueryString["arg"].ToString();
	}
	catch (System.Exception ex)
	{
		arg = "";
	}

	try
	{
		name=Request.QueryString["name"].ToString();
	}
	catch (System.Exception ex)
	{
		name = "";
	}

	try
	{
		dcArg=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcArg= "";
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

	titleSpan.InnerHtml="<SPAN class='heading1'>Manage Switches</SPAN>";

	if (v_userclass=="3" || v_userclass=="99")
	{
		if (sqlTablePrefix!="*")
		{
					addSwitch.InnerHtml = "<BUTTON id='addNewSwButn' onclick=\"window.open('newHardware.aspx?req=Switch&amp;dc="+sqlTablePrefix+"','newSwitchWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' ALT=''/>&nbsp;Add New Switch &nbsp;</BUTTON>&nbsp; &nbsp; &nbsp;<BUTTON id='addCablingButn' onclick=\"window.open('bulkCabling_popup.aspx?req=Switch&amp;dc="+sqlTablePrefix+"','newBulkCabling','width=1280,height=800,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' ALT=''/>&nbsp; Add Cabling &nbsp;</BUTTON>";
		}
		else
		{
					addSwitch.InnerHtml = "<TABLE style='width:40%;' class='datatable center'><TR class='linktable'><TD style='width:150px;'><SPAN class='italic'>NOTE: Choose a datacenter to <BR/>add hardware and clusters.</SPAN></TD></TR></TABLE>";
		}

	}

	if (arg.Contains("catalyst6509switch"))
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","25");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			sql="SELECT * FROM "+dcArg+"switches WHERE switchName='"+name.ToString()+"'";
//			Response.Write(sql+"<BR/>");
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getCatalystFiber(name,"1",dcArg);
		getSwPorts(name,"2",dcArg);
		getSwPorts(name,"3",dcArg);
		getSwPorts(name,"4",dcArg);
		fillSlot("5",24);
		fillSlot("6",24);
		getSwPorts(name,"7",dcArg);
		getSwPorts(name,"8",dcArg);
		getSwPorts(name,"9",dcArg);
	}

	if (arg=="ds9509-emc")
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","21");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			if (sqlTablePrefix=="*")
			{
				sql="SELECT dcPrefix FROM datacenters";
				dat=readDb(sql);
				if (dat!=null)
				{
					string newSql="";
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (newSql!="")
							{
								newSql=newSql+" UNION ALL ";
							}
							newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
						}
					}
//					Response.Write(newSql+"<BR/>");
					sql="SELECT * FROM ("+newSql+") AS selectedSwitch";
				}
			}
			else
			{
				sql="SELECT * FROM "+sqlTablePrefix+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
			}
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getFiber(name,"1",2,16,4,dcArg);  //getFiber(switchName, desiredSlot, numRows, portsInRow, groupBy)
		getFiber(name,"2",2,16,4,dcArg);
		getFiber(name,"3",2,16,4,dcArg);
		getFiber(name,"4",2,16,4,dcArg);
		fillSlot("5",20);
		fillSlot("6",20);
		getFiber(name,"7",2,16,4,dcArg);
		getFiber(name,"8",2,16,4,dcArg);
		getFiber(name,"9",2,16,4,dcArg);
	}

	if (arg=="mds9120")
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","105");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			if (sqlTablePrefix=="*")
			{
				sql="SELECT dcPrefix FROM datacenters";
				dat=readDb(sql);
				if (dat!=null)
				{
					string newSql="";
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (newSql!="")
							{
								newSql=newSql+" UNION ALL ";
							}
							newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
						}
					}
//					Response.Write(newSql+"<BR/>");
					sql="SELECT * FROM ("+newSql+") AS selectedSwitch";
				}
			}
			else
			{
				sql="SELECT * FROM "+sqlTablePrefix+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
			}
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getFiber(name,"1",1,20,4,dcArg);  //getFiber(switchName, desiredSlot, numRows, portsInRow, groupBy)
	}

	if (arg=="mds9020")
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","104");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			if (sqlTablePrefix=="*")
			{
				sql="SELECT dcPrefix FROM datacenters";
				dat=readDb(sql);
				if (dat!=null)
				{
					string newSql="";
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (newSql!="")
							{
								newSql=newSql+" UNION ALL ";
							}
							newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
						}
					}
//					Response.Write(newSql+"<BR/>");
					sql="SELECT * FROM ("+newSql+") AS selectedSwitch";
				}
			}
			else
			{
				sql="SELECT * FROM "+sqlTablePrefix+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
			}
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getFiber(name,"1",1,20,4,dcArg);  //getFiber(switchName, desiredSlot, numRows, portsInRow, groupBy)
	}

	if (arg=="nexus2232pp")
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","26");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			if (sqlTablePrefix=="*")
			{
				sql="SELECT dcPrefix FROM datacenters";
				dat=readDb(sql);
				if (dat!=null)
				{
					string newSql="";
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (newSql!="")
							{
								newSql=newSql+" UNION ALL ";
							}
							newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
						}
					}
//					Response.Write(newSql+"<BR/>");
					sql="SELECT * FROM ("+newSql+") AS selectedSwitch";
				}
			}
			else
			{
				sql="SELECT * FROM "+sqlTablePrefix+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
			}
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getNexus(name,arg,dcArg);  //getFiber(switchName, desiredSlot, numRows, portsInRow, groupBy)
	}

	if (arg=="nexus2248tp")
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","26");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			if (sqlTablePrefix=="*")
			{
				sql="SELECT dcPrefix FROM datacenters";
				dat=readDb(sql);
				if (dat!=null)
				{
					string newSql="";
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (newSql!="")
							{
								newSql=newSql+" UNION ALL ";
							}
							newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
						}
					}
//					Response.Write(newSql+"<BR/>");
					sql="SELECT * FROM ("+newSql+") AS selectedSwitch";
				}
			}
			else
			{
				sql="SELECT * FROM "+sqlTablePrefix+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
			}
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getNexus(name,arg,dcArg);  //getFiber(switchName, desiredSlot, numRows, portsInRow, groupBy)
	}

	if (arg=="nexus5020")
	{
//		Response.Write(arg.ToString()+"<BR/>"+name.ToString());
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
		td = new HtmlTableCell(); //Output <TD>
			td.Attributes.Add("colspan","104");
			td.Attributes.Add("class","txtAlignMiddleCenter");
			if (sqlTablePrefix=="*")
			{
				sql="SELECT dcPrefix FROM datacenters";
				dat=readDb(sql);
				if (dat!=null)
				{
					string newSql="";
					foreach (DataTable dt in dat.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							if (newSql!="")
							{
								newSql=newSql+" UNION ALL ";
							}
							newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
						}
					}
//					Response.Write(newSql+"<BR/>");
					sql="SELECT * FROM ("+newSql+") AS selectedSwitch";
				}
			}
			else
			{
				sql="SELECT * FROM "+sqlTablePrefix+"switches WHERE switchName='"+sqlTablePrefix+name.ToString()+"'";
			}
			dat=readDb(sql);
			if (dat!=null)
			{
				td.InnerHtml=dat.Tables[0].Rows[0]["description"].ToString();
			}
		tr.Cells.Add(td);         //Output </TD>
		switchTbl.Rows.Add(tr);           //Output </TR>
		getNexus(name,arg,dcArg);  //getFiber(switchName, desiredSlot, numRows, portsInRow, groupBy)
	}

	if (arg=="bcm")
	{
		string bcNo, nsBc, sqlNs;
		DataSet datNs;
		int Ns=0;

		try
		{
			bcNo=Request.QueryString["nos"].ToString();
		}
		catch (System.Exception ex)
		{
			bcNo = "";
		}
		
		if (bcNo!="")
		{
			Ns=Convert.ToInt32(bcNo);
		}

		sqlBc = "SELECT serverName,serverLanIp,rackspaceId FROM servers WHERE serverName='BCPHEBCM0"+bcNo+"'";
		datBc = readDb(sqlBc);
		sqlNs = "SELECT serverName,serverLanIp,rackspaceId FROM servers WHERE serverName IN ('NSPHEBC"+Ns.ToString()+"001','NSPHEBC"+Ns.ToString()+"002')";
		datNs = readDb(sqlNs);
		string sqlBcAccess="";
		string portDump="";
		DataSet datBcAccess;
		if (datBc!=null)
		{
			sql="SELECT * FROM switches";
			dat=readDb(sql);
			if (dat!=null)
			{
				int unionCount=0;
				foreach (DataTable dt in dat.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						sqlBcAccess=sqlBcAccess+"SELECT switchId, slot, portNum, comment FROM "+dr["switchName"].ToString()+" WHERE cabledTo="+datBc.Tables[0].Rows[0]["rackspaceId"].ToString()+" ORDER BY comment ASC";
						unionCount++;
						if (unionCount < 4)
						{
							sqlBcAccess=sqlBcAccess+" UNION ";
						}
					}
				}
//				Response.Write(sqlBcAccess);
				datBcAccess=readDb(sqlBcAccess);
				if (dat!=null)
				{
					foreach (DataTable dt in datBcAccess.Tables)
					{
						foreach (DataRow dr in dt.Rows)
						{
							portDump=portDump+dr["comment"].ToString()+": "+dr["switchId"].ToString()+", Slot "+dr["slot"].ToString()+", Port "+dr["portNum"].ToString()+"<BR/>";
						}
					}
				}
//				Response.Write(portDump);
			}

			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "BladeCenter #"+bcNo;
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Managment Module";
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="<SPAN class='bold'>Hostname:</SPAN> ";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml=datBc.Tables[0].Rows[0]["serverName"].ToString().ToLower()+".phe.fs.fed.us";
				tr.Cells.Add(td);         //Output </TD>				
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="<SPAN class='bold'>IP Address:</SPAN> ";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml=datBc.Tables[0].Rows[0]["serverLanIp"].ToString();
				tr.Cells.Add(td);         //Output </TD>				
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="<SPAN class='bold'>Porting:</SPAN> ";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml=portDump;
				tr.Cells.Add(td);         //Output </TD>				
			switchTbl.Rows.Add(tr);           //Output </TR>

			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Managed Switches";
				tr.Cells.Add(td);         //Output </TD>
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="<SPAN class='bold'>Switch A:</SPAN> ";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml=datNs.Tables[0].Rows[0]["serverLanIp"].ToString();
				tr.Cells.Add(td);         //Output </TD>				
			switchTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="<SPAN class='bold'>Switch B:</SPAN> ";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml=datNs.Tables[0].Rows[1]["serverLanIp"].ToString();
				tr.Cells.Add(td);         //Output </TD>				
			switchTbl.Rows.Add(tr);           //Output </TR>
		}
	}


	if (arg=="" || arg=="bcm")
	{
		if (sqlTablePrefix=="*")
		{
			sql="SELECT dcPrefix FROM datacenters";
			dat=readDb(sql);
			if (dat!=null)
			{
				string newSql="";
				foreach (DataTable dt in dat.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						if (newSql!="")
						{
							newSql=newSql+" UNION ALL ";
						}
						newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches INNER JOIN "+dr["dcPrefix"].ToString()+"rackspace ON "+dr["dcPrefix"].ToString()+"rackspace.rackspaceId="+dr["dcPrefix"].ToString()+"switches.rackspaceId WHERE media='Ethernet'";
					}
				}
//				Response.Write(newSql+"<BR/>");
				sqlSw=newSql+" ORDER BY switchName ASC";
			}
		}
		else
		{
			sqlSw = "SELECT * FROM "+sqlTablePrefix+"switches INNER JOIN "+sqlTablePrefix+"rackspace ON "+sqlTablePrefix+"rackspace.rackspaceId="+sqlTablePrefix+"switches.rackspaceId WHERE media='Ethernet' ORDER BY switchName ASC";
		}
//		Response.Write(sqlSw+"<BR/>");
		datSw = readDb(sqlSw);
		if (datSw!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = "Backbone Access Switches";
				tr.Cells.Add(td);         //Output </TD>
			ethernetTbl.Rows.Add(tr);           //Output </TR>
			countSw = 1;
			foreach (DataTable dtSw in datSw.Tables)
			{
				foreach (DataRow drSw in dtSw.Rows)
				{	
					if (drSw["switchName"].ToString()!="")
					{
						if (countSw==1) tr = new HtmlTableRow();    //Output <TR>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","green");
							td.InnerHtml = "<A HREF='switches.aspx?arg="+removeSpaces(drSw["class"].ToString().ToLower())+"&amp;name="+drSw["switchName"].ToString()+"&amp;dc="+drSw["switchName"].ToString().Substring(0,drSw["switchName"].ToString().IndexOf("_")+1)+"'	class='nodec'>"+drSw["switchName"].ToString().Substring(0,drSw["switchName"].ToString().IndexOf("_")).ToUpper()+": "+drSw["description"].ToString()+"</A><BR/><SPAN class='italic smaller'>Rack "+drSw["rack"].ToString()+", Slot "+drSw["slot"].ToString()+"</SPAN>";
							td.Attributes.Add("style","width:125px;");
						tr.Cells.Add(td);         //Output </TD>
						if (countSw==4)
						{
							ethernetTbl.Rows.Add(tr);           //Output </TR>
							countSw=1;
						}
						else
						{
							countSw++;
						}	
					}
					ethernetTbl.Rows.Add(tr);           //Output </TR>
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","green");
					td.Attributes.Add("colspan","4");
					td.Attributes.Add("style","width:500px;");
					td.InnerHtml = "BACKBONE: No Switches Found";
				tr.Cells.Add(td);         //Output </TD>
			ethernetTbl.Rows.Add(tr);           //Output </TR>
		}

		if (sqlTablePrefix=="*")
		{
			sql="SELECT dcPrefix FROM datacenters";
			dat=readDb(sql);
			if (dat!=null)
			{
				string newSql="";
				foreach (DataTable dt in dat.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						if (newSql!="")
						{
							newSql=newSql+" UNION ALL ";
						}
						newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches INNER JOIN "+dr["dcPrefix"].ToString()+"rackspace ON "+dr["dcPrefix"].ToString()+"rackspace.rackspaceId="+dr["dcPrefix"].ToString()+"switches.rackspaceId WHERE media LIKE 'FCoE%'";
					}
				}
//				Response.Write(newSql+"<BR/>");
				sqlSw=newSql+" ORDER BY switchName ASC";
			}
		}
		else
		{
			sqlSw = "SELECT * FROM "+sqlTablePrefix+"switches INNER JOIN "+sqlTablePrefix+"rackspace ON "+sqlTablePrefix+"rackspace.rackspaceId="+sqlTablePrefix+"switches.rackspaceId WHERE media LIKE 'FCoE%' ORDER BY switchName ASC";
		}
//		Response.Write(sqlSw+"<BR/>");
		datSw = readDb(sqlSw);
		if (datSw!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = "FCoE Access Switches";
				tr.Cells.Add(td);         //Output </TD>
			fcoeTbl.Rows.Add(tr);           //Output </TR>
			countSw = 1;
			foreach (DataTable dtSw in datSw.Tables)
			{
				foreach (DataRow drSw in dtSw.Rows)
				{	
					if (drSw["switchName"].ToString()!="")
					{
						if (countSw==1) tr = new HtmlTableRow();    //Output <TR>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","green");
							td.InnerHtml = "<A HREF='switches.aspx?arg="+removeSpaces(drSw["class"].ToString().ToLower())+"&amp;name="+drSw["switchName"].ToString()+"&amp;dc="+drSw["switchName"].ToString().Substring(0,drSw["switchName"].ToString().IndexOf("_")+1)+"'	class='nodec'>"+drSw["switchName"].ToString().Substring(0,drSw["switchName"].ToString().IndexOf("_")).ToUpper()+": "+drSw["description"].ToString()+"</A><BR/><SPAN class='italic smaller'>Rack "+drSw["rack"].ToString()+", Slot "+drSw["slot"].ToString()+"</SPAN>";
							td.Attributes.Add("style","width:125px;");
						tr.Cells.Add(td);         //Output </TD>
						if (countSw==4)
						{
							fcoeTbl.Rows.Add(tr);           //Output </TR>
							countSw=1;
						}
						else
						{
							countSw++;
						}	
					}
					fcoeTbl.Rows.Add(tr);           //Output </TR>
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","green");
					td.Attributes.Add("colspan","4");
					td.Attributes.Add("style","width:500px;");
					td.InnerHtml = "FCoE: No Switches Found";
				tr.Cells.Add(td);         //Output </TD>
			fcoeTbl.Rows.Add(tr);           //Output </TR>
		}

		if (sqlTablePrefix=="*")
		{
			sql="SELECT dcPrefix FROM datacenters";
			dat=readDb(sql);
			if (dat!=null)
			{
				string newSql="";
				foreach (DataTable dt in dat.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						if (newSql!="")
						{
							newSql=newSql+" UNION ALL ";
						}
						newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"switches INNER JOIN "+dr["dcPrefix"].ToString()+"rackspace ON "+dr["dcPrefix"].ToString()+"rackspace.rackspaceId="+dr["dcPrefix"].ToString()+"switches.rackspaceId WHERE media='Fibre Channel'";
					}
				}
//				Response.Write(newSql+"<BR/>");
				sqlSw=newSql+" ORDER BY switchName ASC";
			}
		}
		else
		{
			sqlSw = "SELECT * FROM "+sqlTablePrefix+"switches INNER JOIN "+sqlTablePrefix+"rackspace ON "+sqlTablePrefix+"rackspace.rackspaceId="+sqlTablePrefix+"switches.rackspaceId WHERE media='Fibre Channel' ORDER BY switchName ASC";
		}
//		Response.Write(sqlSw+"<BR/>");
		datSw = readDb(sqlSw);
		if (datSw!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = "Fibre Channel SAN Switches";
				tr.Cells.Add(td);         //Output </TD>
			fibreTbl.Rows.Add(tr);           //Output </TR>
			countSw = 1;
			foreach (DataTable dtSw in datSw.Tables)
			{
				foreach (DataRow drSw in dtSw.Rows)
				{	
					if (drSw["switchName"].ToString()!="")
					{
						if (countSw==1) tr = new HtmlTableRow();    //Output <TR>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","green");
							td.InnerHtml = "<A HREF='switches.aspx?arg="+removeSpaces(drSw["class"].ToString().ToLower())+"&amp;name="+drSw["switchName"].ToString()+"&amp;dc="+drSw["switchName"].ToString().Substring(0,drSw["switchName"].ToString().IndexOf("_")+1)+"'	class='nodec'>"+drSw["switchName"].ToString().Substring(0,drSw["switchName"].ToString().IndexOf("_")).ToUpper()+": "+drSw["description"].ToString()+"</A><BR/><SPAN class='italic smaller'>Rack "+drSw["rack"].ToString()+", Slot "+drSw["slot"].ToString()+"</SPAN>";
							td.Attributes.Add("style","width:125px;");
						tr.Cells.Add(td);         //Output </TD>
						if (countSw==4)
						{
							fibreTbl.Rows.Add(tr);           //Output </TR>
							countSw=1;
						}
						else
						{
							countSw++;
						}	
					}
					fibreTbl.Rows.Add(tr);           //Output </TR>
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","green");
					td.Attributes.Add("colspan","4");
					td.Attributes.Add("style","width:500px;");
					td.InnerHtml = "SAN FABRIC: No Switches Found";
				tr.Cells.Add(td);         //Output </TD>
			fibreTbl.Rows.Add(tr);           //Output </TR>
		}
	}

	if (arg=="" || arg=="bcm")
	{
		if (sqlTablePrefix=="*")
		{
			sql="SELECT dcPrefix FROM datacenters";
			dat=readDb(sql);
			if (dat!=null)
			{
				string newSql="";
				foreach (DataTable dt in dat.Tables)
				{
					foreach (DataRow dr in dt.Rows)
					{
						if (newSql!="")
						{
							newSql=newSql+" UNION ALL ";
						}
						newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"bladeChassis WHERE ethernetType='managedSwitch'";
					}
				}
//				Response.Write(newSql+"<BR/>");
				sqlBc=newSql+" ORDER BY bc";
			}
		}
		else
		{
			sqlBc = "SELECT * FROM "+sqlTablePrefix+"bladeChassis WHERE ethernetType='managedSwitch' ORDER BY bc";
		}
//		Response.Write(sqlBc+"<BR/>");
		datBc = readDb(sqlBc);
		if (datBc!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = "BladeCenter Managed Switches";
				tr.Cells.Add(td);         //Output </TD>
			bcTbl.Rows.Add(tr);           //Output </TR>
			countBc = 1;
			foreach (DataTable dtBc in datBc.Tables)
			{
				foreach (DataRow drBc in dtBc.Rows)
				{	
					if (drBc["bc"].ToString()!="")
					{
						if (countBc==1) tr = new HtmlTableRow();    //Output <TR>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","green");
							td.InnerHtml = "<A HREF='switches.aspx?arg=bcm&amp;nos="+drBc["bc"].ToString()+"&amp;dc="+drBc["dcPrefix"].ToString()+"'	class='nodec'>"+drBc["dcPrefix"].ToString().ToUpper().Replace("_","")+": BladeCenter # "+drBc["bc"].ToString()+"</A>";
							td.Attributes.Add("style","width:125px;");
						tr.Cells.Add(td);         //Output </TD>
						if (countBc==4)
						{
							bcTbl.Rows.Add(tr);           //Output </TR>
							countBc=1;
						}
						else
						{
							countBc++;
						}	
					}
					bcTbl.Rows.Add(tr);           //Output </TR>
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","green");
					td.Attributes.Add("colspan","4");
					td.Attributes.Add("style","width:500px;");
					td.InnerHtml = "BCs: No Switches Found";
				tr.Cells.Add(td);         //Output </TD>
			bcTbl.Rows.Add(tr);           //Output </TR>
		}
	}
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file="banner.inc" -->
<!--#include file="menu.inc" -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<BR/><BR/>
			<SPAN id='addSwitch' runat='server'/>
			<BR/><BR/><BR/>
		</DIV>
		<TABLE id='ethernetTbl' runat='server' class='datatable center' />
		<BR/><BR/>
		<TABLE id='fibreTbl' runat='server' class='datatable center' />
		<BR/><BR/>
		<TABLE id='fcoeTbl' runat='server' class='datatable center' />
		<BR/><BR/>
		<TABLE id='bcTbl' runat='server' class='datatable center' />
		<BR/><BR/>
		<DIV id='hrSpan' runat='server'/><BR/>
		<TABLE id='switchTbl' runat='server' class='datatable center' />
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>