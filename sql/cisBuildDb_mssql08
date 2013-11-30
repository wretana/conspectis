USE [conspectis-db]
GO

/****** Object:  Table [application]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [application](
                [appId] [int] IDENTITY (1,1) NOT NULL,
                [appName] [nvarchar](50) NOT NULL,
                [appVer] [nvarchar](50) NOT NULL,
                [appDesc] [nvarchar](50) NOT NULL,
                [appDateRequested] [nvarchar](50) NOT NULL,
                [appSponsor] [int] NOT NULL,
                [appTechContact] [int] NOT NULL,
                [appEngagementMgr] [int] NULL,
                [appProjectMgr] [int] NULL,
                [appEDBA] [int] NULL,
                [appAssessmentBy] [int] NULL,
                [appAssesmentDate] [nvarchar](50) NULL,
                [appServer] [nvarchar](50) NULL,
                [appEnvironments] [nvarchar](50) NULL,
                [appOtherSfw] [nvarchar](50) NULL,
                [appLifetime] [nvarchar](50) NOT NULL,
                [appAvailReqd] [nvarchar](50) NULL,
                [appDevUsers] [int] NOT NULL,
                [appDevOpenHour] [int] NOT NULL,
                [appDevCloseHour] [int] NOT NULL,
                [appDevAvgConcUsers] [int] NOT NULL,
                [appDevPeakConcUsers] [int] NOT NULL,
                [appDevProjUserGrowth] [int] NULL,
                [appDevNetUsage] [nvarchar](50) NULL,
                [appDevNetUsageGrowth] [nvarchar](50) NULL,
                [appDevExternalFacing] [nvarchar](50) NULL,
                [appTestUsers] [int] NULL,
                [appTestOpenHour] [int] NULL,
                [appTestCloseHour] [int] NULL,
                [appTestAvgConcUsers] [int] NULL,
                [appTestPeakConcUsers] [int] NULL,
                [appTestProjUserGrowth] [int] NULL,
                [appTestNetUsage] [nvarchar](50) NULL,
                [appTestNetUsageGrowth] [nvarchar](50) NULL,
                [appTestExternalFacing] [nvarchar](50) NULL,
                [appProofUsers] [int] NULL,
                [appProofOpenHour] [int] NULL,
                [appProofCloseHour] [int] NULL,
                [appProofAvgConcUsers] [int] NULL,
                [appProofPeakConcUsers] [int] NULL,
                [appProofProjUserGrowth] [int] NULL,
                [appProofNetUsage] [nvarchar](50) NULL,
                [appProofNetUsageGrowth] [nvarchar](50) NULL,
                [appProofExternalFacing] [nvarchar](50) NULL,
                [appDBType] [nvarchar](50) NOT NULL,
                [appDBSize] [nvarchar](50) NOT NULL,
                [appDBGrowth] [nvarchar](50) NOT NULL,
                [appDBSchemas] [nvarchar](50) NOT NULL,
                [appDBLinksReqd] [nvarchar](50) NULL,
                [appDBGISConnect] [nvarchar](50) NULL,
                [appDBFeaturesReqd] [nvarchar](50) NULL,
                [appDBVersionReqd] [nvarchar](50) NOT NULL,
                [appDBDedicated] [nvarchar](50) NULL,
                [appDBOtherReqd] [nvarchar](50) NULL,
                [appSecAuthMethod] [nvarchar](50) NOT NULL,
                [appSecPermissionMgmt] [nvarchar](50) NOT NULL,
                [appSecSSLReqd] [nvarchar](50) NULL,
                [appSecOtherReqd] [nvarchar](50) NULL,
                [appServerTypeReqd] [nvarchar](50) NOT NULL,
                [appServerOsReqd] [nvarchar](50) NOT NULL,
                [appServerDBReqd] [nvarchar](50) NOT NULL,
                [appServerAppTierReqd] [nvarchar](50) NOT NULL,
                [appServerOtherReqd] [nvarchar](50) NULL,
                [appServerDedicated] [nvarchar](50) NULL,
                [appServerOsAccountsReqd] [nvarchar](50) NOT NULL,
                [appBackupMethod] [nvarchar](50) NOT NULL,
                [appBackupDisasterReqd] [nvarchar](50) NOT NULL,
                [appIntegName] [nvarchar](50) NULL,
                [appIntegLocation] [nvarchar](50) NULL,
                [appIntegMethod] [nvarchar](50) NULL,
                [appIntegFreq] [nvarchar](50) NULL,
                [appIntegSecSSL] [nvarchar](50) NULL,
                [appIntegVPN] [nvarchar](50) NULL,
                [appSfwDependencies] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [changeRequests]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [changeRequests](
                [Id] [int] IDENTITY (1,1) NOT NULL,
                [crNum] [nvarchar](10) NULL,
                [crTitle] [nvarchar](50) NULL,
                [crDetailURL] [nvarchar](170) NULL,
                [crCategory] [nvarchar](35) NULL,
                [crRequestor] [nvarchar](150) NULL,
                [crLastActionDate] [nvarchar](15) NULL,
                [crStatus] [nvarchar](15) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [datacenters]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [datacenters](
                [dcName] [nvarchar](255) NULL,
                [dcPrefix] [nvarchar](255) NULL,
                [dcDesc] [nvarchar](255) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [engagements]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [engagements](
                [engntId] [int] IDENTITY (1,1) NOT NULL,
                [engntAppId] [nvarchar](50) NOT NULL,
                [engntServers] [nvarchar](255) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [history]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history](
                [historyId] [int] IDENTITY (1,1) NOT NULL,
                [hostname] [nvarchar](255) NULL,
                [ipAddr] [nvarchar](255) NULL,
                [rackspaceId] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [hwTypes]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [hwTypes](
                [hwClassName] [nvarchar](50) NULL,
		[hwMfr] [nvarchar](50) NULL,
                [hwType] [nvarchar](50) NULL,
                [hwUSize] [nvarchar](2) NULL
) ON [PRIMARY]
GO
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3550', N'IBM', N'Server', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3650', N'IBM', N'Server', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3650M3', N'IBM', N'Server', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3850', N'IBM', N'Server', N'3')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3850M2', N'IBM', N'Server', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3850X5', N'IBM', N'Server', N'5')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'B50', N'IBM', N'Server', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'BladeCenter H', N'IBM', N'Chassis', N'9')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Catalyst 3750G', N'Cisco', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Catalyst 6509 Switch', N'Cisco', N'Switch', N'15')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Catalyst 6513 Router', N'Cisco', N'Router', N'20')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Celerra NS-960', N'EMC', N'SAN Controller', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Clariion CX3-80', N'EMC', N'SAN Controller', NULL)
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'DS3400', N'IBM', N'SAN Controller', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'DS4300', N'IBM', N'Disk Array', N'3')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'DS9509-EMC', N'Cisco', N'Switch', N'20')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'EMC Full-Rack Disk Array', N'Disk Array', N'40')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'EXP100', N'IBM', N'Disk Array', N'3')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'EXP3000', N'IBM', N'Disk Array', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'BIG-IP', N'F5 Networks', N'Load Balancer', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'HS20', N'IBM', N'Blade', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'HS21', N'IBM', N'Blade', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'HS22', N'IBM', N'Blade', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'IBM 7310', N'IBM', N'HMC', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'IBM 7315', N'IBM', N'HMC', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'JS22', N'IBM', N'Blade', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'MDS 9020', N'Cisco', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'MDS 9120', N'Cisco', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Nexus 2232PP', N'Cisco', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Nexus 2248TP', N'Cisco', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Nexus 5020', N'Cisco', N'Switch', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Nexus 7000', N'Cisco', N'Switch', N'36')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'OPNET Ace Live', N'OPNET', N'Server', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'P5-520', N'IBM', N'Server', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'P5-550', N'IBM', N'Server', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'P5-570', N'IBM', N'Server', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'P620', N'IBM', N'Server', N'20')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'P650', N'IBM', N'Server', N'8')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'P6-550', N'IBM', N'Server', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'KVM/ RSA2/ iDRAC/ iLO/ Remote Console', N'', N'Server', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Virtual', N'', N'Server', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'x346', N'IBM', N'Server', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'x3576 Tape Library', N'IBM', N'Tape Library', N'14')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'x3582 Tape Library', N'IBM', N'Tape Library', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'x366', N'IBM', N'Server', N'3')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Server Console', N'Generic', N'KVM', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Blade Server', N'Generic', N'Server', N'0')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'Blade Chassis', N'Generic', N'Chassis', N'10')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'1U Server', N'Generic', N'Server', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'2U Server', N'Generic', N'Server', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'3U Server', N'Generic', N'Server', N'3')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'4U Server', N'Generic', N'Server', N'4')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'5U Server', N'Generic', N'Server', N'5')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'8-Port Ethernet Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'12-Port Ethernet Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'16-Port Ethernet Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'24-Port Ethernet Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'48-Port Ethernet Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'8-Port FibreChan Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'12-Port FibreChan Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'16-Port FibreChan Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'24-Port FibreChan Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'48-Port FibreChan Switch', N'Generic', N'Switch', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'1U Router', N'Generic', N'Router', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'2U Router', N'Generic', N'Router', N'2')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'8-Port Ethernet Hub', N'Generic', N'Hub', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'12-Port Ethernet Hub', N'Generic', N'Hub', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'16-Port Ethernet Hub', N'Generic', N'Hub', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'24-Port Ethernet Hub', N'Generic', N'Hub', N'1')
INSERT INTO [hwTypes]([hwClassName], [hwMfr], [hwType], [hwUSize]) VALUES (N'48-Port Ethernet Hub', N'Generic', N'Hub', N'1')
GO

/****** Object:  Table [reports]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports](
                [reportId] [int] IDENTITY (1,1) NOT NULL,
                [reportName] [nvarchar](50) NULL,
                [reportFile] [nvarchar](255) NULL,
                [addedBy] [nvarchar](50) NULL,
                [reportDesc] [nvarchar](max) NULL,
                [reportCategory] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [software]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [software](
                [sfwId] [int] IDENTITY (1,1) NOT NULL,
                [sfwName] [nvarchar](50) NOT NULL,
                [sfwClass] [nvarchar](50) NOT NULL,
                [sfwOS] [nvarchar](50) NOT NULL,
                [reqdSfwId] [nvarchar](50) NULL
) ON [PRIMARY]
GO
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'IBM AIX 5.3', N'OS', N'AIX', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2003 Server 32-Bit Standard Edition', N'OS', N'Windows', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2003 Server 32-Bit Enterprise Edition', N'OS', N'Windows', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2003 Server 64-Bit Standard Edition', N'OS', N'Windows', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2003 Server 64-Bit Enterprise Edition', N'OS', N'Windows', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows XP Professional Laptop-Build', N'OS', N'Windows', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows XP Professional Desktop-Build', N'OS', N'Windows', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2008 Server Standard Edition', N'OS', N'Windows', N'')
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2008 Server x64 Standard Edition', N'OS', N'Windows', N'')
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2008 Server Enterprise Edition', N'OS', N'Windows', N'')
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2008 Server x64 Enterprise Edition', N'OS', N'Windows', N'')
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2008 Server R2 Standard Edition', N'OS', N'Windows', N'')
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'Microsoft Windows 2008 Server R2 Enterprise Edition', N'OS', N'Windows', N'')
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 9 SP3 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 9 SP3 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 9 SP4 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 9 SP4 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 10 SP2 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 10 SP2 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 10 SP3 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'SUSE Linux 10 SP3 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 4', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.3 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.3 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.5 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.5 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.6 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.6 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.7 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.7 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.8 32-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'RHEL Linux 5.8 64-Bit', N'OS', N'Linux', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'VMWare ESX 3.0', N'OS', N'ESX', NULL)
INSERT INTO [software]([sfwName], [sfwClass], [sfwOS], [reqdSfwId]) VALUES (N'VMWare ESX 3.5', N'OS', N'ESX', NULL)
GO

/****** Object:  Table [sysStat]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sysStat](
                [id] [int] IDENTITY (1,1) NOT NULL,
                [code] [nvarchar](50) NULL,
                [userid] [nvarchar](50) NULL,
                [dateStamp] [nvarchar](50) NULL,
                [comment] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [tickets]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tickets](
                [ticketId] [int] IDENTITY (1,1) NOT NULL,
                [parentProject] [int] NOT NULL,
                [ticketServer] [nvarchar](50) NOT NULL,
                [ticketSfw] [int] NULL,
                [ticketDateTime] [nvarchar](50) NOT NULL,
                [ticketClass] [nvarchar](50) NOT NULL,
                [ticketEnteredBy] [nvarchar](50) NOT NULL,
                [ticketTitle] [nvarchar](50) NULL,
                [ticketComments] [nvarchar](max) NOT NULL,
                [ticketPriority] [nvarchar](50) NULL,
                [ticketStatus] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [userRoles]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [userRoles](
                [roleValue] [nvarchar](255) NULL,
                [roleName] [nvarchar](255) NULL,
                [roleGroup] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'ads', N'Active Directory', N'Domain Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'aix', N'Admin: AIX', N'UNIX_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'citrix', N'Citrix', N'Citrix_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'datacenter', N'Datacenter', N'KVM_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'deploy_lin', N'Deployment: Linux', N'UNIX_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'deploy_win', N'Deployment: Windows', N'OSD_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'dns', N'DNS', N'DNS_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'efs', N'EFS/GFPS/DFS', N'EFS_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'kdc', N'Kerberos(KDC)', N'KDC_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'linux', N'Admin: Linux', N'UNIX_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'manager', N'Manager', N'')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'mssql', N'MS-SQL', N'MSSQL_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'network', N'Network', N'')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'oras', N'Oracle: AS', N'ORAS_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'ordb', N'Oracle: DB', N'ORDB_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'project', N'Project', N'')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'san', N'SAN', N'SAN_Admins')
INSERT INTO [userRoles]([roleValue], [roleName], [roleGroup]) VALUES (N'windows', N'Admin: Windows', N'WIN_Admins')
GO

/****** Object:  Table [users]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [users](
                [userId] [nvarchar](50) NULL,
                [userFirstName] [nvarchar](50) NULL,
                [userLastName] [nvarchar](50) NULL,
                [userOfficePhone] [nvarchar](50) NULL,
                [userRole] [nvarchar](100) NULL,
                [email] [nvarchar](50) NULL,
                [defaultDC] [nvarchar](max) NULL
) ON [PRIMARY]
GO





















