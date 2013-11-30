<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Web.UI.WebControls"%>
<%@Import Namespace="System.Web.UI.HtmlControls"%>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-11-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">

protected void popSvrBc(object sender, EventArgs e)
{
	string sql="", sql1="";
	string fetchedBc="";
	string fetchedRack="";
	fetchedRack=fix_txt(formRackDropDown.SelectedValue);
	DataSet bcdd = new DataSet();
	DataSet slotdd = new DataSet();
	DataSet serverdd = new DataSet();
	ListItem defaultChoice = new ListItem("...","");
	
	formBcDropDown.Items.Clear();
	formSlotDropDown.Items.Clear();

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	sql="SELECT DISTINCT(bc) FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+fetchedRack+"' AND bc IS NOT NULL) AS a";

	bcdd=readDb(sql);
	if (bcdd!=null)
	{
		formBcDropDown.Attributes.Remove("disabled");
		formBcDropDown.Items.Add(defaultChoice);
		foreach(DataRow dr in bcdd.Tables[0].Rows)
		{
			ListItem li = new ListItem("BC "+dr["bc"].ToString(), dr["bc"].ToString());
			formBcDropDown.Items.Add(li);
		}
	}
	else 
	{
		ListItem li = new ListItem("N/A", "NA");
		formBcDropDown.Items.Add(li);
		formBcDropDown.SelectedValue="NA";
		formBcDropDown.Attributes.Add("disabled","true");

		sql1="SELECT DISTINCT(slot) FROM "+dcPrefix+"rackspace WHERE rack='"+fetchedRack+"' AND bc IS NULL";
		slotdd=readDb(sql1);
		if (slotdd!=null)
		{
			formSlotDropDown.Attributes.Remove("disabled");
			formSlotDropDown.Items.Add(defaultChoice);
			foreach(DataRow drS in slotdd.Tables[0].Rows)
			{
				ListItem liS= new ListItem("U "+drS["slot"].ToString(), drS["slot"].ToString());
				formSlotDropDown.Items.Add(liS);
			} 
		}
	}
	fetchedBc=fix_txt(formBcDropDown.SelectedValue);

	sql="SELECT serverName FROM (SELECT serverName FROM "+dcPrefix+"servers WHERE rackspaceId IN (SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+fetchedRack+"') AS a) AS b WHERE serverName LIKE 'S%'";
//	statusSpan.Text=sql;
	serverdd=readDb(sql);
	if (serverdd!=null)
	{
		formHostnameDropDown.Items.Clear();
		formHostnameDropDown.Attributes.Remove("disabled");
		formHostnameDropDown.Items.Add(defaultChoice);
		foreach(DataRow dr in serverdd.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["serverName"].ToString(), dr["serverName"].ToString());
			formHostnameDropDown.Items.Add(li);
		}
	}

	DataSet dat = new DataSet();
	try
	{
		dat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
	}
	try
	{
		if (dat.Tables[0].Rows.Count>0)
		{
			ShowTableData(cableBatch, dat);	
		}
	}
	catch (System.Exception ex)
	{
		cableBatch.Rows.Clear();
	}
}


protected void popSvrSlot(object sender, EventArgs e)
{
	string sql="";
	string fetchedBc="";
	fetchedBc=fix_txt(formBcDropDown.SelectedValue);
	string fetchedRack="";
	string prefix="";
	fetchedRack=fix_txt(formRackDropDown.SelectedValue);
	DataSet slotdd = new DataSet();
	DataSet serverdd = new DataSet();
	ListItem defaultChoice = new ListItem("...","");
	
	formSlotDropDown.Items.Clear();

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	sql="SELECT DISTINCT(slot) FROM "+dcPrefix+"rackspace WHERE bc='"+fetchedBc+"'";
	prefix="";
	
	slotdd=readDb(sql);
	if (slotdd!=null)
	{
		formSlotDropDown.Attributes.Remove("disabled");
		formSlotDropDown.Items.Add(defaultChoice);
		foreach(DataRow dr in slotdd.Tables[0].Rows)
		{
			if (dr["slot"].ToString()=="00")
			{
				ListItem li= new ListItem("AMM", dr["slot"].ToString());
				formSlotDropDown.Items.Add(li);
			}
			else
			{
				ListItem li= new ListItem(prefix+dr["slot"].ToString(), dr["slot"].ToString());
				formSlotDropDown.Items.Add(li);
			}
		} 
	}
	else 
	{
	}
//	formHostnameDropDown.Attributes.Add("disabled","true");
	sql="SELECT serverName FROM (SELECT serverName FROM "+dcPrefix+"servers WHERE rackspaceId IN (SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE bc='"+fetchedBc+"') AS a) AS b WHERE serverName LIKE 'S%'";
//	statusSpan.Text=sql;
	serverdd=readDb(sql);
	if (serverdd!=null)
	{
		formHostnameDropDown.Items.Clear();
		formHostnameDropDown.Attributes.Remove("disabled");
		formHostnameDropDown.Items.Add(defaultChoice);
		foreach(DataRow dr in serverdd.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["serverName"].ToString(), dr["serverName"].ToString());
			formHostnameDropDown.Items.Add(li);
		}
	}
	DataSet dat = new DataSet();
	try
	{
		dat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
	}
	try
	{
		if (dat.Tables[0].Rows.Count>0)
		{
			ShowTableData(cableBatch, dat);	
		}
	}
	catch (System.Exception ex)
	{
		cableBatch.Rows.Clear();
	}
}


