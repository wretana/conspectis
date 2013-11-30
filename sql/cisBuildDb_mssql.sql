USE [conspectis-db]
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
                [defaultDC] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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

/****** Object:  Table [switches]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [switches](
                [switchName] [nvarchar](50) NULL,
                [description] [nvarchar](50) NULL,
                [rackspaceId] [int] NULL,
                [media] [nvarchar](max) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [subnets]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [subnets](
                [name] [nvarchar](50) NULL,
                [desc] [nvarchar](50) NULL,
                [vlanId] [nvarchar](50) NULL
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

/****** Object:  Table [snapshots]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [snapshots](
                [Id] [int] NOT NULL,
                [snapId] [nvarchar](max) NULL,
                [vmName] [nvarchar](max) NULL,
                [snapDesc] [nvarchar](max) NULL,
                [created] [nvarchar](max) NULL,
                [sizeOnDisk] [real] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [budgetRequests]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [budgetRequests](
                [Id] [int] IDENTITY (1,1) NOT NULL,
                [brNum] [nvarchar](10) NULL,
                [brTitle] [nvarchar](50) NULL,
                [brDetailURL] [nvarchar](170) NULL,
                [brCategory] [nvarchar](35) NULL,
                [brRequestor] [nvarchar](150) NULL,
                [brLastActionDate] [nvarchar](15) NULL,
                [brStatus] [nvarchar](15) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [servers]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [servers](
                [serverName] [nvarchar](255) NULL,
                [serverRsaIp] [nvarchar](255) NULL,
                [serverLanIp] [nvarchar](255) NULL,
                [serverSvcIp] [nvarchar](255) NULL,
                [serverOS] [nvarchar](255) NULL,
                [serverOsBuild] [int] NULL,
                [serverPurpose] [nvarchar](255) NULL,
                [serverPubVlan] [nvarchar](50) NULL,
                [rackspaceId] [int] NULL,
                [memberOfCluster] [nvarchar](50) NULL,
                [usingSAN] [tinyint] NULL,
                [infra] [tinyint] NULL,
                [role] [nvarchar](60) NULL,
                [VMId] [nvarchar](max) NULL,
                [VMToolsState] [nvarchar](max) NULL,
                [VMPowerState] [nvarchar](max) NULL,
                [VMToolsVersion] [int] NULL,
                [VMSysDiskPath] [nvarchar](max) NULL,
                [VMDataDiskPath] [nvarchar](max) NULL,
                [VMSysDiskCapMB] [real] NULL,
                [VMDataDiskCapMB] [real] NULL,
                [VMSysDiskFreeMB] [real] NULL,
                [VMDataDiskFreeMB] [real] NULL,
                [dependsOn] [nvarchar](max) NULL,
                [isDependedOnBy] [nvarchar](max) NULL,
                [serverBuildDate] [nvarchar](max) NULL,
                [serverLastRebootDate] [nvarchar](max) NULL,
                [VMName] [nvarchar](255) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [reports]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports](
                [reportId] [int] IDENTITY (1,1) NOT NULL,
                [reportName] [nvarchar](255) NULL,
                [reportFile] [nvarchar](255) NULL,
                [addedBy] [nvarchar](255) NULL,
                [reportDesc] [nvarchar](max) NULL,
                [reportCategory] [nvarchar](max) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [rackspace]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rackspace](
                [rackspaceId] [int] IDENTITY (1,1) NOT NULL,
                [rack] [nvarchar](255) NULL,
                [bc] [nvarchar](255) NULL,
                [slot] [nvarchar](255) NULL,
                [reserved] [nvarchar](255) NULL,
                [class] [nvarchar](255) NULL,
                [serial] [nvarchar](255) NULL,
                [model] [nvarchar](255) NULL,
                [cpu_qty] [tinyint] NULL,
                [cpu_cores] [tinyint] NULL,
                [cpu_type] [nvarchar](255) NULL,
                [ram] [real] NULL,
                [sys_disk_qty] [tinyint] NULL,
                [sys_disk_size] [smallint] NULL,
                [data_disk_qty] [tinyint] NULL,
                [data_disk_size] [smallint] NULL,
                [eth0mac] [nvarchar](255) NULL,
                [eth1mac] [nvarchar](255) NULL,
                [hba0wwn] [nvarchar](255) NULL,
                [hba1wwn] [nvarchar](255) NULL,
                [sanAttached] [nvarchar](255) NULL,
                [belongsTo] [nvarchar](50) NULL,
                [VMDatastore] [nvarchar](max) NULL,
                [VMHost] [nvarchar](max) NULL,
                [sys_disk_free] [real] NULL,
                [data_disk_free] [real] NULL,
                [biosVer] [nvarchar](max) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [racks]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [racks](
                [rackId] [nvarchar](4) NULL,
                [uMin] [nvarchar](3) NULL,
                [uMax] [nvarchar](3) NULL,
                [location] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [hwTypes]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [hwTypes](
                [hwClassName] [nvarchar](50) NULL,
                [hwType] [nvarchar](50) NULL,
                [hwUSize] [nvarchar](2) NULL
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

/****** Object:  Table [engagements]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [engagements](
                [engntId] [int] NOT NULL,
                [engntAppId] [nvarchar](50) NOT NULL,
                [engntServer1] [nvarchar](50) NOT NULL,
                [engntServer2] [nvarchar](50) NULL,
                [engntServer3] [nvarchar](50) NULL,
                [engntServer4] [nvarchar](50) NULL,
                [engntServer5] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [datastores]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [datastores](
                [Id] [int] NOT NULL,
                [name] [nvarchar](max) NULL,
                [capacityMB] [int] NULL,
                [freespaceMB] [int] NULL,
                [inUse] [int] NULL
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

/****** Object:  Table [clusters]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [clusters](
                [clusterName] [nvarchar](50) NULL,
                [clusterType] [nvarchar](50) NULL,
                [clusterPurpose] [nvarchar](50) NULL,
                [clusterLanIp] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [bladeCenters]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bladeCenters](
                [rackspaceId] [int] NULL,
                [ethernetType] [nvarchar](50) NULL,
                [bc] [nvarchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [application]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [application](
                [appId] [int] NOT NULL,
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