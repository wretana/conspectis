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
//	Response.Write(fromId.Substring(fromId.IndexOf("_")+1,fromId.Length-fromId.IndexOf("_")-1));
	Response.Write("<script language='javascript'>window.open('vmSnapshotDetail_report.aspx?cluster="+fromId.Substring(fromId.IndexOf("_")+1,fromId.Length-fromId.IndexOf("_")-1)+"','snapDetailWin','width=800,height=800,menubar=no,status=yes,scrollbars=yes')"+";<"+"/script>");

//	Response.Write("javascript:window.open('vmSnapshotDetail_report.aspx?cluster="++"','snapDetailWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes')");
}

void doCharts(string[,] chartData)
{
//--- First Chart
	int vmTot_0=1;
	int vmSnaps_0=1;
	int vmNoSnaps_0=1;
	if (Convert.ToInt32(chartData[0,1])>0)
	{
		vmTot_0=Convert.ToInt32(chartData[0,1]);
	}
	if (Convert.ToInt32(chartData[0,2])>0)
	{
		vmSnaps_0=Convert.ToInt32(chartData[0,2]);
	}
	vmNoSnaps_0=vmTot_0-vmSnaps_0;
	double VirtDetailPieChart_0_element1Value, VirtDetailPieChart_0_element2Value;

	VirtDetailPieChart_0_element1Value=Math.Round((((double)vmSnaps_0/vmTot_0)*100),1);
	VirtDetailPieChart_0_element2Value=Math.Round((((double)vmNoSnaps_0/vmTot_0)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_0_Element1.Name = "With Snaps";
	VirtDetailPieChart_0_Element1.Percent = VirtDetailPieChart_0_element1Value;
	VirtDetailPieChart_0_Element1.Color = Color.DarkOrange;
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element1);

	VirtDetailPieChart_0_Element2.Name = "Without Snaps";
	VirtDetailPieChart_0_Element2.Percent = VirtDetailPieChart_0_element2Value;
	VirtDetailPieChart_0_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#FFCC99");
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element2);

  	VirtDetailPieChart_0.ChartTitle = "Snapshots: "+chartData[0,0];
	VirtDetailPieChart_0.ImageAlt = "Snapshots: "+chartData[0,0];
	VirtDetailPieChart_0.ImageWidth = 225;
	VirtDetailPieChart_0.ImageHeight = 132;

	VirtDetailPieChart_0.generateChartImage();

	virtDetailMeta_0.InnerHtml="<B>Total VMs:</B> "+chartData[0,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[0,2]+"("+vmNoSnaps_0.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[0,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[0,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[0,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[0,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[0,4])/Convert.ToDouble(chartData[0,3]),2)+" Mb<BR>";



//--- Second Chart
	int vmTot_1=1;
	int vmSnaps_1=1;
	int vmNoSnaps_1=1;
	if (Convert.ToInt32(chartData[1,1])>0)
	{
		vmTot_1=Convert.ToInt32(chartData[1,1]);
	}
	if (Convert.ToInt32(chartData[1,2])>0)
	{
		vmSnaps_1=Convert.ToInt32(chartData[1,2]);
	}
	vmNoSnaps_1=vmTot_1-vmSnaps_1;
	double VirtDetailPieChart_1_element1Value, VirtDetailPieChart_1_element2Value;

	VirtDetailPieChart_1_element1Value=Math.Round((((double)vmSnaps_1/vmTot_1)*100),1);
	VirtDetailPieChart_1_element2Value=Math.Round((((double)vmNoSnaps_1/vmTot_1)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_1_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_1_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_1_Element1.Name = "With Snaps";
	VirtDetailPieChart_1_Element1.Percent = VirtDetailPieChart_1_element1Value;
	VirtDetailPieChart_1_Element1.Color = Color.DarkGreen;
	VirtDetailPieChart_1.addPieChartElement(VirtDetailPieChart_1_Element1);

	VirtDetailPieChart_1_Element2.Name = "Without Snaps";
	VirtDetailPieChart_1_Element2.Percent = VirtDetailPieChart_1_element2Value;
	VirtDetailPieChart_1_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#A4C9A4");
	VirtDetailPieChart_1.addPieChartElement(VirtDetailPieChart_1_Element2);
      
	VirtDetailPieChart_1.ChartTitle = "Snapshots: "+chartData[1,0];
	VirtDetailPieChart_1.ImageAlt = "Snapshots: "+chartData[1,0];
	VirtDetailPieChart_1.ImageWidth = 225;
	VirtDetailPieChart_1.ImageHeight = 132;

	VirtDetailPieChart_1.generateChartImage();

	virtDetailMeta_1.InnerHtml="<B>Total VMs:</B> "+chartData[1,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[1,2]+"("+vmNoSnaps_1.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[1,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[1,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[1,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[1,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[1,4])/Convert.ToDouble(chartData[1,3]),2)+" Mb<BR>";

//--- Third Chart
	int vmTot_2=1;
	int vmSnaps_2=1;
	int vmNoSnaps_2=1;
	if (Convert.ToInt32(chartData[2,1])>0)
	{
		vmTot_2=Convert.ToInt32(chartData[2,1]);
	}
	if (Convert.ToInt32(chartData[2,2])>0)
	{
		vmSnaps_2=Convert.ToInt32(chartData[2,2]);
	}
	vmNoSnaps_2=vmTot_2-vmSnaps_2;
	double VirtDetailPieChart_2_element1Value, VirtDetailPieChart_2_element2Value;

	VirtDetailPieChart_2_element1Value=Math.Round((((double)vmSnaps_2/vmTot_2)*100),1);
	VirtDetailPieChart_2_element2Value=Math.Round((((double)vmNoSnaps_2/vmTot_1)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_2_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_2_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_2_Element1.Name = "With Snaps";
	VirtDetailPieChart_2_Element1.Percent = VirtDetailPieChart_2_element1Value;
	VirtDetailPieChart_2_Element1.Color = Color.DodgerBlue;
	VirtDetailPieChart_2.addPieChartElement(VirtDetailPieChart_2_Element1);

	VirtDetailPieChart_2_Element2.Name = "Without Snaps";
	VirtDetailPieChart_2_Element2.Percent = VirtDetailPieChart_2_element2Value;
	VirtDetailPieChart_2_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#A3D2FF");
	VirtDetailPieChart_2.addPieChartElement(VirtDetailPieChart_2_Element2);
        
	VirtDetailPieChart_2.ChartTitle = "Snapshots: "+chartData[2,0];
	VirtDetailPieChart_2.ImageAlt = "Snapshots: "+chartData[2,0];
	VirtDetailPieChart_2.ImageWidth = 225;
	VirtDetailPieChart_2.ImageHeight = 132;

	VirtDetailPieChart_2.generateChartImage();

	virtDetailMeta_2.InnerHtml="<B>Total VMs:</B> "+chartData[2,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[2,2]+"("+vmNoSnaps_2.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[2,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[2,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[2,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[2,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[2,4])/Convert.ToDouble(chartData[2,3]),2)+" Mb<BR>";

//--- Fourth Chart
	int vmTot_3=1;
	int vmSnaps_3=1;
	int vmNoSnaps_3=1;
	if (Convert.ToInt32(chartData[3,1])>0)
	{
		vmTot_3=Convert.ToInt32(chartData[3,1]);
	}
	if (Convert.ToInt32(chartData[3,2])>0)
	{
		vmSnaps_3=Convert.ToInt32(chartData[3,2]);
	}
	vmNoSnaps_3=vmTot_3-vmSnaps_3;
	double VirtDetailPieChart_3_element1Value, VirtDetailPieChart_3_element2Value;

	VirtDetailPieChart_3_element1Value=Math.Round((((double)vmSnaps_3/vmTot_3)*100),1);
	VirtDetailPieChart_3_element2Value=Math.Round((((double)vmNoSnaps_3/vmTot_3)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_3_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_3_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_3_Element1.Name = "With Snaps";
	VirtDetailPieChart_3_Element1.Percent = VirtDetailPieChart_3_element1Value;
	VirtDetailPieChart_3_Element1.Color = Color.Crimson;
	VirtDetailPieChart_3.addPieChartElement(VirtDetailPieChart_3_Element1);

	VirtDetailPieChart_3_Element2.Name = "Without Snaps";
	VirtDetailPieChart_3_Element2.Percent = VirtDetailPieChart_3_element2Value;
	VirtDetailPieChart_3_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#F69DAF");
	VirtDetailPieChart_3.addPieChartElement(VirtDetailPieChart_3_Element2);
        
	VirtDetailPieChart_3.ChartTitle = "Snapshots: "+chartData[3,0];
	VirtDetailPieChart_3.ImageAlt = "Snapshots: "+chartData[3,0];
	VirtDetailPieChart_3.ImageWidth = 225;
	VirtDetailPieChart_3.ImageHeight = 132;

	VirtDetailPieChart_3.generateChartImage();

	virtDetailMeta_3.InnerHtml="<B>Total VMs:</B> "+chartData[3,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[3,2]+"("+vmNoSnaps_3.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[3,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[3,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[3,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[3,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[3,4])/Convert.ToDouble(chartData[3,3]),2)+" Mb<BR>";

//--- Fifth Chart
	int vmTot_4=1;
	int vmSnaps_4=1;
	int vmNoSnaps_4=1;
	if (Convert.ToInt32(chartData[4,1])>0)
	{
		vmTot_4=Convert.ToInt32(chartData[4,1]);
	}
	if (Convert.ToInt32(chartData[4,2])>0)
	{
		vmSnaps_4=Convert.ToInt32(chartData[4,2]);
	}
	vmNoSnaps_4=vmTot_4-vmSnaps_4;
	double VirtDetailPieChart_4_element1Value, VirtDetailPieChart_4_element2Value;

	VirtDetailPieChart_4_element1Value=Math.Round((((double)vmSnaps_4/vmTot_4)*100),1);
	VirtDetailPieChart_4_element2Value=Math.Round((((double)vmNoSnaps_4/vmTot_4)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_4_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_4_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_4_Element1.Name = "With Snaps";
	VirtDetailPieChart_4_Element1.Percent = VirtDetailPieChart_4_element1Value;
	VirtDetailPieChart_4_Element1.Color = Color.SaddleBrown;
	VirtDetailPieChart_4.addPieChartElement(VirtDetailPieChart_4_Element1);

	VirtDetailPieChart_4_Element2.Name = "Without Snaps";
	VirtDetailPieChart_4_Element2.Percent = VirtDetailPieChart_4_element2Value;
	VirtDetailPieChart_4_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#EFB389");
	VirtDetailPieChart_4.addPieChartElement(VirtDetailPieChart_4_Element2);
       
	VirtDetailPieChart_4.ChartTitle = "Snapshots: "+chartData[4,0];
	VirtDetailPieChart_4.ImageAlt = "Snapshots: "+chartData[4,0];
	VirtDetailPieChart_4.ImageWidth = 225;
	VirtDetailPieChart_4.ImageHeight = 132;

	VirtDetailPieChart_4.generateChartImage();

	virtDetailMeta_4.InnerHtml="<B>Total VMs:</B> "+chartData[4,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[4,2]+"("+vmNoSnaps_4.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[4,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[4,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[4,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[4,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[4,4])/Convert.ToDouble(chartData[4,3]),2)+" Mb<BR>";

//--- Sixth Chart
	int vmTot_5=1;
	int vmSnaps_5=1;
	int vmNoSnaps_5=1;
	if (Convert.ToInt32(chartData[5,1])>0)
	{
		vmTot_5=Convert.ToInt32(chartData[5,1]);
	}
	if (Convert.ToInt32(chartData[5,2])>0)
	{
		vmSnaps_5=Convert.ToInt32(chartData[5,2]);
	}
	vmNoSnaps_5=vmTot_5-vmSnaps_5;
	double VirtDetailPieChart_5_element1Value, VirtDetailPieChart_5_element2Value;

	VirtDetailPieChart_5_element1Value=Math.Round((((double)vmSnaps_5/vmTot_5)*100),1);
	VirtDetailPieChart_5_element2Value=Math.Round((((double)vmNoSnaps_5/vmTot_5)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_5_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_5_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_5_Element1.Name = "With Snaps";
	VirtDetailPieChart_5_Element1.Percent = VirtDetailPieChart_5_element1Value;
	VirtDetailPieChart_5_Element1.Color = Color.Purple;
	VirtDetailPieChart_5.addPieChartElement(VirtDetailPieChart_5_Element1);

	VirtDetailPieChart_5_Element2.Name = "Without Snaps";
	VirtDetailPieChart_5_Element2.Percent = VirtDetailPieChart_5_element2Value;
	VirtDetailPieChart_5_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#D9A5F9");
	VirtDetailPieChart_5.addPieChartElement(VirtDetailPieChart_5_Element2);
        
	VirtDetailPieChart_5.ChartTitle = "Snapshots: "+chartData[5,0];
	VirtDetailPieChart_5.ImageAlt = "Snapshots: "+chartData[5,0];
	VirtDetailPieChart_5.ImageWidth = 225;
	VirtDetailPieChart_5.ImageHeight = 132;

	VirtDetailPieChart_5.generateChartImage();

	virtDetailMeta_5.InnerHtml="<B>Total VMs:</B> "+chartData[5,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[5,2]+"("+vmNoSnaps_5.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[5,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[5,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[5,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[5,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[5,4])/Convert.ToDouble(chartData[5,3]),2)+" Mb<BR>";

//--- Seventh Chart
	int vmTot_6=1;
	int vmSnaps_6=1;
	int vmNoSnaps_6=1;
	if (Convert.ToInt32(chartData[6,1])>0)
	{
		vmTot_6=Convert.ToInt32(chartData[6,1]);
	}
	if (Convert.ToInt32(chartData[6,2])>0)
	{
		vmSnaps_6=Convert.ToInt32(chartData[6,2]);
	}
	vmNoSnaps_6=vmTot_6-vmSnaps_6;
	double VirtDetailPieChart_6_element1Value, VirtDetailPieChart_6_element2Value;

	VirtDetailPieChart_6_element1Value=Math.Round((((double)vmSnaps_6/vmTot_6)*100),1);
	VirtDetailPieChart_6_element2Value=Math.Round((((double)vmNoSnaps_6/vmTot_6)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_6_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_6_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_6_Element1.Name = "With Snaps";
	VirtDetailPieChart_6_Element1.Percent = VirtDetailPieChart_6_element1Value;
	VirtDetailPieChart_6_Element1.Color = Color.Gold;
	VirtDetailPieChart_6.addPieChartElement(VirtDetailPieChart_6_Element1);

	VirtDetailPieChart_6_Element2.Name = "Without Snaps";
	VirtDetailPieChart_6_Element2.Percent = VirtDetailPieChart_6_element2Value;
	VirtDetailPieChart_6_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#FFEF99");
	VirtDetailPieChart_6.addPieChartElement(VirtDetailPieChart_6_Element2);
        
	VirtDetailPieChart_6.ChartTitle = "Snapshots: "+chartData[6,0];
	VirtDetailPieChart_6.ImageAlt = "Snapshots: "+chartData[6,0];
	VirtDetailPieChart_6.ImageWidth = 225;
	VirtDetailPieChart_6.ImageHeight = 132;

	VirtDetailPieChart_6.generateChartImage();

	virtDetailMeta_6.InnerHtml="<B>Total VMs:</B> "+chartData[6,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[6,2]+"("+vmNoSnaps_6.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[6,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[6,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[6,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[6,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[6,4])/Convert.ToDouble(chartData[6,3]),2)+" Mb<BR>";

//--- Eighth Chart
	int vmTot_7=1;
	int vmSnaps_7=1;
	int vmNoSnaps_7=1;
	if (Convert.ToInt32(chartData[7,1])>0)
	{
		vmTot_7=Convert.ToInt32(chartData[7,1]);
	}
	if (Convert.ToInt32(chartData[7,2])>0)
	{
		vmSnaps_7=Convert.ToInt32(chartData[7,2]);
	}
	vmNoSnaps_7=vmTot_7-vmSnaps_7;
	double VirtDetailPieChart_7_element1Value, VirtDetailPieChart_7_element2Value;

	VirtDetailPieChart_7_element1Value=Math.Round((((double)vmSnaps_7/vmTot_7)*100),1);
	VirtDetailPieChart_7_element2Value=Math.Round((((double)vmNoSnaps_7/vmTot_7)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_7_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_7_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_7_Element1.Name = "With Snaps";
	VirtDetailPieChart_7_Element1.Percent = VirtDetailPieChart_7_element1Value;
	VirtDetailPieChart_7_Element1.Color = Color.HotPink;
	VirtDetailPieChart_7.addPieChartElement(VirtDetailPieChart_7_Element1);

	VirtDetailPieChart_7_Element2.Name = "Without Snaps";
	VirtDetailPieChart_7_Element2.Percent = VirtDetailPieChart_7_element2Value;
	VirtDetailPieChart_7_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#FFBCDE");
	VirtDetailPieChart_7.addPieChartElement(VirtDetailPieChart_7_Element2);
        
	VirtDetailPieChart_7.ChartTitle = "Snapshots: "+chartData[7,0];
	VirtDetailPieChart_7.ImageAlt = "Snapshots: "+chartData[7,0];
	VirtDetailPieChart_7.ImageWidth = 225;
	VirtDetailPieChart_7.ImageHeight = 132;

	VirtDetailPieChart_7.generateChartImage();

	virtDetailMeta_7.InnerHtml="<B>Total VMs:</B> "+chartData[7,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[7,2]+"("+vmNoSnaps_7.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[7,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[7,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[7,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[7,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[7,4])/Convert.ToDouble(chartData[7,3]),2)+" Mb<BR>";

//--- Ninth Chart
	int vmTot_8=1;
	int vmSnaps_8=1;
	int vmNoSnaps_8=1;
	if (Convert.ToInt32(chartData[8,1])>0)
	{
		vmTot_8=Convert.ToInt32(chartData[8,1]);
	}
	if (Convert.ToInt32(chartData[8,2])>0)
	{
		vmSnaps_8=Convert.ToInt32(chartData[8,2]);
	}
	vmNoSnaps_8=vmTot_8-vmSnaps_8;
	double VirtDetailPieChart_8_element1Value, VirtDetailPieChart_8_element2Value;

	VirtDetailPieChart_8_element1Value=Math.Round((((double)vmSnaps_8/vmTot_8)*100),1);
	VirtDetailPieChart_8_element2Value=Math.Round((((double)vmNoSnaps_8/vmTot_8)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element3 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_8_Element4 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_8_Element1.Name = "With Snaps";
	VirtDetailPieChart_8_Element1.Percent = VirtDetailPieChart_8_element1Value;
	VirtDetailPieChart_8_Element1.Color = Color.SpringGreen;
	VirtDetailPieChart_8.addPieChartElement(VirtDetailPieChart_8_Element1);

	VirtDetailPieChart_8_Element2.Name = "Without Snaps";
	VirtDetailPieChart_8_Element2.Percent = VirtDetailPieChart_8_element2Value;
	VirtDetailPieChart_8_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#99FFAD");
	VirtDetailPieChart_8.addPieChartElement(VirtDetailPieChart_8_Element2);
        
	VirtDetailPieChart_8.ChartTitle = "Snapshots: "+chartData[8,0];
	VirtDetailPieChart_8.ImageAlt = "Snapshots: "+chartData[8,0];
	VirtDetailPieChart_8.ImageWidth = 225;
	VirtDetailPieChart_8.ImageHeight = 132;

	VirtDetailPieChart_8.generateChartImage();

	virtDetailMeta_8.InnerHtml="<B>Total VMs:</B> "+chartData[8,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[8,2]+"("+vmNoSnaps_8.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[8,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[8,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[8,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[8,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[8,4])/Convert.ToDouble(chartData[8,3]),2)+" Mb<BR>";

//--- Tenth Chart
/*	int vmTot_9=1;
	int vmSnaps_9=1;
	int vmNoSnaps_9=1;
	if (Convert.ToInt32(chartData[9,1])>0)
	{
		vmTot_9=Convert.ToInt32(chartData[9,1]);
	}
	if (Convert.ToInt32(chartData[9,2])>0)
	{
		vmSnaps_9=Convert.ToInt32(chartData[9,2]);
	}
	vmNoSnaps_9=vmTot_9-vmSnaps_9;
	double VirtDetailPieChart_9_element1Value, VirtDetailPieChart_9_element2Value;

	VirtDetailPieChart_9_element1Value=Math.Round((((double)vmSnaps_9/vmTot_9)*100),1);
	VirtDetailPieChart_9_element2Value=Math.Round((((double)vmNoSnaps_9/vmTot_9)*100),1);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_9_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_9_Element2 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_9_Element1.Name = "With Snaps";
	VirtDetailPieChart_9_Element1.Percent = VirtDetailPieChart_9_element1Value;
	VirtDetailPieChart_9_Element1.Color = Color.Turquoise;
	VirtDetailPieChart_9.addPieChartElement(VirtDetailPieChart_9_Element1);

	VirtDetailPieChart_9_Element2.Name = "Without Snaps";
	VirtDetailPieChart_9_Element2.Percent = VirtDetailPieChart_9_element2Value;
	VirtDetailPieChart_9_Element2.Color = System.Drawing.ColorTranslator.FromHtml("#9AF8E3");
	VirtDetailPieChart_9.addPieChartElement(VirtDetailPieChart_9_Element2);
        
	VirtDetailPieChart_9.ChartTitle = "Snapshots: "+chartData[9,0];
	VirtDetailPieChart_9.ImageAlt = "Snapshots: "+chartData[9,0];
	VirtDetailPieChart_9.ImageWidth = 225;
	VirtDetailPieChart_9.ImageHeight = 132;

	VirtDetailPieChart_9.generateChartImage();

	virtDetailMeta_9.InnerHtml="<B>Total VMs:</B> "+chartData[9,1]+"<BR><B>VMs w/ Snapshots:</B> "+chartData[9,2]+"("+vmNoSnaps_9.ToString()+")<BR><B>Bulk Snaps Count:</B> "+chartData[9,3]+"<BR><B>Snaps Size-On-Disk:</B> "+Math.Round(Convert.ToDouble(chartData[9,4]),2).ToString()+"Mb - "+Math.Round(Convert.ToDouble(chartData[9,4])/1000,1)+"Gb - "+Math.Round(Convert.ToDouble(chartData[9,4])/1000000,2)+"Tb<BR><B>Avg Snap Size:</B> "+Math.Round(Convert.ToDouble(chartData[9,4])/Convert.ToDouble(chartData[9,3]),2)+" Mb<BR>"; */
}

public void Page_Load(Object o, EventArgs e)
{
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	Response.Write("<script language='JavaScript'>function printWin() {window.print();} function refreshParent() { window.opener.location.href = window.opener.location.href; if (window.opener.progressWindow) { window.opener.progressWindow.close()  }  window.close();}//-->"+"<"+"/script>");

	string sql;
	DataSet dat = new DataSet();
	DataSet dat1 = new DataSet();
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

	reportTitle.InnerHtml="VM Snapshot Report";

	string[,] snapData = new string[10,5];
	int countY=0;
	int countX=0;

	sql="SELECT DISTINCT(memberOfCluster) FROM servers WHERE memberOfCluster IS NOT NULL"; //Clusters
	dat=readDb(sql);
	if (dat!=null)
	{
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				snapData[countY,0]=dr["memberOfCluster"].ToString();
				sql="SELECT COUNT(serverName) FROM servers WHERE memberOfCluster='"+snapData[countY,0]+"'"; //Total VM's in Cluster 'engineering_cluster'
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,1]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
					if (snapData[countY,1]=="")
					{
						snapData[countY,1]="0";
					}
				}
				else
				{
					snapData[countY,1]="0";
				}
				sql="SELECT COUNT(*) FROM (SELECT DISTINCT(serverName) FROM (SELECT serverName, serverLanIp, serverOS, serverOsBuild, serverPurpose, serverPubVlan, memberOfCluster,VMToolsState, VMPowerState, VMToolsVersion, VMSysDiskPath, VMDataDiskPath, VMSysDiskCapMB, VMDataDiskCapMB, VMSysDiskFreeMB, VMDataDiskFreeMB, snapId, snapshots.VMName, snapDesc, created, sizeOnDisk FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName) WHERE memberOfCluster='"+snapData[countY,0]+"')"; // Number of VM's with Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,2]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
					if (snapData[countY,2]=="")
					{
						snapData[countY,2]="0";
					}
				}
				else
				{
					snapData[countY,2]="0";
				}
				sql="SELECT COUNT(*) FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName WHERE memberOfCluster='"+snapData[countY,0]+"'"; //Number of Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,3]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
					if (snapData[countY,3]=="")
					{
						snapData[countY,3]="0";
					}
				}
				else
				{
					snapData[countY,3]="0";
				}
				sql="SELECT SUM(sizeOnDisk) FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName WHERE memberOfCluster='"+snapData[countY,0]+"'"; //Size-On-Disk of Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,4]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
					if (snapData[countY,4]=="")
					{
						snapData[countY,4]="0";
					}
				}
				else
				{
					snapData[countY,4]="0";
				}
				sql="SELECT DISTINCT(VMName) FROM (SELECT serverName, serverLanIp, serverOS, serverOsBuild, serverPurpose, serverPubVlan, memberOfCluster,VMToolsState, VMPowerState, VMToolsVersion, VMSysDiskPath, VMDataDiskPath, VMSysDiskCapMB, VMDataDiskCapMB, VMSysDiskFreeMB, VMDataDiskFreeMB, snapId, snapshots.VMName, snapDesc, created, sizeOnDisk FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName) WHERE memberOfCluster='"+snapData[countY,0]+"'"; //List of VM's with Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					foreach (DataTable dtt in dat1.Tables)
					{
						foreach (DataRow drr in dtt.Rows)
						{
							sql="SELECT * FROM snapshots WHERE VMName='"+drr["VMName"].ToString()+"'";
						}
					}
				}
				else
				{
				}
				countY++;
			}
		}
	}

	doCharts(snapData);
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
		<CENTER>
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
								<BUTTON id="goVirtDetailButton_0" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_0" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
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
								<BUTTON id="goVirtDetailButton_1" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
								<BUTTON id="goVirtDetailButton_2" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
								<BUTTON id="goVirtDetailButton_3" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
								<BUTTON id="goVirtDetailButton_4" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
								<BUTTON id="goVirtDetailButton_5" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
								<BUTTON id="goVirtDetailButton_6" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
								<BUTTON id="goVirtDetailButton_7" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
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
<%--
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
		</CENTER>
		<TABLE id="svrTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
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