protected void popSvrName(object sender, EventArgs e)
{
	string sql="", sql1="";
	System.Web.UI.WebControls.DropDownList caller = (System.Web.UI.WebControls.DropDownList)sender;
	string senderSrc=caller.ID.ToString();
	DataSet dat=new DataSet();
	DataSet dat1;
	string fetchedSvrRackspace=fix_txt(formHostnameDropDown.SelectedValue);
	string fetchedRack=fix_txt(formRackDropDown.SelectedValue);
	string fetchedBc=fix_txt(formBcDropDown.SelectedValue);
	string fetchedSlot=fix_txt(formSlotDropDown.SelectedValue);
	string srcRackspace="";
	string fetchedServerName="";
	string prefix="";

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	switch (senderSrc)
	{
		case "formSlotDropDown":
			formHostnameDropDown.Items.Clear();
			formHostnameDropDown.Attributes.Remove("disabled");
			sql="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+fetchedRack+"' AND bc='"+fetchedBc+"' AND slot='"+fetchedSlot+"'";
			if (fetchedBc=="NA")
			{
				sql="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+fetchedRack+"' AND slot='"+fetchedSlot+"'";
			}
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				srcRackspace=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
			}
			sql1="SELECT * FROM (SELECT serverName FROM "+dcPrefix+"servers WHERE rackspaceId="+srcRackspace+") AS a WHERE serverName LIKE 'S%'";
			dat=readDb(sql1);
			if (!emptyDataset(dat))
			{
				fetchedServerName=dat.Tables[0].Rows[0]["serverName"].ToString();
			}
			if (fetchedServerName!="")
			{
				formHostnameDropDown.Items.Add(new ListItem(fetchedServerName,fetchedServerName));
			}
			formHostnameDropDown.Attributes.Add("disabled","true");
			break;
		case "formHostnameDropDown":
			formRackDropDown.Items.Clear();
			formBcDropDown.Items.Clear();
			formSlotDropDown.Items.Clear();
			sql="SELECT rack, bc, slot FROM "+dcPrefix+"rackspace WHERE rackspaceId=(SELECT rackspaceId FROM "+dcPrefix+"servers WHERE servername='"+fetchedSvrRackspace+"')";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				sql="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
				dat1=readDb(sql);
				if (!emptyDataset(dat1))
				{
					formRackDropDown.Items.Add(new ListItem(dat1.Tables[0].Rows[0]["location"].ToString()+"-R"+dat1.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+dat1.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2), dat1.Tables[0].Rows[0]["rackId"].ToString()));
					formRackDropDown.Attributes.Add("disabled","true");
				}
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="")
				{
					prefix="U ";
				}
				formBcDropDown.Items.Add(new ListItem(dat.Tables[0].Rows[0]["bc"].ToString(), dat.Tables[0].Rows[0]["bc"].ToString()));
				formBcDropDown.Attributes.Add("disabled","true");

				formSlotDropDown.Items.Add(new ListItem(prefix+dat.Tables[0].Rows[0]["slot"].ToString(), dat.Tables[0].Rows[0]["slot"].ToString()));
				formSlotDropDown.Attributes.Add("disabled","true");
			}
			break;
	} // end switch;
	formSwitchDropDown.Items.Clear();
	sql="SELECT description, switchName FROM "+dcPrefix+"switches";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		formSwitchDropDown.Items.Add(new ListItem("...",""));
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li= new ListItem(dr["description"].ToString(), dr["switchName"].ToString());
			formSwitchDropDown.Items.Add(li);
		} 		
	}
	formVlanDropDown.Items.Clear();
	sql="SELECT vlanId, name FROM "+dcPrefix+"subnets ORDER BY vlanId ASC";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		formVlanDropDown.Items.Add(new ListItem("...",""));
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li= new ListItem(dr["vlanId"].ToString(), dr["name"].ToString());
			formVlanDropDown.Items.Add(li);
		} 		
	}
	DataSet tableDat = new DataSet();
	try
	{
		tableDat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
	}
	try
	{
		if (tableDat.Tables[0].Rows.Count>0)
		{
			ShowTableData(cableBatch, tableDat);	
		}
	}
	catch (System.Exception ex)
	{
		cableBatch.Rows.Clear();
	}
}

