<%@Page Inherits="ESMS.esmsLibrary" src="../esmsLibrary.cs" Language="C#" debug="true" %>
<%@Register TagPrefix="Chart" TagName="ReportPieChart" Src="./ReportPieChart.ascx" %>
<%@Import namespace="System.Drawing" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<HTML>
<LINK REL="SHORTCUT ICON" HREF="../img/favicon.ico" />

<TITLE>ESMS: Report</TITLE>
<META NAME="description" CONTENT=""></META>
<META NAME="keywords" CONTENT=""></META>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="Chris Knight">
<!--#include file="./reportStyles.inc" -->

<HEAD>
<SCRIPT runat="server">
void goVirtDetail(Object sender, EventArgs e)
{
	HtmlButton clickedButton = sender as HtmlButton;
	string fromId=clickedButton.ID.ToString();
	Response.Write("<script language='javascript'>window.open('vmDatastoreDetail_report.aspx?cluster="+fromId.Substring(fromId.IndexOf("_")+1,fromId.Length-fromId.IndexOf("_")-1)+"','datastoreDetailWin','width=600,height=800,menubar=no,status=yes,scrollbars=yes')"+";<"+"/script>");
}

void doCharts(string[,] chartData)
{
	string deco="";

//--- First Chart
	int vmTot_0=1;
	int vmSnaps_0=1;
	int vmNoSnaps_0=1;
	if (Convert.ToInt32(chartData[0,2])>0)
	{
		vmTot_0=Convert.ToInt32(chartData[0,2]);
	}
	if (Convert.ToInt32(chartData[0,3])>0)
	{
		vmSnaps_0=Convert.ToInt32(chartData[0,3]);
	}
	vmNoSnaps_0=vmTot_0-vmSnaps_0;
	double VirtDetailPieChart_0_element1Value, VirtDetailPieChart_0_element2Value;

	VirtDetailPieChart_0_element1Value=Math.Round((((double)vmSnaps_0/vmTot_0)*100),1);
	VirtDetailPieChart_0_element2Value=Math.Round((((double)vmNoSnaps_0/vmTot_0)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_0_Element1.Name = "Free";
	VirtDetailPieChart_0_Element1.Percent = VirtDetailPieChart_0_element1Value;
	VirtDetailPieChart_0_Element1.Color = Color.DarkOrange;
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element1);

	VirtDetailPieChart_0_Element2.Name = "Used";
	VirtDetailPieChart_0_Element2.Percent = VirtDetailPieChart_0_element2Value;
	VirtDetailPieChart_0_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#FFCC99");
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element2);

  	VirtDetailPieChart_0.ChartTitle = "Datastores: "+chartData[0,1];
	VirtDetailPieChart_0.ImageAlt = "Datastores: "+chartData[0,1];
	VirtDetailPieChart_0.ImageWidth = 225;
	VirtDetailPieChart_0.ImageHeight = 132;

	VirtDetailPieChart_0.generateChartImage();

	if (Math.Round((((double)vmSnaps_0/vmTot_0)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_0.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[0,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[0,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[0,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_0/vmTot_0)*100),1).ToString()+"</FONT>";
/*


//--- Second Chart
	int vmTot_1=1;
	int vmSnaps_1=1;
	int vmNoSnaps_1=1;
	if (Convert.ToInt32(chartData[1,2])>0)
	{
		vmTot_1=Convert.ToInt32(chartData[1,2]);
	}
	if (Convert.ToInt32(chartData[1,3])>0)
	{
		vmSnaps_1=Convert.ToInt32(chartData[1,3]);
	}
	vmNoSnaps_1=vmTot_1-vmSnaps_1;
	double VirtDetailPieChart_1_element1Value, VirtDetailPieChart_1_element2Value;

	VirtDetailPieChart_1_element1Value=Math.Round((((double)vmSnaps_1/vmTot_1)*100),1);
	VirtDetailPieChart_1_element2Value=Math.Round((((double)vmNoSnaps_1/vmTot_1)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_1_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_1_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_1_Element1.Name = "Free";
	VirtDetailPieChart_1_Element1.Percent = VirtDetailPieChart_1_element1Value;
	VirtDetailPieChart_1_Element1.Color = Color.DarkGreen;
	VirtDetailPieChart_1.addPieChartElement(VirtDetailPieChart_1_Element1);

	VirtDetailPieChart_1_Element2.Name = "Used";
	VirtDetailPieChart_1_Element2.Percent = VirtDetailPieChart_1_element2Value;
	VirtDetailPieChart_1_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#A4C9A4");
	VirtDetailPieChart_1.addPieChartElement(VirtDetailPieChart_1_Element2);
      
	VirtDetailPieChart_1.ChartTitle = "Datastores: "+chartData[1,1];
	VirtDetailPieChart_1.ImageAlt = "Datastores: "+chartData[1,1];
	VirtDetailPieChart_1.ImageWidth = 225;
	VirtDetailPieChart_1.ImageHeight = 132;

	VirtDetailPieChart_1.generateChartImage();

	if (Math.Round((((double)vmSnaps_1/vmTot_1)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_1.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[1,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[1,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[1,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_1/vmTot_1)*100),1).ToString()+"</FONT>";

//--- Third Chart
	int vmTot_2=1;
	int vmSnaps_2=1;
	int vmNoSnaps_2=1;
	if (Convert.ToInt32(chartData[2,2])>0)
	{
		vmTot_2=Convert.ToInt32(chartData[2,2]);
	}
	if (Convert.ToInt32(chartData[2,3])>0)
	{
		vmSnaps_2=Convert.ToInt32(chartData[2,3]);
	}
	vmNoSnaps_2=vmTot_2-vmSnaps_2;
	double VirtDetailPieChart_2_element1Value, VirtDetailPieChart_2_element2Value;

	VirtDetailPieChart_2_element1Value=Math.Round((((double)vmSnaps_2/vmTot_2)*100),1);
	VirtDetailPieChart_2_element2Value=Math.Round((((double)vmNoSnaps_2/vmTot_2)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_2_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_2_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_2_Element1.Name = "Free";
	VirtDetailPieChart_2_Element1.Percent = VirtDetailPieChart_2_element1Value;
	VirtDetailPieChart_2_Element1.Color = Color.DodgerBlue;
	VirtDetailPieChart_2.addPieChartElement(VirtDetailPieChart_2_Element1);

	VirtDetailPieChart_2_Element2.Name = "Used";
	VirtDetailPieChart_2_Element2.Percent = VirtDetailPieChart_2_element2Value;
	VirtDetailPieChart_2_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#A3D2FF");
	VirtDetailPieChart_2.addPieChartElement(VirtDetailPieChart_2_Element2);
        
	VirtDetailPieChart_2.ChartTitle = "Datastores: "+chartData[2,1];
	VirtDetailPieChart_2.ImageAlt = "Datastores: "+chartData[2,1];
	VirtDetailPieChart_2.ImageWidth = 225;
	VirtDetailPieChart_2.ImageHeight = 132;

	VirtDetailPieChart_2.generateChartImage();

	if (Math.Round((((double)vmSnaps_2/vmTot_2)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_2.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[2,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[2,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[2,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_2/vmTot_2)*100),1).ToString()+"</FONT>";

//--- Fourth Chart
	int vmTot_3=1;
	int vmSnaps_3=1;
	int vmNoSnaps_3=1;
	if (Convert.ToInt32(chartData[3,2])>0)
	{
		vmTot_3=Convert.ToInt32(chartData[3,2]);
	}
	if (Convert.ToInt32(chartData[3,3])>0)
	{
		vmSnaps_3=Convert.ToInt32(chartData[3,3]);
	}
	vmNoSnaps_3=vmTot_3-vmSnaps_3;
	double VirtDetailPieChart_3_element1Value, VirtDetailPieChart_3_element2Value;

	VirtDetailPieChart_3_element1Value=Math.Round((((double)vmSnaps_3/vmTot_3)*100),1);
	VirtDetailPieChart_3_element2Value=Math.Round((((double)vmNoSnaps_3/vmTot_3)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_3_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_3_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_3_Element1.Name = "Free";
	VirtDetailPieChart_3_Element1.Percent = VirtDetailPieChart_3_element1Value;
	VirtDetailPieChart_3_Element1.Color = Color.Crimson;
	VirtDetailPieChart_3.addPieChartElement(VirtDetailPieChart_3_Element1);

	VirtDetailPieChart_3_Element2.Name = "Used";
	VirtDetailPieChart_3_Element2.Percent = VirtDetailPieChart_3_element2Value;
	VirtDetailPieChart_3_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#F69DAF");
	VirtDetailPieChart_3.addPieChartElement(VirtDetailPieChart_3_Element2);
        
	VirtDetailPieChart_3.ChartTitle = "Datastores: "+chartData[3,1];
	VirtDetailPieChart_3.ImageAlt = "Datastores: "+chartData[3,1];
	VirtDetailPieChart_3.ImageWidth = 225;
	VirtDetailPieChart_3.ImageHeight = 132;

	VirtDetailPieChart_3.generateChartImage();

	if (Math.Round((((double)vmSnaps_3/vmTot_3)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_3.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[3,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[3,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[3,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_3/vmTot_3)*100),1).ToString()+"</FONT>";

//--- Fifth Chart
	int vmTot_4=1;
	int vmSnaps_4=1;
	int vmNoSnaps_4=1;
	if (Convert.ToInt32(chartData[4,2])>0)
	{
		vmTot_4=Convert.ToInt32(chartData[4,2]);
	}
	if (Convert.ToInt32(chartData[4,3])>0)
	{
		vmSnaps_4=Convert.ToInt32(chartData[4,3]);
	}
	vmNoSnaps_4=vmTot_4-vmSnaps_4;
	double VirtDetailPieChart_4_element1Value, VirtDetailPieChart_4_element2Value;

	VirtDetailPieChart_4_element1Value=Math.Round((((double)vmSnaps_4/vmTot_4)*100),1);
	VirtDetailPieChart_4_element2Value=Math.Round((((double)vmNoSnaps_4/vmTot_4)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_4_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_4_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_4_Element1.Name = "Free";
	VirtDetailPieChart_4_Element1.Percent = VirtDetailPieChart_4_element1Value;
	VirtDetailPieChart_4_Element1.Color = Color.SaddleBrown;
	VirtDetailPieChart_4.addPieChartElement(VirtDetailPieChart_4_Element1);

	VirtDetailPieChart_4_Element2.Name = "Used";
	VirtDetailPieChart_4_Element2.Percent = VirtDetailPieChart_4_element2Value;
	VirtDetailPieChart_4_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#EFB389");
	VirtDetailPieChart_4.addPieChartElement(VirtDetailPieChart_4_Element2);
       
	VirtDetailPieChart_4.ChartTitle = "Datastores: "+chartData[4,1];
	VirtDetailPieChart_4.ImageAlt = "Datastores: "+chartData[4,1];
	VirtDetailPieChart_4.ImageWidth = 225;
	VirtDetailPieChart_4.ImageHeight = 132;

	VirtDetailPieChart_4.generateChartImage();

	if (Math.Round((((double)vmSnaps_4/vmTot_4)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_4.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[4,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[4,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[4,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_4/vmTot_4)*100),1).ToString()+"</FONT>";

//--- Sixth Chart
	int vmTot_5=1;
	int vmSnaps_5=1;
	int vmNoSnaps_5=1;
	if (Convert.ToInt32(chartData[5,2])>0)
	{
		vmTot_5=Convert.ToInt32(chartData[5,2]);
	}
	if (Convert.ToInt32(chartData[5,3])>0)
	{
		vmSnaps_5=Convert.ToInt32(chartData[5,3]);
	}
	vmNoSnaps_5=vmTot_5-vmSnaps_5;
	double VirtDetailPieChart_5_element1Value, VirtDetailPieChart_5_element2Value;

	VirtDetailPieChart_5_element1Value=Math.Round((((double)vmSnaps_5/vmTot_5)*100),1);
	VirtDetailPieChart_5_element2Value=Math.Round((((double)vmNoSnaps_5/vmTot_5)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_5_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_5_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_5_Element1.Name = "Free";
	VirtDetailPieChart_5_Element1.Percent = VirtDetailPieChart_5_element1Value;
	VirtDetailPieChart_5_Element1.Color = Color.Purple;
	VirtDetailPieChart_5.addPieChartElement(VirtDetailPieChart_5_Element1);

	VirtDetailPieChart_5_Element2.Name = "Used";
	VirtDetailPieChart_5_Element2.Percent = VirtDetailPieChart_5_element2Value;
	VirtDetailPieChart_5_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#D9A5F9");
	VirtDetailPieChart_5.addPieChartElement(VirtDetailPieChart_5_Element2);
        
	VirtDetailPieChart_5.ChartTitle = "Datastores: "+chartData[5,1];
	VirtDetailPieChart_5.ImageAlt = "Datastores: "+chartData[5,1];
	VirtDetailPieChart_5.ImageWidth = 225;
	VirtDetailPieChart_5.ImageHeight = 132;

	VirtDetailPieChart_5.generateChartImage();

	if (Math.Round((((double)vmSnaps_5/vmTot_5)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_5.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[5,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[5,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[5,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_5/vmTot_5)*100),1).ToString()+"</FONT>";

//--- Seventh Chart
	int vmTot_6=1;
	int vmSnaps_6=1;
	int vmNoSnaps_6=1;
	if (Convert.ToInt32(chartData[6,2])>0)
	{
		vmTot_6=Convert.ToInt32(chartData[6,2]);
	}
	if (Convert.ToInt32(chartData[6,3])>0)
	{
		vmSnaps_6=Convert.ToInt32(chartData[6,3]);
	}
	vmNoSnaps_6=vmTot_6-vmSnaps_6;
	double VirtDetailPieChart_6_element1Value, VirtDetailPieChart_6_element2Value;

	VirtDetailPieChart_6_element1Value=Math.Round((((double)vmSnaps_6/vmTot_6)*100),1);
	VirtDetailPieChart_6_element2Value=Math.Round((((double)vmNoSnaps_6/vmTot_6)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_6_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_6_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_6_Element1.Name = "Free";
	VirtDetailPieChart_6_Element1.Percent = VirtDetailPieChart_6_element1Value;
	VirtDetailPieChart_6_Element1.Color = Color.Gold;
	VirtDetailPieChart_6.addPieChartElement(VirtDetailPieChart_6_Element1);

	VirtDetailPieChart_6_Element2.Name = "Used";
	VirtDetailPieChart_6_Element2.Percent = VirtDetailPieChart_6_element2Value;
	VirtDetailPieChart_6_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#FFEF99");
	VirtDetailPieChart_6.addPieChartElement(VirtDetailPieChart_6_Element2);
        
	VirtDetailPieChart_6.ChartTitle = "Datastores: "+chartData[6,1];
	VirtDetailPieChart_6.ImageAlt = "Datastores: "+chartData[6,1];
	VirtDetailPieChart_6.ImageWidth = 225;
	VirtDetailPieChart_6.ImageHeight = 132;

	VirtDetailPieChart_6.generateChartImage();

	if (Math.Round((((double)vmSnaps_6/vmTot_6)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_6.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[6,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[6,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[6,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_6/vmTot_6)*100),1).ToString()+"</FONT>";

//--- Eighth Chart
	int vmTot_7=1;
	int vmSnaps_7=1;
	int vmNoSnaps_7=1;
	if (Convert.ToInt32(chartData[7,2])>0)
	{
		vmTot_7=Convert.ToInt32(chartData[7,2]);
	}
	if (Convert.ToInt32(chartData[7,3])>0)
	{
		vmSnaps_7=Convert.ToInt32(chartData[7,3]);
	}
	vmNoSnaps_7=vmTot_7-vmSnaps_7;
	double VirtDetailPieChart_7_element1Value, VirtDetailPieChart_7_element2Value;

	VirtDetailPieChart_7_element1Value=Math.Round((((double)vmSnaps_7/vmTot_7)*100),1);
	VirtDetailPieChart_7_element2Value=Math.Round((((double)vmNoSnaps_7/vmTot_7)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_7_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_7_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_7_Element1.Name = "Free";
	VirtDetailPieChart_7_Element1.Percent = VirtDetailPieChart_7_element1Value;
	VirtDetailPieChart_7_Element1.Color = Color.HotPink;
	VirtDetailPieChart_7.addPieChartElement(VirtDetailPieChart_7_Element1);

	VirtDetailPieChart_7_Element2.Name = "Used";
	VirtDetailPieChart_7_Element2.Percent = VirtDetailPieChart_7_element2Value;
	VirtDetailPieChart_7_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#FFBCDE");
	VirtDetailPieChart_7.addPieChartElement(VirtDetailPieChart_7_Element2);
        
	VirtDetailPieChart_7.ChartTitle = "Datastores: "+chartData[7,1];
	VirtDetailPieChart_7.ImageAlt = "Datastores: "+chartData[7,1];
	VirtDetailPieChart_7.ImageWidth = 225;
	VirtDetailPieChart_7.ImageHeight = 132;

	VirtDetailPieChart_7.generateChartImage();

	if (Math.Round((((double)vmSnaps_7/vmTot_7)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_7.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[7,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[7,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[7,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_7/vmTot_7)*100),1).ToString()+"</FONT>";

//--- Ninth Chart
	int vmTot_8=1;
	int vmSnaps_8=1;
	int vmNoSnaps_8=1;
	if (Convert.ToInt32(chartData[8,2])>0)
	{
		vmTot_8=Convert.ToInt32(chartData[8,2]);
	}
	if (Convert.ToInt32(chartData[8,3])>0)
	{
		vmSnaps_8=Convert.ToInt32(chartData[8,3]);
	}
	vmNoSnaps_8=vmTot_8-vmSnaps_8;
	double VirtDetailPieChart_8_element1Value, VirtDetailPieChart_8_element2Value;

	VirtDetailPieChart_8_element1Value=Math.Round((((double)vmSnaps_8/vmTot_8)*100),1);
	VirtDetailPieChart_8_element2Value=Math.Round((((double)vmNoSnaps_8/vmTot_8)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element3 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element4 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_8_Element1.Name = "Free";
	VirtDetailPieChart_8_Element1.Percent = VirtDetailPieChart_8_element1Value;
	VirtDetailPieChart_8_Element1.Color = Color.SpringGreen;
	VirtDetailPieChart_8.addPieChartElement(VirtDetailPieChart_8_Element1);

	VirtDetailPieChart_8_Element2.Name = "Used";
	VirtDetailPieChart_8_Element2.Percent = VirtDetailPieChart_8_element2Value;
	VirtDetailPieChart_8_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#99FFAD");
	VirtDetailPieChart_8.addPieChartElement(VirtDetailPieChart_8_Element2);
        
	VirtDetailPieChart_8.ChartTitle = "Datastores: "+chartData[8,1];
	VirtDetailPieChart_8.ImageAlt = "Datastores: "+chartData[8,1];
	VirtDetailPieChart_8.ImageWidth = 225;
	VirtDetailPieChart_8.ImageHeight = 132;

	VirtDetailPieChart_8.generateChartImage();

	if (Math.Round((((double)vmSnaps_8/vmTot_8)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_8.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[8,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[8,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[8,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_8/vmTot_8)*100),1).ToString()+"</FONT>";

//--- Tenth Chart
	int vmTot_9=1;
	int vmSnaps_9=1;
	int vmNoSnaps_9=1;
	if (Convert.ToInt32(chartData[9,2])>0)
	{
		vmTot_9=Convert.ToInt32(chartData[9,2]);
	}
	if (Convert.ToInt32(chartData[9,3])>0)
	{
		vmSnaps_9=Convert.ToInt32(chartData[9,3]);
	}
	vmNoSnaps_9=vmTot_9-vmSnaps_9;
	double VirtDetailPieChart_9_element1Value, VirtDetailPieChart_9_element2Value;

	VirtDetailPieChart_9_element1Value=Math.Round((((double)vmSnaps_9/vmTot_9)*100),1);
	VirtDetailPieChart_9_element2Value=Math.Round((((double)vmNoSnaps_9/vmTot_9)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_9_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_9_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_9_Element1.Name = "Free";
	VirtDetailPieChart_9_Element1.Percent = VirtDetailPieChart_9_element1Value;
	VirtDetailPieChart_9_Element1.Color = Color.Turquoise;
	VirtDetailPieChart_9.addPieChartElement(VirtDetailPieChart_9_Element1);

	VirtDetailPieChart_9_Element2.Name = "Used";
	VirtDetailPieChart_9_Element2.Percent = VirtDetailPieChart_9_element2Value;
	VirtDetailPieChart_9_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#9AF8E3");
	VirtDetailPieChart_9.addPieChartElement(VirtDetailPieChart_9_Element2);
        
	VirtDetailPieChart_9.ChartTitle = "Datastores: "+chartData[9,1];
	VirtDetailPieChart_9.ImageAlt = "Datastores: "+chartData[9,1];
	VirtDetailPieChart_9.ImageWidth = 225;
	VirtDetailPieChart_9.ImageHeight = 132;

	VirtDetailPieChart_9.generateChartImage();

	if (Math.Round((((double)vmSnaps_9/vmTot_9)*100),1)<20)
	{
		deco="red";
	}
	else
	{
		deco="black";
	}
	virtDetailMeta_9.InnerHtml="<B>Datastore Capacity:</B> "+Math.Round(Convert.ToDouble(chartData[9,2])/1000000,2)+"Tb<BR><B>Datastore Free:</B> "+Math.Round(Convert.ToDouble(chartData[9,3])/1000000,2)+"Tb<BR><B>Datastores:</B> "+chartData[9,4]+"<BR><BR><B><FONT color='"+deco+"'>Readiness:</B> "+Math.Round((((double)vmSnaps_9/vmTot_9)*100),1).ToString()+"</FONT>";
*/
} 

public void Page_Load(Object o, EventArgs e)
{
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	Response.Write("<script language='JavaScript'>function printWin() {window.print();} function refreshParent() { window.opener.location.href = window.opener.location.href; if (window.opener.progressWindow) { window.opener.progressWindow.close()  }  window.close();}//-->"+"<"+"/script>");

	string sql;
	DataSet dat, dat1;
	HttpCookie cookie;
	bool sqlSuccess=true;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string bc, rack, os, env, srch;
	string v_userclass, v_hostname, v_ip, v_desc;

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

	if (IsPostBack)
	{
	}

	reportTitle.InnerHtml="Datastores Report";

	StringCollection datastoreClusters = new StringCollection();
	string drVal="", drFree="", drCap="", drCluster="", drCount="";

	int i=0;

	int countY=0;
	int countX=0;
	
	sql="SELECT COUNT(clusterName) FROM clusters WHERE clusterType='ESX'";
	dat=readDb(sql);
	if (dat!=null)
	{
		countY=Convert.ToInt32(dat.Tables[0].Rows[0]["Expr1000"]);
	}
	else
	{
		countY=1;
	}

	string[,] cluStoreData = new string[countY,5];

	sql="SELECT name FROM datastores WHERE name LIKE '%_datastore%' ORDER BY name";
	dat=readDb(sql);
	if (dat!=null)
	{
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				drVal=dr["name"].ToString();
				if (!datastoreClusters.Contains(drVal.Substring(0,drVal.IndexOf("_datastore"))))
				{
					datastoreClusters.Add(drVal.Substring(0,drVal.IndexOf("_datastore")));
				}
			}
		}

		foreach (string s in datastoreClusters)
		{
			sql="SELECT clusterName FROM clusters WHERE clusterType='ESX' ORDER BY clusterName";
			dat1=readDb(sql);
			if (dat1!=null)
			{
				drCluster=dat1.Tables[0].Rows[i]["clusterName"].ToString();
			}

			sql="SELECT SUM(capacityMB), SUM(freespaceMB) FROM datastores WHERE name LIKE '%"+s+"_datastore%'";
			dat1=readDb(sql);
			if (dat1!=null)
			{
				drFree=dat1.Tables[0].Rows[0]["Expr1001"].ToString();
				drCap=dat1.Tables[0].Rows[0]["Expr1000"].ToString();	
			}

			sql="SELECT COUNT(*) FROM datastores WHERE name LIKE '%"+s+"_datastore%'";
			dat1=readDb(sql);
			if (dat1!=null)
			{
				drCount=dat1.Tables[0].Rows[0]["Expr1000"].ToString();				
			}
			
			cluStoreData[i,0]=s;
			cluStoreData[i,1]=drCluster;
			cluStoreData[i,2]=drCap;
			cluStoreData[i,3]=drFree;
			cluStoreData[i,4]=drCount;

			i++;
		}
	}
	doCharts(cluStoreData);
}
</SCRIPT>
</HEAD>
<BODY>
<!--#include file="./report_popup_opener.inc" -->
<CENTER>
	<TABLE border="0" width="100%">
	<TR><TD>
		<H1><DIV id="reportTitle" runat="server"/></H1>
		<CENTER><DIV id="errmsg" style="color:red" runat="server"/></TD></CENTER>
	</TD></TR>
	<TR><TD>
		&nbsp<BR>
		<FORM runat="server">

		<TABLE border=0>
			<TR>
				<TD valign=top align="center">
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_0" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_0" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
							<BUTTON id="goVirtDetailButton_0" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_0" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
<%--
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_1" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_1" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_1" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_1" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_2" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_2" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_2" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_2" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_3" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_3" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_3" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_3" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_4" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_4" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_4" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_4" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
				</TD>
				<TD valign=top align="center">
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_5" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_5" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_5" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_5" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_6" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_6" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_6" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_6" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_7" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_7" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_7" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Datastores</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_7" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>

					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_8" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_8" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_8" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_8" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>

					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_9" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_9" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_9" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_9" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
--%>
					<BR>
				</TD>
		</TABLE>
		<CENTER>
		</CENTER>
		</FORM>
	</TD></TR>
	</TABLE>
</CENTER>
<P align="center"><INPUT type="button" value="Print" onclick="printWin()"/>&nbsp<INPUT type="button" value="Cancel & Close" onclick="refreshParent()"/></P>

<!--#include file="./report_popup_closer.inc" -->
</BODY>
</HTML>