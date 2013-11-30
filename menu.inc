	<NAV id='menu' class='lightColorFill'>
		<DIV id='loggedin' class='center' style='color:#ffffff;' runat='server'/><BR/>

		<DIV id='dcSelect'>
			<SELECT id='dcSelector' style='width:145px' onchange='javascript:form1.submit();' onserverchange='storeDC' runat='server'>
				<OPTION SELECTED Value=''>Choose DC ...</OPTION>
				<OPTION Value='*'>All</OPTION>
			</SELECT>
			<BR/><BR/>
		</DIV> <!-- End: dcSelect -->
		<DIV id='siteNav' class='center'>
			<IMG src='./img/blank.gif' alt=''/>&#xa0;
			<IMG id='clickback' src='./img/back.gif' onclick=(history.back()) style='cursor: hand' alt='Back'/>&#xa0;
			<A class='nodec' HREF='default.aspx'><IMG src='./img/home.gif' alt='Home'>&#xa0;</A>
			<IMG id='clickfwd' src='./img/fwd.gif' onclick=(history.forward()) style='cursor: hand' alt='Forward'/>&#xa0;
			<IMG src='./img/blank.gif' alt=''/>
		</DIV> <!-- End: siteNav -->
		<BR/>
		<DIV id='adminMenu' runat='server'>

		</DIV> <!-- End: adminMenu -->
		<DIV id='appMenu'>
			<DIV class='menuSeparator'>
				Menu
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainRacks.aspx' class='nodec'>Racks &amp; Cabinets</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainHardware.aspx' class='nodec'>Hardware &amp; Devices</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainServers.aspx#top' class='nodec'>Servers</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainSoftware.aspx' class='nodec'>Software</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainIPs.aspx' class='nodec'>Subnets &amp; IPs</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainSwitches.aspx' class='nodec'>Switches &amp; Ports</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainReports.aspx' class='nodec'>Reports</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>

			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='template.aspx' class='nodec'>&#xa0;</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='mainGuides.aspx' class='nodec'>Guides &amp; Docs</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#8594; </SPAN>
				</SPAN>
			</DIV>   
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='FirmwareStatus.htm' class='nodec'>Firmware Status</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					&#8594;
				</SPAN>
			</DIV>
			<DIV>
				<SPAN class='txtAlignMiddleLeft menuItem'>
					<A HREF='template.aspx' class='nodec'>&#xa0;</A>
				</SPAN>
				<SPAN style='txtAlignMiddleRight menuIcon'>
					<SPAN class='bold'>&#xa0;</SPAN>
				</SPAN>
			</DIV>
			<DIV>
				<SPAN id='menuEnd1'>
					<IMG src='./IMG/TRc2.gif' width='11' height='10' alt=''>
				</SPAN>
				<SPAN id='menuEnd2'>
				</SPAN>
				<SPAN id='menuEnd3'>
					<IMG src='./IMG/TRc1.gif' width='11' height='10' alt=''>
				</SPAN>
			</DIV>			
		</DIV> <!-- End: appMenu -->
	</NAV> <!-- End: menu -->