protected void popSwSlot(object sender, EventArgs e)
{
	string sql="";
	string fetchedSw=formSwitchDropDown.SelectedValue;
	string prefix="", statString="";
	DataSet dat=new DataSet();

	formSlotPortDropDown.Items.Clear();

	sql="SELECT * FROM "+fetchedSw+" WHERE cabledTo IS NULL AND comment IS NULL ORDER BY portId ASC";
//	statString=statString+"SlotSql:"+sql+"<BR/>";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		formSlotPortDropDown.Items.Add(new ListItem("...",""));
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem("Slot "+dr["slot"].ToString()+", Port "+dr["portNum"].ToString(), dr["portId"].ToString());
			formSlotPortDropDown.Items.Add(li);
		} 
	}
	DataSet tableDat= new DataSet();
	try
	{
		tableDat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
	}
	try
	{
		if (tableDat.Tables[0].Rows.Count>0)
		{
			ShowTableData(cableBatch, tableDat);	
		}
	}
	catch (System.Exception ex)
	{
		cableBatch.Rows.Clear();
	}
//	statusSpan.Text=statString;
}

protected void ResetForm(object sender, EventArgs e)
{
	string sql="";
	DataSet serversdd;
	formRackDropDown.SelectedIndex=0;
	formRackDropDown.Attributes.Remove("disabled");
	formBcDropDown.Items.Clear();
	formBcDropDown.Attributes.Remove("disabled");
	formSlotDropDown.Items.Clear();
	formSlotDropDown.Attributes.Remove("disabled");
	formHostnameDropDown.Items.Clear();
	formHostnameDropDown.Attributes.Remove("disabled");
	
	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	sql="SELECT * FROM (SELECT serverName, rackspaceId FROM "+dcPrefix+"servers WHERE rackspaceId IN(SELECT DISTINCT(rackspaceId) FROM "+dcPrefix+"servers) AS a) AS b WHERE serverName LIKE 'S%' AND serverName NOT LIKE '%VIP' AND servername NOT LIKE 'SB%VMK%' ORDER BY serverName";
	serversdd=readDb(sql);
	if (serversdd!=null)
	{
		formHostnameDropDown.Items.Add(new ListItem("...",""));
		foreach(DataRow dr in serversdd.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["serverName"].ToString(), dr["rackspaceId"].ToString());
			formHostnameDropDown.Items.Add(li);
		}
	}
	formNicTextBox.Text="eth?";
	formServerPatchTextBox.Text="ex:CRNT-R#-C#(P#/#) SV";
	formSwitchPatchTextBox.Text="ex:CRNT-R#-C#(P#/#) SW";
	formSwitchDropDown.Items.Clear();
	formSwitchDropDown.Attributes.Remove("disabled");
	formSlotPortDropDown.Items.Clear();
	formSlotPortDropDown.Attributes.Remove("disabled");
	formVlanDropDown.Items.Clear();
	formVlanDropDown.Attributes.Remove("disabled");
	DataSet tableDat= new DataSet();
	try
	{
		tableDat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
	}
	try
	{
		if (tableDat.Tables[0].Rows.Count>0)
		{
			ShowTableData(cableBatch, tableDat);	
		}
	}
	catch (System.Exception ex)
	{
		cableBatch.Rows.Clear();
	}
}

protected void ShowTableTitles(Table showTable)
{
	TableRow titleRow = new TableRow();
		titleRow.BorderColor=System.Drawing.ColorTranslator.FromHtml("#000000");
		titleRow.BackColor=System.Drawing.ColorTranslator.FromHtml("#336633");
		titleRow.ForeColor=System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
		titleRow.Font.Bold=true;
		titleRow.HorizontalAlign=HorizontalAlign.Center;
		TableCell indexTitle = new TableCell();
			indexTitle.Text="Index";
		titleRow.Cells.Add(indexTitle);
		TableCell rackTitle = new TableCell();
			rackTitle.Text="Rack";
		titleRow.Cells.Add(rackTitle);
		TableCell bcTitle = new TableCell();
			bcTitle.Text="BC";
		titleRow.Cells.Add(bcTitle);
		TableCell slotTitle = new TableCell();
			slotTitle.Text="Slot";
		titleRow.Cells.Add(slotTitle);
		TableCell serverTitle = new TableCell();
			serverTitle.Text="Server";
		titleRow.Cells.Add(serverTitle);
		TableCell nicTitle = new TableCell();
			nicTitle.Text="NIC";
		titleRow.Cells.Add(nicTitle);
		TableCell svrPatchTitle = new TableCell();
			svrPatchTitle.Text="Server Patch";
		titleRow.Cells.Add(svrPatchTitle);
		TableCell swPatchTitle = new TableCell();
			swPatchTitle.Text="Switch Patch";
		titleRow.Cells.Add(swPatchTitle);
		TableCell switchTitle = new TableCell();
			switchTitle.Text="Switch";
		titleRow.Cells.Add(switchTitle);
		TableCell switchSlotPortTitle = new TableCell();
			switchSlotPortTitle.Text="Slot &amp; Port";
		titleRow.Cells.Add(switchSlotPortTitle);
		TableCell switchPortVlanTitle = new TableCell();
			switchPortVlanTitle.Text="Port VLAN";
		titleRow.Cells.Add(switchPortVlanTitle);
		TableCell actionsTitle = new TableCell();
			actionsTitle.Text="Actions";
		titleRow.Cells.Add(actionsTitle);
	showTable.Rows.Add(titleRow);
}

