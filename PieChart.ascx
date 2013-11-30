<%@ Control Language="C#" ClassName="PieChart_ascx" %>
<!-- Redistributed freely in accordance with author license - http://www.stickler.de/en/software/asp-net/PieChart.aspx -->

<%@ import namespace="System.IO" %>
<%@ import namespace="System.Data" %>
<%@ import namespace="System.Drawing" %>
<%@ import namespace="System.Drawing.Drawing2D" %>
<%@ import namespace="System.Drawing.Imaging" %>
<%@ import namespace="System.Collections" %>

<script language="C#" runat="server">   
        
    public string ChartTitle = "";
    public int ImageHeight = 450;
    public int ImageWidth = 700;
    public string ImageAlt = "PieChartImage";        
        
    public int PanelPadding = 25;
    public int PanelShadowDistance = 3;
    public int PanelShadowAlpha = 50;

    public int PiePaddingTop = 50;
    public int PiePaddingBottom = 20;
    public int PiePaddingLeft = 140;
    public int PiePaddingRight = 30;
    public int PieHeight = 25;

    public Point LabelPosition = new Point( 40, 40 );
                
    public Brush BackgroundBrush = null;
    public Brush TitleBrush = Brushes.White;
    public Brush PanelBackgroundBrush = Brushes.White;

    public class PieChartElement
    {
        public string Name;
        public double Percent;
        public Color Color;
    }

    private ArrayList PieChartElements;
    
    private void Page_Load(object sender, EventArgs e)
    {     
        deleteOldPlotImages();
    }
        
    // delete images older than 10 minutes from PieChartImages folder
    private void deleteOldPlotImages()
    {        
        DirectoryInfo myDirectoryInfo = new DirectoryInfo( Server.MapPath("./PieChartImages") );
        foreach (FileInfo myFileInfo in myDirectoryInfo.GetFiles())
        {
            if (myFileInfo.LastWriteTime.AddMinutes(10) < DateTime.Now)
            {
                myFileInfo.Delete();
            }
        }
    }
            
    // draw panel
    private void drawPanel( Graphics g )
    {                
        // draw background
        Rectangle BackgroundRectangle = new Rectangle( 0, 0, ImageWidth, ImageHeight );

        if( BackgroundBrush == null )
        {
            BackgroundBrush = new System.Drawing.Drawing2D.LinearGradientBrush( BackgroundRectangle, Color.FromArgb( 102, 153, 102 ), Color.FromArgb( 0, 82, 41 ), 0, false) ;
        }

        g.FillRectangle( BackgroundBrush, BackgroundRectangle );

        // draw title
        StringFormat titleStringFormat = new StringFormat();

        titleStringFormat.Alignment = StringAlignment.Center;

        Font titleFont = new Font("Verdana", 12, FontStyle.Bold);

        g.DrawString( ChartTitle, titleFont, TitleBrush, new RectangleF( 0, 0, ImageWidth, 20 ), titleStringFormat );

        // draw main panel
        Rectangle panelRectangle = new Rectangle( PanelPadding, PanelPadding, ImageWidth - 2 * PanelPadding, ImageHeight - 2 * PanelPadding );
        Rectangle panelShadowRectangle = new Rectangle( PanelPadding + PanelShadowDistance, PanelPadding + PanelShadowDistance, (ImageWidth - 2 * PanelPadding) + PanelShadowDistance, (ImageHeight - 2 * PanelPadding) + PanelShadowDistance );
        SolidBrush transparentSolidBrush = new SolidBrush( Color.FromArgb( PanelShadowAlpha, 0, 0, 0 )  );

        g.FillRectangle( transparentSolidBrush, panelShadowRectangle );
        g.FillRectangle( PanelBackgroundBrush, panelRectangle );
        g.DrawRectangle( Pens.Black, panelRectangle );
    }

    // draw pie slices
    private void drawPie( Graphics g )
    {        
        Rectangle PieRectangle = new Rectangle( PanelPadding + PiePaddingLeft, PanelPadding + PiePaddingTop, ImageWidth - 1 - 2*PanelPadding - PiePaddingRight - PiePaddingLeft, ImageHeight - 1 - 2*PanelPadding - PiePaddingBottom - PiePaddingTop );        
        for (int hPos = 1; hPos <= PieHeight; ++hPos)
        {
            float startAngle = 180.0f;
            float sweepAngle = 0.0f;
            
            foreach( PieChartElement myPieChartElement in PieChartElements )
            {
                Brush myBrush;

                startAngle += sweepAngle;
                sweepAngle = (float)( myPieChartElement.Percent * 3.6 );
                
                if (hPos == PieHeight)
                {
                    // normal color
                    myBrush = new SolidBrush( myPieChartElement.Color );
                }
                else
                {
                    // little bit darker color
                    int R = ( myPieChartElement.Color.R - 50 > 0 ) ? myPieChartElement.Color.R - 30 : 0;
                    int G = ( myPieChartElement.Color.G - 50 > 0 ) ? myPieChartElement.Color.G - 30 : 0;
                    int B = ( myPieChartElement.Color.B - 50 > 0 ) ? myPieChartElement.Color.B - 30 : 0;
                    Color darkerColor = Color.FromArgb( R, G, B );
                    myBrush = new SolidBrush( darkerColor );
                }
                g.FillPie( myBrush, PieRectangle.X, PieRectangle.Y - hPos, PieRectangle.Width, PieRectangle.Height, startAngle, sweepAngle );
                
                // draw border for first and last pie
                if( hPos == PieHeight || hPos == 1 )
                {
                    g.DrawPie( Pens.Black, PieRectangle.X, PieRectangle.Y - hPos, PieRectangle.Width, PieRectangle.Height, startAngle, sweepAngle );
                }
            }
        }
    }

    private void drawLabels( Graphics g )
    {
        float x = (float)LabelPosition.X;
        float y = (float)LabelPosition.Y;
        
        Font labelFont = new Font( "Verdana", 8, FontStyle.Bold );        
        
        foreach( PieChartElement myPieChartElement in PieChartElements )
        {            
            Brush labelBrush = new SolidBrush( myPieChartElement.Color );
            g.FillRectangle( labelBrush, x, (float)(y + labelFont.Height/2 - 1), 5.0f, 5.0f );

            string labelText = myPieChartElement.Name + " " + myPieChartElement.Percent.ToString() + "%";                
            g.DrawString( labelText, labelFont, Brushes.Black, x + 8, y );
            y += labelFont.Height + 5;
        }
    }

    public void addPieChartElement(PieChartElement newPieChartElement)
    {
        if( this.PieChartElements == null ) this.PieChartElements = new ArrayList();
        this.PieChartElements.Add( newPieChartElement );
    }
    
    public void generateChartImage()
    {
        Bitmap myBitmap = new Bitmap( ImageWidth, ImageHeight, PixelFormat.Format32bppArgb );               
        
        long ticks = (long)(DateTime.Now.Ticks / 100000000);
        string filename = "./PieChartImages/" + ID + "_" + ticks.ToString() + ".png";

        PieChartImage.Width = ImageWidth;
        PieChartImage.Height = ImageHeight;
        PieChartImage.ImageUrl = filename;
        PieChartImage.AlternateText = ImageAlt;
                
        FileInfo myFileInfo = new FileInfo(Server.MapPath(filename));
        if (myFileInfo.Exists) return;
        
        Graphics myGraphics = Graphics.FromImage( myBitmap );

        drawPanel( myGraphics );
        drawPie( myGraphics );
        drawLabels( myGraphics );
        
        myBitmap.Save( Server.MapPath(filename), ImageFormat.Png );     
    }
    
</script>

<asp:image id="PieChartImage" runat="server" />