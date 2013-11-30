<TABLE  border="" style="padding:0; border-spacing:0; border-collapse:collapse; width:100%;">
	<TR>
		<TD style="background-color:#669966; text-align:center; vertical-align:text-top; width:15%">&#xa0;
		</TD>
	</TR>
	<TR>
		<TD style="background-color:#669966; text-align:center; vertical-align:text-top; width:15%">


			<DIV id="loggedin" style="color:#ffffff;" runat="server"/><BR/>
			<SELECT id="dcSelector" style="width:150px" onchange="javascript:baseform.submit();" onserverchange="storeDC" runat="server">
				<OPTION SELECTED Value="">Choose DC ...</OPTION>
				<OPTION Value="*">All</OPTION>
			</SELECT><BR/><BR/>
			<DIV style='text-align:center'>
				<IMG src="./img/blank.gif" alt=""/>&#xa0;
				<IMG id="clickback" src="./img/back.gif" onclick=(history.back()) style="cursor: hand" alt="Back"/>&#xa0;
				<A class='nodec' HREF="default.aspx"><IMG src="./img/home.gif" alt="Home">&#xa0;</A>
				<IMG id="clickfwd" src="./img/fwd.gif" onclick=(history.forward()) style="cursor: hand" alt="Forward"/>&#xa0;
				<IMG src="./img/blank.gif" alt=""/>
			</DIV>

			<DIV id="adminMenu" style="color:#ffffff" runat="server"/><BR/>
			
			<TABLE style="width:100%">
				<TR>
					<TD style="background-color:#003300; text-align:center;" colspan="2">
						<SPAN style="color:#FFCC00; font-weight:bold;">Menu</SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='adminServers.aspx' class='nodec'>Servers  &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='adminIPs.aspx' class='nodec'>IP Addresses  &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='switches.aspx' class='nodec'>Switches & Ports</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='reports.aspx' class='nodec'>Reports &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='template.aspx' class='nodec'> &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='template.aspx' class='nodec'> &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='template.aspx' class='nodec'> &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>
				<TR>
					<TD style="text-align:left">
						<A HREF='guides.aspx' class='nodec'>Guides & Docs &#xa0; &#xa0; &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>   
				<TR>
					<TD style="text-align:left">
						<A HREF='FirmwareStatus.htm' class='nodec'>Firmware Status &#xa0; &#xa0;</A>
					</TD>
					<TD style="text-align:right">
						<SPAN class='bold'>&#8594; </SPAN>
					</TD>
				</TR>   
			</TABLE>
			<TABLE style="width:100%">
				<TR>
					<TD style="background-color:#003300; text-align:center">
						<SPAN style="color:#FFCC00; font-weight:bold;">&#xa0;</SPAN>
					</TD>
				</TR>
			</TABLE>
			<BR/>
			<BR/><BR/>
		</TD>
		<TD style="width:85%; vertical-align:text-top;">
			<TABLE border="" style="padding:0; border-spacing:0; border-collapse:collapse; width:100%; height:100;">
				<TR>
					<TD style="background-color:#FFFFFF; vertical-align:text-top;">
					