protected void ShowTableData(Table showTable, DataSet dat)
{
	int index=0;
	bool fill=false;
	showTable.Rows.Clear();

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	showTable.BorderColor=System.Drawing.ColorTranslator.FromHtml("#000000");
	ShowTableTitles(showTable);
	if (!emptyDataset(dat))
	{
		index=dat.Tables[0].Rows.Count;
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				TableRow dataRow = new TableRow();
					if (fill)
					{
						dataRow.BackColor=System.Drawing.ColorTranslator.FromHtml("#edf0f3");
					}
					dataRow.BorderColor=System.Drawing.ColorTranslator.FromHtml("#000000");
					dataRow.HorizontalAlign=HorizontalAlign.Center;
					TableCell indexTitle = new TableCell();
						indexTitle.Text=dr["Index"].ToString();
					dataRow.Cells.Add(indexTitle);
					TableCell rackTitle = new TableCell();
						rackTitle.Text=dr["Rack"].ToString();
					dataRow.Cells.Add(rackTitle);
					TableCell bcTitle = new TableCell();
						bcTitle.Text=dr["BC"].ToString();
					dataRow.Cells.Add(bcTitle);
					TableCell slotTitle = new TableCell();
						slotTitle.Text=dr["Slot"].ToString();
					dataRow.Cells.Add(slotTitle);
					TableCell serverTitle = new TableCell();
						serverTitle.Text=dr["ServerName"].ToString();
					dataRow.Cells.Add(serverTitle);
					TableCell nicTitle = new TableCell();
						nicTitle.Text=dr["NIC"].ToString();
					dataRow.Cells.Add(nicTitle);
					TableCell svrPatchTitle = new TableCell();
						svrPatchTitle.Text=dr["ServerPatch"].ToString();
					dataRow.Cells.Add(svrPatchTitle);
					TableCell swPatchTitle = new TableCell();
						swPatchTitle.Text=dr["SwitchPatch"].ToString();
					dataRow.Cells.Add(swPatchTitle);
					TableCell switchTitle = new TableCell();
						switchTitle.Text=dr["Switch"].ToString();
					dataRow.Cells.Add(switchTitle);
					TableCell switchSlotPortTitle = new TableCell();
						switchSlotPortTitle.Text=dr["SwitchSlotPort"].ToString();
					dataRow.Cells.Add(switchSlotPortTitle);
					TableCell switchPortVlanTitle = new TableCell();
						switchPortVlanTitle.Text=dr["SwitchPortVlan"].ToString();
					dataRow.Cells.Add(switchPortVlanTitle);
				showTable.Rows.Add(dataRow);
				fill=!fill;
				index++;
			}
		}
	}
}

