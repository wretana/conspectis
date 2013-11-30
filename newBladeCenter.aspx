<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-13-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Add New BladeCenter";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	int maxBc=0, thisBc=0;
	string sql, sqlErr;
	DataSet dat, hwdd;
	HttpCookie cookie;
	bool sqlSuccess=true, permitted=false;
	string editHw="";
	string v_username, v_userclass="", v_userrole="", isRedir="";

	DateTime dateStamp = DateTime.Now;

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
		isRedir=Request.QueryString["redir"].ToString();	
	}
	catch (System.Exception ex)
	{
		isRedir="";
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

	if (IsPostBack)
	{
	}

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}
	
	sql="SELECT MAX(bc) FROM "+dcArg+"rackspace";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		try
		{
			switch (sqlDialect)
			{
				case "MSJET":
					maxBc=Convert.ToInt32(dat.Tables[0].Rows[0]["Expr1000"].ToString());
				break;
				case "MSSQL":
					maxBc=Convert.ToInt32(dat.Tables[0].Rows[0]["Column1"].ToString());
				break;
			}
//			maxBc=Convert.ToInt32(dat.Tables[0].Rows[0]["Expr1000"].ToString());
		}
		catch (System.Exception ex)
		{
			maxBc=0;
		}
		
	}

	thisBc=maxBc+1;
	titleSpan.InnerHtml=dcArg.ToUpper().Replace("_","")+" BladeCenter #"+thisBc.ToString();
	
	if (!IsPostBack)
	{
		sql="SELECT hwClassName FROM hwTypes WHERE hwType='Chassis'";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["hwClassName"].ToString(), dr["hwClassName"].ToString());
				formHwClass.Items.Add(li);
			}
		}
		sql="SELECT rackId FROM "+dcArg+"racks ORDER BY rackId ASC";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem("R:"+dr["rackId"].ToString().Substring(0,2)+", C:"+dr["rackId"].ToString().Substring(2,2), dr["rackId"].ToString());
				formHwRack.Items.Add(li);
			}
		}
		sql="SELECT hwClassName FROM hwTypes WHERE hwType='Blade' ORDER BY hwClassName ASC";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["hwClassName"].ToString(), dr["hwClassName"].ToString());
				formTypeSlot1.Items.Add(li);
				formTypeSlot2.Items.Add(li);
				formTypeSlot3.Items.Add(li);
				formTypeSlot4.Items.Add(li);
				formTypeSlot5.Items.Add(li);
				formTypeSlot6.Items.Add(li);
				formTypeSlot7.Items.Add(li);
				formTypeSlot8.Items.Add(li);
				formTypeSlot9.Items.Add(li);
				formTypeSlot10.Items.Add(li);
				formTypeSlot11.Items.Add(li);
				formTypeSlot12.Items.Add(li);
				formTypeSlot13.Items.Add(li);
				formTypeSlot14.Items.Add(li);
			}
		}
		if (isRedir=="1")
		{
			sql="SELECT TOP 1 [num],class FROM (SELECT COUNT(*)AS [num], class FROM "+dcArg+"rackspace WHERE class IN (SELECT hwClassName FROM hwTypes WHERE hwType='chassis') GROUP BY class ) AS b ORDER BY num DESC";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				formHwClass.SelectedIndex=formHwClass.Items.IndexOf(formHwClass.Items.FindByValue(dat.Tables[0].Rows[0]["class"].ToString()));
			}
			
			formHwServer.SelectedIndex=formHwServer.Items.IndexOf(formHwServer.Items.FindByValue("1"));
			formHwServer.Disabled=true;
		}
	}

	if (IsPostBack)
	{
		string v_rack=fix_txt(formHwRack.Value),v_bc=thisBc.ToString(),v_class=fix_txt(formHwClass.Value),v_serial=fix_txt(formHwSerial.Value),v_model=fix_txt(formHwModel.Value),v_sanAtt=formHwSanAttach.Value;
		string v_belongsTo="",v_slot="",v_reserved="";
		string slot1_type=formTypeSlot1.Value, slot1_model=formModelSlot1.Value, slot1_serial=formSerialSlot1.Value;
		string slot2_type=formTypeSlot2.Value, slot2_model=formModelSlot2.Value, slot2_serial=formSerialSlot2.Value;
		string slot3_type=formTypeSlot3.Value, slot3_model=formModelSlot3.Value, slot3_serial=formSerialSlot3.Value;
		string slot4_type=formTypeSlot4.Value, slot4_model=formModelSlot4.Value, slot4_serial=formSerialSlot4.Value;
		string slot5_type=formTypeSlot5.Value, slot5_model=formModelSlot5.Value, slot5_serial=formSerialSlot5.Value;
		string slot6_type=formTypeSlot6.Value, slot6_model=formModelSlot6.Value, slot6_serial=formSerialSlot6.Value;
		string slot7_type=formTypeSlot7.Value, slot7_model=formModelSlot7.Value, slot7_serial=formSerialSlot7.Value;
		string slot8_type=formTypeSlot8.Value, slot8_model=formModelSlot8.Value, slot8_serial=formSerialSlot8.Value;
		string slot9_type=formTypeSlot9.Value, slot9_model=formModelSlot9.Value, slot9_serial=formSerialSlot9.Value;
		string slot10_type=formTypeSlot10.Value, slot10_model=formModelSlot10.Value, slot10_serial=formSerialSlot10.Value;
		string slot11_type=formTypeSlot11.Value, slot11_model=formModelSlot11.Value, slot11_serial=formSerialSlot11.Value;
		string slot12_type=formTypeSlot12.Value, slot12_model=formModelSlot12.Value, slot12_serial=formSerialSlot12.Value;
		string slot13_type=formTypeSlot13.Value, slot13_model=formModelSlot13.Value, slot13_serial=formSerialSlot13.Value;
		string slot14_type=formTypeSlot14.Value, slot14_model=formModelSlot14.Value, slot14_serial=formSerialSlot14.Value;


		if (v_rack!=null && v_rack!="" && v_class!=null && v_class!="" && v_serial!=null && v_serial!="" && v_model!=null && v_model!="")
		{
			v_slot="00";
			v_reserved="1";
			sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'" +v_slot+ "',"
							+"'" +v_reserved+ "',"
							+"'" +v_class+ "',"
							+"'" +v_serial+ "',"
							+"'" +v_model+ "',"
							+"'" +v_sanAtt+   "')";
			sqlErr=writeDb(sql);
			if (sqlErr!=null && sqlErr!="")
			{
				sqlSuccess=false;
			}
			else
			{
				errmsg.InnerHtml = "SQL Update Error - BC Chassis<BR/>"+sqlErr;
				sqlErr="";
			}
			if (slot1_type!=null && slot1_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'01',"
							+"'0',"
							+"'" +slot1_type+ "',"
							+"'" +slot1_serial+ "',"
							+"'" +slot1_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 1<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot2_type!=null && slot2_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'02',"
							+"'0',"
							+"'" +slot2_type+ "',"
							+"'" +slot2_serial+ "',"
							+"'" +slot2_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 2<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot3_type!=null && slot3_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'03',"
							+"'0',"
							+"'" +slot3_type+ "',"
							+"'" +slot3_serial+ "',"
							+"'" +slot3_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 3<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot4_type!=null && slot4_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'04',"
							+"'0',"
							+"'" +slot4_type+ "',"
							+"'" +slot4_serial+ "',"
							+"'" +slot4_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 4<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot5_type!=null && slot5_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'05',"
							+"'0',"
							+"'" +slot5_type+ "',"
							+"'" +slot5_serial+ "',"
							+"'" +slot5_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 5<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot6_type!=null && slot6_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'06',"
							+"'0',"
							+"'" +slot6_type+ "',"
							+"'" +slot6_serial+ "',"
							+"'" +slot6_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 6<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot7_type!=null && slot7_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'07',"
							+"'0',"
							+"'" +slot7_type+ "',"
							+"'" +slot7_serial+ "',"
							+"'" +slot7_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 7<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot8_type!=null && slot8_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'08',"
							+"'0',"
							+"'" +slot8_type+ "',"
							+"'" +slot8_serial+ "',"
							+"'" +slot8_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 8<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot9_type!=null && slot9_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'09',"
							+"'0',"
							+"'" +slot9_type+ "',"
							+"'" +slot9_serial+ "',"
							+"'" +slot9_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 9<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot10_type!=null && slot10_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'10',"
							+"'0',"
							+"'" +slot10_type+ "',"
							+"'" +slot10_serial+ "',"
							+"'" +slot10_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 10<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot11_type!=null && slot11_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'11',"
							+"'0',"
							+"'" +slot11_type+ "',"
							+"'" +slot11_serial+ "',"
							+"'" +slot11_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 11<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot12_type!=null && slot12_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'12',"
							+"'0',"
							+"'" +slot12_type+ "',"
							+"'" +slot12_serial+ "',"
							+"'" +slot12_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 12<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot13_type!=null && slot13_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'13',"
							+"'0',"
							+"'" +slot13_type+ "',"
							+"'" +slot13_serial+ "',"
							+"'" +slot13_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 13<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (slot14_type!=null && slot14_type!="")
			{
				sql = "INSERT INTO "+dcArg+"rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
							+"'" +v_rack+ "',"
							+"'" +v_bc+ "',"
							+"'14',"
							+"'0',"
							+"'" +slot14_type+ "',"
							+"'" +slot14_serial+ "',"
							+"'" +slot14_model+ "',"
							+"'" +v_sanAtt+   "')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr!=null && sqlErr!="")
				{
					sqlSuccess=false;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - BC Slot 14<BR/>"+sqlErr;
					sqlErr="";
				}
			}
			if (sqlSuccess) 
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "BladeCenter #"+v_bc+" created.");
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
	titleSpan.InnerHtml="Add New BladeCenter";
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
				<TABLE border='1' class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>Type/Class:</TD>
									<TD class='whiteRowFill left'>					
										<SELECT id='formHwClass' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Model:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwModel' runat='server'>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Serial:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwSerial' runat='server'>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill'>&#xa0;</TD>
								</TR>
								<TR>
									<TD class='inputform'>Cabinet:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwRack' runat='server'>
											<OPTION value='' selected='true'></OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill'>&#xa0;</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Server?:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwServer' runat='server'>
											<OPTION value='1' selected='true'>No</OPTION>
											<OPTION value='0' >Yes</OPTION>
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
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill'>&#xa0;</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill left'>&#xa0;&#xa0;&#xa0; Type &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Model &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Serial</TD>
								</TR>
								<TR>
									<TD class='inputform'>Slot 1:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot1' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot1' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot1' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 2:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot2' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot2' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot2' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 3:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot3' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0; 
										<INPUT type='text' id='formModelSlot3' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot3' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 4:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot4' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot4' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot4' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 5:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot5' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot5' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot5' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 6:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot6' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot6' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot6' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 7:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot7' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot7' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot7' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 8:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot8' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot8' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot8' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 9:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot9' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot9' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot9' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 10:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot10' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot10' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot10' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 11:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot11' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot11' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot11' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 12:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot12' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot12' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot12' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 13:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot13' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot13' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot13' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR> 
								<TR>
									<TD class='inputform'>Slot 14:</TD>
									<TD class='whiteRowFill'>
										<SELECT id='formTypeSlot14' runat='server'>
											<OPTION value='' selected='true'>Choose</OPTION>
										</SELECT>&#xa0;
										<INPUT type='text' id='formModelSlot14' size='8' maxlength='8' runat='server'/>&#xa0;
										<INPUT type='text' id='formSerialSlot14' size='8' maxlength='8' runat='server'/>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>		
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