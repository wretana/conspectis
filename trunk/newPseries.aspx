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
	lockout(); Page.Header.Title=shortSysName+": Add New P-Series";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	int maxBc=0, thisBc=0;
	string sql;
	DataSet dat, hwdd;
	string errStr="", sqlErr="";
	HttpCookie cookie;
	bool sqlSuccess=true, permitted=false;
	string editHw="";
	string v_username, v_userclass="", v_userrole="", inheritType="";

	DateTime dateStamp = DateTime.Now;

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

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}
	
	try
	{
		inheritType=Request.QueryString["type"].ToString();	
	}
	catch (System.Exception ex)
	{
		inheritType="";
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

	titleSpan.InnerHtml=dcArg.ToUpper().Replace("_","");

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}
	

	if (!IsPostBack)
	{
		sql="SELECT hwClassName FROM hwTypes WHERE hwClassName LIKE 'P%' ORDER BY hwClassName ASC";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["hwClassName"].ToString(), dr["hwClassName"].ToString());
				formHwClass.Items.Add(li);
			}
		}
		sql="SELECT location, rackId FROM "+dcArg+"racks ORDER BY rackId ASC";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["location"].ToString()+"-R"+dr["rackId"].ToString().Substring(0,2)+"-C"+dr["rackId"].ToString().Substring(2,2), dr["rackId"].ToString());
				formHwRack.Items.Add(li);
			}
		}

		if (inheritType!="")
		{
			formHwClass.Value=inheritType;
		}
	}

	if (IsPostBack)
	{
		string v_class=fix_txt(formHwClass.Value);
		string v_serial=fix_txt(formHwSerial.Value);
		string v_model=fix_txt(formHwModel.Value);
		string v_rack=fix_txt(formHwRack.Value);

		string v_topU=fix_txt(formHwTopU.Value); 
		string v_botU=fix_txt(formHwBotU.Value);
		string v_sanAtt=formHwSanAttach.Value;
		string v_belongsTo="";
		string v_slot="";
		string v_reserved=formHwServer.Value;
		int topU=0, botU=0, uDiff=0;
		bool checkErr=false;

		int v_Lpars=0;
		int n=0;
		if (formHwLpars.Value!="")
		{
			v_Lpars=Convert.ToInt32(formHwLpars.Value.ToString());
		}

		switch (v_topU)
		{
			case "1":
			formHwTopU.Value="01";
			v_topU="01";
			break;
			case "2":
			formHwTopU.Value="02";
			v_topU="02";
			break;
			case "3":
			formHwTopU.Value="03";
			v_topU="03";
			break;
			case "4":
			formHwTopU.Value="04";
			v_topU="04";
			break;
			case "5":
			formHwTopU.Value="05";
			v_topU="05";
			break;
			case "6":
			formHwTopU.Value="06";
			v_topU="06";
			break;
			case "7":
			formHwTopU.Value="07";
			v_topU="07";
			break;
			case "8":
			formHwTopU.Value="08";
			v_topU="08";
			break;
			case "9":
			formHwTopU.Value="09";
			v_topU="09";
			break;
			case "0":
			formHwTopU.Value="00";
			v_topU="00";
			break;
		}
		switch (v_botU)
		{
			case "1":
			formHwBotU.Value="01";
			v_botU="01";
			break;
			case "2":
			formHwBotU.Value="02";
			v_botU="02";
			break;
			case "3":
			formHwBotU.Value="03";
			v_botU="03";
			break;
			case "4":
			formHwBotU.Value="04";
			v_botU="04";
			break;
			case "5":
			formHwBotU.Value="05";
			v_botU="05";
			break;
			case "6":
			formHwBotU.Value="06";
			v_botU="06";
			break;
			case "7":
			formHwBotU.Value="07";
			v_botU="07";
			break;
		    case "8":
			formHwBotU.Value="08";
			v_botU="08";
			break;
		    case "9":
			formHwBotU.Value="09";
			v_botU="09";
			break;
			case "0":
			formHwBotU.Value="00";
			v_botU="00";
			break;
		}

		if (v_topU!="")
		{
			topU=Convert.ToInt32(v_topU);
		}

		if (v_botU!="")
		{
			botU=Convert.ToInt32(v_botU);
		}

		uDiff=topU-botU;
		uDiff++;

		if (v_topU!=null && v_botU!=null && v_topU!="" && v_botU!="")
		{
			sql="SELECT hwUSize FROM hwTypes WHERE hwClassName='"+v_class+"'";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				if (Convert.ToInt32(dat.Tables[0].Rows[0]["hwUSize"].ToString())-uDiff!=0) 
				{
					errStr = "Error - "+v_class+" should occupy "+dat.Tables[0].Rows[0]["hwUSize"].ToString()+"U. ("+uDiff.ToString()+")<BR/>";
					errmsg.InnerHtml=errStr;
					checkErr=true;
				}
				else
				{
					
					errStr="";
					errmsg.InnerHtml=errStr;
				}
			}
			v_slot=v_botU+"-"+v_topU;
		}

		if (v_rack!="" && v_slot!="" )
		{
			sql = "SELECT * FROM "+dcArg+"rackspace WHERE rack='"+v_rack+"' AND slot LIKE '%"+v_slot.Substring(0,2)+"%'";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				checkErr=true;
				errmsg.InnerHtml="Device already present in Rack "+v_rack+", Slot "+v_slot+": "+dat.Tables[0].Rows[0]["class"].ToString()+" ("+dat.Tables[0].Rows[0]["rackspaceId"].ToString()+")";
			}
		}


		if (v_rack!=null && v_rack!="" && v_class!=null && v_class!="" && v_serial!=null && v_serial!="" && v_model!=null && v_model!=""&& !checkErr)
		{
			sql = "INSERT INTO "+dcArg+"rackspace(rack,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_slot+ "',"
							+"'" +v_reserved+ "',"
							+"'" +v_class+ "',"
							+"'" +v_serial+ "',"
							+"'" +v_model+ "',"
							+"'" +v_sanAtt+   "')";
			sqlErr=writeDb(sql);
			Response.Write(sql);
			if (sqlErr!=null && sqlErr!="")
			{
				sqlSuccess=false;
			}
			else
			{
				errmsg.InnerHtml = "SQL Update Error - P-Series<BR/>"+sqlErr;
				sqlErr="";
			}
			if (v_Lpars>0)
			{
				while (n < v_Lpars) 
				{
//					v_class="Virtual";
					sql = "INSERT INTO "+dcArg+"rackspace(rack,slot,reserved,class,serial,model,sanAttached) VALUES("
									+"'" +v_rack+ "',"
									+"'" +v_slot+ "',"
									+"'" +v_reserved+ "',"
									+"'Virtual',"
									+"'" +v_serial+ "',"
									+"'" +v_class+ "-Virtual',"
									+"'" +v_sanAtt+   "')";
					sqlErr=writeDb(sql);
					Response.Write(sql);
					if (sqlErr!=null && sqlErr!="")
					{
						sqlSuccess=false;
					}
					else
					{
						errmsg.InnerHtml = "SQL Update Error - LPARS ("+n+")<BR/>"+sqlErr;
						sqlErr="";
					}
					n++;
				}
			}
			if (sqlSuccess) 
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "P-Series at Rack "+v_rack+",U "+v_slot+" created with "+v_Lpars+" LPARs.");	

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
	}
	titleSpan.InnerHtml="Add New P-Series";
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
									<TD class='inputform'>Type/Class:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwClass' style='width:160px;' runat='server'>
											<OPTION value='' selected='true'></OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Model:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwModel' size='26' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Serial:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwSerial' size='26' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>Cabinet:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwRack' style='width:160px;' runat='server'>
											<OPTION value='' selected='true'></OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Bottom 'U':</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwBotU' size='26' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Top 'U':</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwTopU' size='26' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
								<TR>
									<TD class='inputform'>Server?:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwServer' runat='server'>
											<OPTION value='1'>No</OPTION>
											<OPTION value='0' selected='true'>Yes</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>SAN Attached?:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwSanAttach' runat='server'>
											<OPTION value='0' selected='true'>No</OPTION>
											<OPTION value='1'>Yes</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>LPARs:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwLpars' size='3' runat='server' />
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
		&nbsp;<BR/>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>