protected void AddButton_Click(object sender, EventArgs e)
{
	string sql;
	DataSet dat=new DataSet();
	DataSet cableBatchDat=new DataSet();
	int batchCount=0;
	string formRackId="";
	string formRackName="";
	string formBc="";
	string formSlot="";
	string formServer="";
	string formNic="";
	string formServerPatch="";
	string formSwitchPatch="";
	string formSwitchId="";
	string formSwitchName="";
	string formSwitchSlotPort="";
	string formVlan="";
	string formSwitchSlotPortId="";
	string formVlanId="";
	string formRackspace="";
	string errorStatus="";
	string statString="";

	string dcPrefix="";
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
		cableBatchDat.Merge(Session["bulkCables"] as DataSet); //Fetch dataset contents from SessionState;
	}
	catch (System.Exception ex)
	{
		statString=statString+"Building new Cable Batch....<BR/>";
		DataTable cableTable = cableBatchDat.Tables.Add("CableBatch");	
		DataColumn cableColumns =
			cableTable.Columns.Add("Index", typeof(Int32));
			cableTable.Columns.Add("RackspaceId", typeof(string));
			cableTable.Columns.Add("RackId", typeof(string));
//			cableTable.Columns["RackId"].Visible=false;
			cableTable.Columns.Add("Rack", typeof(string));
			cableTable.Columns.Add("BC", typeof(string));
			cableTable.Columns.Add("Slot", typeof(string));
			cableTable.Columns.Add("ServerName", typeof(string));
			cableTable.Columns.Add("NIC", typeof(string));
			cableTable.Columns.Add("ServerPatch", typeof(string));
			cableTable.Columns.Add("SwitchPatch", typeof(string));
			cableTable.Columns.Add("SwitchId", typeof(string));
//			cableTable.Columns["SwitchId"].Visible=false;
			cableTable.Columns.Add("Switch", typeof(string));
			cableTable.Columns.Add("SwitchSlotPortId", typeof(string));
			cableTable.Columns.Add("SwitchSlotPort", typeof(string));
			cableTable.Columns.Add("SwitchPortVlanId", typeof(string));
			cableTable.Columns.Add("SwitchPortVlan", typeof(string));
			cableTable.PrimaryKey = new DataColumn[] { cableColumns };
	}

	try
	{
		batchCount=cableBatchDat.Tables[0].Rows.Count;
	}
	catch (System.Exception ex)
	{
		batchCount=0;
	}

	formRackId=formRackDropDown.SelectedValue;
	formBc=formBcDropDown.SelectedValue;
	formSlot=formSlotDropDown.SelectedValue;
	formServer=formHostnameDropDown.SelectedValue;
	formNic=formNicTextBox.Text;
	formServerPatch=formServerPatchTextBox.Text;
	formSwitchPatch=formSwitchPatchTextBox.Text;
	formSwitchId=formSwitchDropDown.SelectedValue;
	formSwitchSlotPortId=formSlotPortDropDown.SelectedValue;
	formVlanId=formVlanDropDown.SelectedValue;
	bool badServerPatch=false;
	bool badSwitchPatch=false;
	bool goodData=false;

	if (formRackId!="")
	{
		sql="SELECT location FROM "+dcPrefix+"racks WHERE rackId='"+formRackId+"'";
		dat=readDb(sql);
//		statString=statString+"RackSql:"+sql+"<BR/>";
		if (!emptyDataset(dat))
		{
			formRackName=dat.Tables[0].Rows[0]["location"].ToString()+"-R"+formRackId.Substring(0,2)+"-C"+formRackId.Substring(2,2);
		}
		else formRackName="";
	}

	if (formSwitchId!="")
	{
		sql="SELECT description FROM "+dcPrefix+"switches WHERE switchName='"+formSwitchId+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			formSwitchName=dat.Tables[0].Rows[0]["description"].ToString();
		}
		else formSwitchName="";
	}

	if (formSwitchSlotPortId!="" && formSwitchId!="")
	{
		sql="SELECT slot, portNum FROM "+formSwitchId+" WHERE portId="+formSwitchSlotPortId;
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			formSwitchSlotPort="Slot "+dat.Tables[0].Rows[0]["slot"].ToString()+", Port "+dat.Tables[0].Rows[0]["portNum"].ToString();
		}
		else formSwitchSlotPort="";
	}

	if (formVlanId!="")
	{
		sql="SELECT desc FROM "+dcPrefix+"subnets WHERE name='"+formVlanId+"'";
//		statusSpan.Text=sql;
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			formVlan=dat.Tables[0].Rows[0]["desc"].ToString();
		}
		else formVlanId="";
	}

	if (formNic=="eth?" || formNic=="")
	{
		formNic="";
		errorStatus=errorStatus+"ERROR: Invalid NIC Indentifier  Please enter a valid NIC name.<BR/>";
	} 

	if (formServerPatch.Contains("#"))
	{
		badServerPatch=true;
	}
	if (formServerPatch.StartsWith("ex:"))
	{
		badServerPatch=true;
	}

	if (formSwitchPatch.Contains("#"))
	{
		badSwitchPatch=true;
	}
	if (formSwitchPatch.StartsWith("ex:"))
	{
		badSwitchPatch=true;	
	} 

	if (badServerPatch)
	{
		errorStatus=errorStatus+"ERROR: '"+formServerPatch+"' is not valid switch-side patch info.  Please enter valid patching data (or leave it blank).<BR/>";
		formServerPatch="";
	}

	if (badSwitchPatch)
	{
		errorStatus=errorStatus+"ERROR: '"+formSwitchPatch+"' is not valid switch-side patch info.  Please enter valid patching data (or leave it blank).<BR/>";
		formSwitchPatch="";
	}

	sql="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+formRackId+"' AND bc='"+formBc+"' AND slot='"+formSlot+"'";
	if (formBc=="NA")
	{
		sql="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+formRackId+"' AND slot='"+formSlot+"'";
	}
	if (formServer!="")
	{
		sql="SELECT rackspaceId FROM "+dcPrefix+"servers WHERE serverName='"+formServer+"'";
	}

	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		formRackspace=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
	}

	if (formRackspace=="")
	{
		errorStatus=errorStatus+"ERROR: Couldn't find hardware(rackspaceId) to cable!<BR/>";
	}

	if (cableBatchDat==null)
	{
		statString="Dataset is null!<BR/>";
		try
		{
			DataTable cableTable = cableBatchDat.Tables.Add("CableBatch");	
		}
		catch (System.Exception ex)
		{
			if (errorStatus=="")
			{
				statString=statString+"Couldn't add new empty Table to DataSet.<SPAN class='italic'>'"+ex.ToString()+"</SPAN>'<BR/>";
			}
		}
	}

	try
	{
		if (cableBatchDat.Tables.Count==0)
		{
		}
	}
	catch (System.Exception ex)
	{
		if (errorStatus=="")
		{
			statString=statString+"Couldn't get tables from batch dataset...<BR/>";
		}
	}

	if (errorStatus=="")
	{
		DataRow newCable = cableBatchDat.Tables[0].NewRow();
		newCable["Index"] = batchCount;
		newCable["RackspaceId"] = formRackspace;
		newCable["RackId"] = formRackId;
		newCable["Rack"] = formRackName;
		newCable["BC"] = formBc;
		newCable["Slot"] = formSlot;
		newCable["ServerName"] = formServer;
		newCable["NIC"] = formNic;
		newCable["ServerPatch"] = formServerPatch;
		newCable["SwitchPatch"] = formSwitchPatch;
		newCable["SwitchId"] = formSwitchId;
		newCable["Switch"] = formSwitchName;
		newCable["SwitchSlotPort"] = formSwitchSlotPort;
		newCable["SwitchSlotPortId"] = formSwitchSlotPortId;
		newCable["SwitchPortVlan"] = formVlan;
		newCable["SwitchPortVlanId"] = formVlanId;
		cableBatchDat.Tables[0].Rows.Add(newCable);
	}
	else
	{
		errorStatus=errorStatus+"Error adding data to batch datatset";
	} 

	batchCount++;

	if (errorStatus=="")
	{
		try
		{
			Session["bulkCables"]=cableBatchDat; //Store dataset contents in SessionState	
		}
		catch (System.Exception ex)
		{
			errorStatus=errorStatus+"Error updating 'bulkCables' in Session state.<BR/>";
		}

		try
		{
			Session["bulkCablesBatchCount"]=batchCount;
		}
		catch (System.Exception ex)
		{
			errorStatus=errorStatus+"Error updating 'bulkCables' in Session state.<BR/>";
		}
		
		try  //fill the table
		{
			ShowTableData(cableBatch, cableBatchDat);
		}
		catch (System.Exception ex)
		{
			errorStatus=errorStatus+"Error updating view of cableBatch. - "+ex.ToString()+"<BR/>";
		}
	}
	else
	{
		errorStatus=errorStatus+"";
	}

	// Everything Worked!
	if (errorStatus=="")
	{
		ResetForm(sender,e);
	}
		
	statusSpan.Text=statString;
	errorSpan.Text=errorStatus;
}

