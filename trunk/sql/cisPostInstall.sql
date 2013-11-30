/****** Object:  Table [switches]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [switches](
                [switchName] [nvarchar](50) NULL,
                [description] [nvarchar](50) NULL,
                [rackspaceId] [int] NULL,
                [media] [nvarchar](50) NULL
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

/****** Object:  Table [snapshots]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [snapshots](
                [Id] [int] IDENTITY (1,1) NOT NULL,
                [snapId] [nvarchar](255) NULL,
                [vmName] [nvarchar](255) NULL,
                [snapDesc] [nvarchar](max) NULL,
                [created] [nvarchar](50) NULL,
                [sizeOnDisk] [real] NULL
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
                [VMId] [nvarchar](255) NULL,
                [VMToolsState] [nvarchar](25) NULL,
                [VMPowerState] [nvarchar](25) NULL,
                [VMToolsVersion] [int] NULL,
                [VMSysDiskPath] [nvarchar](25) NULL,
                [VMDataDiskPath] [nvarchar](50) NULL,
                [VMSysDiskCapMB] [real] NULL,
                [VMDataDiskCapMB] [real] NULL,
                [VMSysDiskFreeMB] [real] NULL,
                [VMDataDiskFreeMB] [real] NULL,
                [dependsOn] [nvarchar](max) NULL,
                [isDependedOnBy] [nvarchar](max) NULL,
                [serverBuildDate] [nvarchar](50) NULL,
                [serverLastRebootDate] [nvarchar](50) NULL,
                [VMName] [nvarchar](255) NULL
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
                [VMDatastore] [nvarchar](255) NULL,
                [VMHost] [nvarchar](255) NULL,
                [sys_disk_free] [real] NULL,
                [data_disk_free] [real] NULL,
                [biosVer] [nvarchar](255) NULL
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
INSERT INTO [racks]([rackId], [uMin], [uMax], [location]) VALUES (N'0000', N'0', N'999', N'DEFAULT')

/****** Object:  Table [datastores]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [datastores](
                [Id] [int] IDENTITY (1,1) NOT NULL,
                [name] [nvarchar](255) NULL,
                [capacityMB] [int] NULL,
                [freespaceMB] [int] NULL,
                [inUse] [int] NULL
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

/****** Object:  Table [bladeChassis]    Script Date: 02/21/2013 16:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bladeChassis](
                [rackspaceId] [int] NULL,
                [ethernetType] [nvarchar](50) NULL,
                [bc] [nvarchar](50) NULL
) ON [PRIMARY]
GO