protected void EditBatch_Click(object sender, EventArgs e)
{
}

protected void ResetBatch_Click(object sender, EventArgs e)
{
	cableBatch.Rows.Clear();
	Session.Remove("bulkCables");
	Session.Remove("bulkCablesBatchCount");
}

protected void CommitBatch_Click(object sender, EventArgs e)
{
	string v_username="";
	string statString="",errString="", patchString="", sql="", sqlErr="";
	DateTime dateStamp = DateTime.Now;
	DataSet dat = new DataSet();

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
		dat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
	}
	if (!emptyDataset(dat))
	{
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				if (dr["ServerPatch"].ToString()!="" || dr["SwitchPatch"].ToString()!="")
				{
					patchString="PATCH CABLING - ";
				}
				if (dr["ServerPatch"].ToString()!="")
				{
					patchString=patchString+"Server-side Patch:"+dr["ServerPatch"].ToString()+", ";
				}
				if (dr["SwitchPatch"].ToString()!="")
				{
					patchString=patchString+"Switch-side Patch:"+dr["SwitchPatch"].ToString()+", ";
				}

				sql="UPDATE "+dr["SwitchId"].ToString()+" SET cabledTo="+dr["RackspaceId"].ToString()+", comment='"+dr["NIC"].ToString()+"', patchCable='"+patchString+"VLAN:"+dr["SwitchPortVlan"].ToString()+"' WHERE portId="+dr["SwitchSlotPortId"].ToString()+"";
//				statString=statString+sql+"<BR/>";
				sqlErr=writeDb(sql);
				if (sqlErr!="")
				{
					errString=errString+"ERROR:"+sqlErr+"<BR/>";
				}
				statString=statString+"CABLE:"+sql+"<BR/>";
				patchString="";
			}
		} 
		if (errString!="")
		{
			errorSpan.Text=errString;
			statusSpan.Text=statString;
		}
		else
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), statString);
			if (sqlErr=="")
			{
				errorSpan.Text="";
				statusSpan.Text="Batch SUCCESSFULLY Commited to Database!";
				ResetBatch_Click(sender,e);
			}
			else
			{
				errorSpan.Text=sqlErr;
			}
		}
	}
}

protected void rowCommand(object sender, GridViewCommandEventArgs e)
{
	DataSet dat = new DataSet();
	try
	{
		dat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
//		statusSpan.Text="Couldn't fetch current batch.";
	}
	ShowTableData(cableBatch, dat);
	Session["bulkCables"]=dat;
}

protected void rowDeletedCommand(object sender, GridViewDeletedEventArgs e)
{
	DataSet dat = new DataSet();
	try
	{
		dat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
//		statusSpan.Text="Couldn't fetch current batch.";
	}
	ShowTableData(cableBatch, dat);
	Session["bulkCables"]=dat;
}

protected void rowDeleteCommand(object sender, ImageClickEventArgs e)
{
	statusSpan.Text="Fired ....";
/*	DataSet dat = new DataSet();
	string statusStr="";
	System.Web.UI.WebControls.ImageButton caller = (System.Web.UI.WebControls.ImageButton)sender;
	string senderSrc=caller.ID.ToString();
	string index=senderSrc.Trim().Replace("deleteButton","");
	statusStr=senderSrc+","+index+",";
	try
	{
		dat.Merge(Session["bulkCables"] as DataSet);
	}
	catch (System.Exception ex)
	{
		statusStr=statusStr+"Couldn't fetch current batch.";
		statusSpan.Text=statusStr;
	}
	try
	{
		dat.Tables[0].Rows[Convert.ToInt32(index)].Delete();
	}
	catch (System.Exception ex)
	{
		statusStr=statusStr+"Couldn't delete row "+index;
		statusSpan.Text=statusStr;
	}
	statusSpan.Text=statusStr;
	Session["bulkCables"]=dat;
	ShowTableData(cableBatch, dat); */
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); 
	Page.Header.Title=shortSysName+": Bulk-Add Network Cabling";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
//	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", status="";
	DataSet dat = new DataSet();
	DataSet racksdd = new DataSet();
	DataSet serversdd=new DataSet();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	titleSpan.InnerHtml="Bulk-Add Network Cabling";

	sql= "";
//	dat=readDb(sql);

	sql="SELECT location, rackId FROM "+dcPrefix+"racks ORDER BY rackId ASC";
	racksdd=readDb(sql);
	if (racksdd!=null)
	{
		foreach(DataRow dr in racksdd.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["location"].ToString()+"-R"+dr["rackId"].ToString().Substring(0,2)+"-C"+dr["rackId"].ToString().Substring(2,2), dr["rackId"].ToString());
			formRackDropDown.Items.Add(li);
		}
	}

	sql="SELECT * FROM (SELECT serverName, rackspaceId FROM "+dcPrefix+"servers WHERE rackspaceId IN(SELECT DISTINCT(rackspaceId) FROM "+dcPrefix+"servers)) AS a WHERE serverName LIKE 'S%' AND serverName NOT LIKE '%VIP' AND servername NOT LIKE 'SB%VMK%' ORDER BY serverName";
	serversdd=readDb(sql);
	if (serversdd!=null)
	{
		formHostnameDropDown.Items.Add(new ListItem("...",""));
		foreach(DataRow dr in serversdd.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["serverName"].ToString(), dr["rackspaceId"].ToString());
			formHostnameDropDown.Items.Add(li);
		}
	}

	if (IsPostBack)
	{

	}

	if (!IsPostBack)
	{
		cableBatch.Rows.Clear();
		Session.Remove("bulkCables");
		Session.Remove("bulkCablesBatchCount");
	}
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV class='center'>
				<DIV id='errmsg' class='errorLine' runat='server'/>
			</DIV>
		</DIV>
		<DIV class='center paleColorFill'>
			&#xa0;<BR/>
			<FORM id='form1' runat='server'>
			<DIV class='center'>
				<DIV>
					<ASP:ScriptManager ID='ScriptManager1' runat='server' />
					<BR/>
					<ASP:UpdateProgress ID='UpdateProgress1' runat='server'>
						<ProgressTemplate>
							Loading ...
						</ProgressTemplate>
					</ASP:UpdateProgress>
					<BR/>
					<ASP:UpdatePanel runat='server' id='serverChoicePanel' UpdateMode='Conditional'>
						<ContentTemplate>
							<ASP:Table border='1' class='datatable center' runat='server'>
								<ASP:TableRow>
									<ASP:TableCell colspan='6' class='center inputform' text='Server'/>
									<ASP:TableCell colspan='2' class='center inputform' text='Patching'/>
									<ASP:TableCell colspan='3' class='center inputform' text='Switch'/>
									<ASP:TableCell class='center inputform' text='&#xa0;'/>
								</ASP:TableRow>
								<ASP:TableRow>
									<ASP:TableCell class='center inputform' text='Rack'/>
									<ASP:TableCell class='center inputform' text='BC'/>
									<ASP:TableCell class='center inputform' text='Slot'/>
									<ASP:TableCell class='center inputform' text='&#xa0;'/>
									<ASP:TableCell class='center inputform' text='Hostname'/>
									<ASP:TableCell class='center inputform' text='NIC'/>
									<ASP:TableCell class='center inputform' text='Server Patch'/>
									<ASP:TableCell class='center inputform' text='Switch Patch'/>
									<ASP:TableCell class='center inputform' text='Switch'/>
									<ASP:TableCell class='center inputform' text='Slot/Port'/>
									<ASP:TableCell class='center inputform' text='VLAN'/>
									<ASP:TableCell class='center inputform' text='&#xa0;'/>
								</ASP:TableRow>
								<ASP:TableRow>
									<ASP:TableCell>
										<ASP:DropDownList ID='formRackDropDown' runat='server' AutoPostBack='True' OnSelectedIndexChanged='popSvrBc'/>
										<BR/>
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:DropDownList ID='formBcDropDown' runat='server' AutoPostBack='True' OnSelectedIndexChanged='popSvrSlot'>
											<ASP:ListItem Text='...' Value=''/>
										</ASP:DropDownList>
									<BR/>
									</ASP:TableCell>
									<ASP:TableCell>	
										<ASP:DropDownList ID='formSlotDropDown' runat='server' AutoPostBack='True' OnSelectedIndexChanged='popSvrName'>
											<ASP:ListItem Text='...' Value=''/>
										</ASP:DropDownList>
										<BR/>
									</ASP:TableCell>
									<ASP:TableCell text='-or-'/>
									<ASP:TableCell>
										<ASP:DropDownList ID='formHostnameDropDown' runat='server' AutoPostBack='True' OnSelectedIndexChanged='popSvrName'/>
										<BR/>
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:TextBox text='eth?' id='formNicTextBox' size='5' maxlength='5' runat='server' />
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:TextBox text='ex:CRNT-R#-C#(P#/#) SV' id='formServerPatchTextBox' size='25' maxlength='25' runat='server' />
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:TextBox text='ex:CRNT-R#-C#(P#/#) SW' id='formSwitchPatchTextBox' size='25' maxlength='25' runat='server' />
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:DropDownList ID='formSwitchDropDown' runat='server' AutoPostBack='True' OnSelectedIndexChanged='popSwSlot'/>
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:DropDownList id='formSlotPortDropDown' runat='server' />
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:DropDownList id='formVlanDropDown' runat='server' />
									</ASP:TableCell>
									<ASP:TableCell>
										<ASP:Button runat='server' id='AddButton' onclick='AddButton_Click' text='Add' />
										<BR/>
										<ASP:Button runat='server' id='ResetButton' onclick='ResetForm' text='Clear' /> 		
									</ASP:TableCell>
								</ASP:TableRow>
							</ASP:Table>
							<BR/>
							<ASP:Label runat='server' forecolor='Red' id='errorSpan'/>
							<BR/>
							<ASP:Label runat='server' id='statusSpan'/>
							<BR/><BR/>
							<ASP:Table id='cableBatch' runat='server' class='datatable' BackColor='White' BorderWidth='2px' />
							<BR/><BR/><BR/><BR/>
							<ASP:datagrid id='commitGrid' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
								<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
								<AlternatingItemStyle BackColor='#edf0f3' />
							</ASP:datagrid>
							<ASP:Button runat='server' id='ResetBatch' onclick='ResetBatch_Click' text='Empty Batch' />
							<ASP:Button ID='printButton' runat='server' Text='Print' OnClientClick='javascript:window.print();' />
							<ASP:Button runat='server' id='CommitBatch' onclick='CommitBatch_Click' text='Save' />
						</ContentTemplate>
					</ASP:UpdatePanel>
				</DIV>
			</DIV>
			</FORM>
			&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
</DIV> <!-- End: container -->
</BODY>
</HTML>