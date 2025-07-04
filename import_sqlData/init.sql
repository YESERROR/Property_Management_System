-- 创建数据库（如果不存在）
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = '[PM_DataBase]')
BEGIN
    CREATE DATABASE [PM_DataBase];
    PRINT 'Database [PM_DataBase] created.';
END
GO
-- 开始执行
USE [PM_DataBase]
GO
/****** Object:  Schema [db]    Script Date: 2025/6/19 14:26:18 ******/
CREATE SCHEMA [db]
GO
/****** Object:  UserDefinedFunction [db].[CheckArea]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckArea](@value VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN @value>60 AND @value<400
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [db].[CheckEmail]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckEmail](@Email VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN @Email LIKE '%_@%_.%__%'
             AND @Email NOT LIKE '%[^a-zA-Z0-9@._-]%'
             AND @Email NOT LIKE '%@%@%'
             AND CHARINDEX('.', @Email, CHARINDEX('@', @Email)) > CHARINDEX('@', @Email) + 1
             AND CHARINDEX('.', REVERSE(@Email)) >= 2
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [db].[CheckIdcard]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckIdcard](@value VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN len(@value)=18 AND
             NOT left(@value,17)
             like '%[^0-9]%'
             AND right(@value,1) like '[0-9Xx]'
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [db].[CheckName]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckName](@str VARCHAR(255))
RETURNS BIT
AS
BEGIN
      DECLARE @i INT = 1
    DECLARE @len INT = LEN(@str)
    DECLARE @result BIT = 1

    IF @len < 2 RETURN 0

    WHILE @i <= @len
    BEGIN
        IF UNICODE(SUBSTRING(@str, @i, 1)) NOT BETWEEN 19968 AND 40869
        BEGIN
            SET @result = 0
            BREAK
        END
        SET @i = @i + 1
    END

    RETURN @result
END
GO
/****** Object:  UserDefinedFunction [db].[CheckProperty_Type]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckProperty_Type](@value VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN @value='住宅' OR @value='商铺' OR @value='车位'
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [db].[CheckRole]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckRole](@value VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN @value='admin' OR @value='user' OR @value='repair'
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [db].[CheckRoomNumber]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckRoomNumber](@value VARCHAR(50))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN @value <1500 and @value >100
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [db].[CheckTelephone]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [db].[CheckTelephone](@value VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN len(@value)=11 AND @value like '1[3-9]%' AND NOT @value like '%[^0-9]%'
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_IsValidEmail]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_IsValidEmail](@Email VARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN @Email LIKE '%_@%_.%__%'
             AND @Email NOT LIKE '%[^a-zA-Z0-9@._-]%'
             AND @Email NOT LIKE '%@%@%'
             AND CHARINDEX('.', @Email, CHARINDEX('@', @Email)) > CHARINDEX('@', @Email) + 1
             AND CHARINDEX('.', REVERSE(@Email)) >= 2
        THEN 1
        ELSE 0
    END
END
GO
/****** Object:  Table [db].[apply_user]    Script Date: 2025/6/19 14:26:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[apply_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](100) NOT NULL,
	[password] [varchar](100) NOT NULL,
	[role] [varchar](50) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[telephone] [bigint] NOT NULL,
	[IDCard] [bigint] NOT NULL,
	[Property_Type] [varchar](10) NOT NULL,
	[BuildingNo] [int] NOT NULL,
	[RoomNo] [int] NOT NULL,
	[Area] [int] NOT NULL,
 CONSTRAINT [PK__apply_us__3213E83FD538352F] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Fee_Detail]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Fee_Detail](
	[DetailID] [int] IDENTITY(11000,1) NOT NULL,
	[BillID] [int] NOT NULL,
	[FeeType] [varchar](20) NOT NULL,
	[Calculation] [varchar](100) NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL,
 CONSTRAINT [Fee_Detail_pk] PRIMARY KEY CLUSTERED 
(
	[DetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Fee_Standard]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Fee_Standard](
	[StandardID] [int] IDENTITY(5897,1) NOT NULL,
	[PropertyType] [varchar](20) NOT NULL,
	[FreeType] [varchar](70) NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Property_name] [varchar](50) NOT NULL,
 CONSTRAINT [Fee_Standard_pk] PRIMARY KEY CLUSTERED 
(
	[StandardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Notice]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Notice](
	[Notice_name] [varchar](50) NOT NULL,
	[Notice_date] [date] NOT NULL,
	[Notice_Content] [varchar](500) NOT NULL,
	[NoticeID] [int] IDENTITY(2568,1) NOT NULL,
 CONSTRAINT [Notice_pk] PRIMARY KEY CLUSTERED 
(
	[NoticeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Payment_Record]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Payment_Record](
	[PaymentID] [int] NOT NULL,
	[BillID] [int] NOT NULL,
	[PaymentAmount] [decimal](10, 2) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[PaymentMethod] [varchar](20) NOT NULL,
 CONSTRAINT [Payment_Record_pk] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Property_Fee_Bill]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Property_Fee_Bill](
	[BillID] [int] IDENTITY(8000,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[BillingCycle] [date] NOT NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[GenerateDate] [date] NOT NULL,
	[DueDate] [date] NOT NULL,
 CONSTRAINT [Property_Fee_Bill_pk] PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Property_Info]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Property_Info](
	[PropertyID] [int] IDENTITY(4058,1) NOT NULL,
	[OwnerID] [int] NOT NULL,
	[BuildingNo] [varchar](10) NOT NULL,
	[RoomNo] [varchar](10) NOT NULL,
	[Area] [decimal](10, 2) NOT NULL,
	[PropertyType] [varchar](10) NOT NULL,
 CONSTRAINT [Property_Info_pk] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[Repair_Order]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[Repair_Order](
	[OrderID] [int] IDENTITY(2384,1) NOT NULL,
	[ReporterID] [int] NOT NULL,
	[RepairType] [varchar](20) NOT NULL,
	[Title] [varchar](20) NOT NULL,
	[Description] [text] NULL,
	[Urgency] [tinyint] NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[ExpectedTime] [date] NULL,
	[ActualFinishTime] [datetime] NULL,
 CONSTRAINT [Repair_Order_pk] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [db].[token_blacklist]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[token_blacklist](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[jti] [nvarchar](36) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[expires_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[User]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](100) NULL,
	[password] [varchar](100) NULL,
	[role] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [db].[User_info]    Script Date: 2025/6/19 14:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db].[User_info](
	[id] [int] NOT NULL,
	[telephone] [bigint] NOT NULL,
	[id_card] [bigint] NOT NULL,
	[name] [nvarchar](20) NOT NULL,
 CONSTRAINT [User_info_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [db].[apply_user] ON 

INSERT [db].[apply_user] ([id], [username], [password], [role], [name], [telephone], [IDCard], [Property_Type], [BuildingNo], [RoomNo], [Area]) VALUES (4, N'1545869750@qq.com', N'xK5#wW7%cV9&123', N'user', N'陈铭超', 13657489573, 312254899574858745, N'住宅', 309, 202, 80)
INSERT [db].[apply_user] ([id], [username], [password], [role], [name], [telephone], [IDCard], [Property_Type], [BuildingNo], [RoomNo], [Area]) VALUES (11, N'2415095013@qq.com', N'12312312@33ASDFsdf', N'admin', N'大卫大卫', 15280217244, 123345677898554561, N'住宅', 121, 202, 100)
SET IDENTITY_INSERT [db].[apply_user] OFF
GO
SET IDENTITY_INSERT [db].[Fee_Standard] ON 

INSERT [db].[Fee_Standard] ([StandardID], [PropertyType], [FreeType], [UnitPrice], [StartDate], [EndDate], [Property_name]) VALUES (5898, N'住宅', N'公摊', CAST(90.00 AS Decimal(10, 2)), CAST(N'2025-06-11' AS Date), CAST(N'2025-07-24' AS Date), N'海涛飞机杯')
INSERT [db].[Fee_Standard] ([StandardID], [PropertyType], [FreeType], [UnitPrice], [StartDate], [EndDate], [Property_name]) VALUES (5899, N'住宅', N'公摊', CAST(100.00 AS Decimal(10, 2)), CAST(N'2025-05-05' AS Date), CAST(N'2025-05-18' AS Date), N'管理费')
INSERT [db].[Fee_Standard] ([StandardID], [PropertyType], [FreeType], [UnitPrice], [StartDate], [EndDate], [Property_name]) VALUES (5900, N'店面', N'公摊', CAST(3000.00 AS Decimal(10, 2)), CAST(N'2025-05-23' AS Date), CAST(N'2025-05-16' AS Date), N'海涛嫖娼费用')
INSERT [db].[Fee_Standard] ([StandardID], [PropertyType], [FreeType], [UnitPrice], [StartDate], [EndDate], [Property_name]) VALUES (6900, N'住宅', N'公摊', CAST(1.00 AS Decimal(10, 2)), CAST(N'2025-05-04' AS Date), CAST(N'2025-05-11' AS Date), N'111')
SET IDENTITY_INSERT [db].[Fee_Standard] OFF
GO
SET IDENTITY_INSERT [db].[Notice] ON 

INSERT [db].[Notice] ([Notice_name], [Notice_date], [Notice_Content], [NoticeID]) VALUES (N'公告', CAST(N'2025-05-25' AS Date), N'<h2><strong>颜海</strong><strong style="background-color: rgb(250, 204, 204);">涛失恋了</strong></h2>', 3570)
INSERT [db].[Notice] ([Notice_name], [Notice_date], [Notice_Content], [NoticeID]) VALUES (N'公告', CAST(N'2025-05-25' AS Date), N'<h2>111111</h2>', 3571)
INSERT [db].[Notice] ([Notice_name], [Notice_date], [Notice_Content], [NoticeID]) VALUES (N'公告', CAST(N'2025-05-28' AS Date), N'<h2><strong style="background-color: rgb(255, 255, 0);">123123123</strong></h2>', 3572)
SET IDENTITY_INSERT [db].[Notice] OFF
GO
SET IDENTITY_INSERT [db].[Property_Fee_Bill] ON 

INSERT [db].[Property_Fee_Bill] ([BillID], [PersonID], [BillingCycle], [TotalAmount], [Status], [GenerateDate], [DueDate]) VALUES (8000, 2, CAST(N'2025-05-20' AS Date), CAST(1000.00 AS Decimal(10, 2)), N'未缴费', CAST(N'2025-05-20' AS Date), CAST(N'2026-05-19' AS Date))
INSERT [db].[Property_Fee_Bill] ([BillID], [PersonID], [BillingCycle], [TotalAmount], [Status], [GenerateDate], [DueDate]) VALUES (8001, 1, CAST(N'2025-05-14' AS Date), CAST(7800.00 AS Decimal(10, 2)), N'已缴费', CAST(N'2025-05-24' AS Date), CAST(N'2025-05-10' AS Date))
INSERT [db].[Property_Fee_Bill] ([BillID], [PersonID], [BillingCycle], [TotalAmount], [Status], [GenerateDate], [DueDate]) VALUES (8002, 1, CAST(N'2025-05-23' AS Date), CAST(78.00 AS Decimal(10, 2)), N'未缴费', CAST(N'2025-05-26' AS Date), CAST(N'2025-05-15' AS Date))
INSERT [db].[Property_Fee_Bill] ([BillID], [PersonID], [BillingCycle], [TotalAmount], [Status], [GenerateDate], [DueDate]) VALUES (8003, 2, CAST(N'2025-05-23' AS Date), CAST(89.00 AS Decimal(10, 2)), N'未缴费', CAST(N'2025-05-26' AS Date), CAST(N'2025-05-15' AS Date))
INSERT [db].[Property_Fee_Bill] ([BillID], [PersonID], [BillingCycle], [TotalAmount], [Status], [GenerateDate], [DueDate]) VALUES (8004, 3, CAST(N'2025-05-23' AS Date), CAST(116.00 AS Decimal(10, 2)), N'未缴费', CAST(N'2025-05-26' AS Date), CAST(N'2025-05-15' AS Date))
SET IDENTITY_INSERT [db].[Property_Fee_Bill] OFF
GO
SET IDENTITY_INSERT [db].[Property_Info] ON 

INSERT [db].[Property_Info] ([PropertyID], [OwnerID], [BuildingNo], [RoomNo], [Area], [PropertyType]) VALUES (4058, 1, N'309', N'203', CAST(78.00 AS Decimal(10, 2)), N'住宅')
INSERT [db].[Property_Info] ([PropertyID], [OwnerID], [BuildingNo], [RoomNo], [Area], [PropertyType]) VALUES (4059, 2, N'404', N'801', CAST(89.00 AS Decimal(10, 2)), N'住宅')
INSERT [db].[Property_Info] ([PropertyID], [OwnerID], [BuildingNo], [RoomNo], [Area], [PropertyType]) VALUES (4060, 3, N'307', N'501', CAST(116.00 AS Decimal(10, 2)), N'住宅')
INSERT [db].[Property_Info] ([PropertyID], [OwnerID], [BuildingNo], [RoomNo], [Area], [PropertyType]) VALUES (4063, 5, N'333', N'234', CAST(101.00 AS Decimal(10, 2)), N'商铺')
INSERT [db].[Property_Info] ([PropertyID], [OwnerID], [BuildingNo], [RoomNo], [Area], [PropertyType]) VALUES (4069, 15, N'123', N'123', CAST(100.00 AS Decimal(10, 2)), N'住宅')
SET IDENTITY_INSERT [db].[Property_Info] OFF
GO
SET IDENTITY_INSERT [db].[Repair_Order] ON 

INSERT [db].[Repair_Order] ([OrderID], [ReporterID], [RepairType], [Title], [Description], [Urgency], [Status], [CreateTime], [ExpectedTime], [ActualFinishTime]) VALUES (2384, 1, N'测试', N'测试', N'测试', 1, N'已完成', CAST(N'2025-05-26T15:16:22.000' AS DateTime), CAST(N'2025-05-26' AS Date), CAST(N'2025-05-26T15:16:26.000' AS DateTime))
INSERT [db].[Repair_Order] ([OrderID], [ReporterID], [RepairType], [Title], [Description], [Urgency], [Status], [CreateTime], [ExpectedTime], [ActualFinishTime]) VALUES (2390, 1, N'水电', N'flag位置', N'flag在/flllllaaaaag中', 1, N'已完成', CAST(N'2025-05-26T15:52:40.000' AS DateTime), CAST(N'2025-05-22' AS Date), CAST(N'2025-05-26T15:54:00.000' AS DateTime))
SET IDENTITY_INSERT [db].[Repair_Order] OFF
GO
SET IDENTITY_INSERT [db].[token_blacklist] ON 

INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (1, N'072fd985-eb96-4e83-a33a-fb946f8f892f', CAST(N'2025-05-18T10:59:48.3213120' AS DateTime2), CAST(N'2025-05-18T11:59:48.3192950' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (2, N'9d55dad8-47d5-4fee-8979-827602c71312', CAST(N'2025-05-18T11:07:15.6786680' AS DateTime2), CAST(N'2025-05-18T12:07:15.6765580' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (3, N'8e58f623-e196-471f-8f2b-f770ca3fe875', CAST(N'2025-05-18T11:08:26.0862680' AS DateTime2), CAST(N'2025-05-18T12:08:26.0852660' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (4, N'1abfc595-ab6f-4234-92ea-6b188fc3b19a', CAST(N'2025-05-18T14:04:37.8033700' AS DateTime2), CAST(N'2025-05-18T15:04:37.7694500' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (5, N'a2445502-a7af-48d6-a5ff-0bb85621a73a', CAST(N'2025-05-18T14:05:06.1252970' AS DateTime2), CAST(N'2025-05-18T15:05:06.1252970' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (6, N'fe035fcb-6863-4b74-9c0e-d9e673d8f929', CAST(N'2025-05-19T18:20:33.9383680' AS DateTime2), CAST(N'2025-05-19T19:20:33.9358200' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (7, N'874b127b-fdba-41be-a9b0-7e276935706e', CAST(N'2025-05-21T10:13:18.2941100' AS DateTime2), CAST(N'2025-05-21T11:13:18.2910420' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (8, N'32d2f74a-0c00-4cb2-abea-3be3baacf178', CAST(N'2025-05-21T10:14:02.2316490' AS DateTime2), CAST(N'2025-05-21T11:14:02.2306330' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (9, N'bf0894c4-1c16-43a2-8b59-d27d806f3b3a', CAST(N'2025-05-21T10:30:10.6565840' AS DateTime2), CAST(N'2025-05-21T11:30:10.6552850' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (10, N'425298ed-8800-4983-9d3e-c6f36dfff227', CAST(N'2025-05-21T10:43:20.9463310' AS DateTime2), CAST(N'2025-05-21T11:43:20.9453290' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (11, N'aff07cf4-4766-4247-9227-725b94d37b09', CAST(N'2025-05-22T07:59:20.7751110' AS DateTime2), CAST(N'2025-05-22T08:59:20.7735430' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (12, N'61599246-d2bf-4245-9152-f640df5a553a', CAST(N'2025-05-22T13:33:57.9416720' AS DateTime2), CAST(N'2025-05-22T14:33:57.9400710' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (13, N'b35deaf9-6453-42bd-8ccc-132561989779', CAST(N'2025-05-25T13:10:14.9499580' AS DateTime2), CAST(N'2025-05-25T14:10:14.9465440' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (14, N'f47aead3-1f5b-43bb-bb7d-033a179d7aaf', CAST(N'2025-05-25T13:11:52.5239000' AS DateTime2), CAST(N'2025-05-25T14:11:52.5218830' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (15, N'52aa568b-d38a-4612-9fc6-0a5e7401a849', CAST(N'2025-05-25T13:15:05.1292350' AS DateTime2), CAST(N'2025-05-25T14:15:05.1268070' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (16, N'ed9fc4d0-d5dd-42b3-80d0-244483b14703', CAST(N'2025-05-25T13:15:09.7146450' AS DateTime2), CAST(N'2025-05-25T14:15:09.7134990' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (17, N'396a8ff4-bc7f-4b0a-b64a-be63c71e3bf5', CAST(N'2025-05-25T15:29:58.0126420' AS DateTime2), CAST(N'2025-05-25T16:29:58.0072780' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (18, N'f79137bf-75f2-49c5-a13b-fda12d1d106d', CAST(N'2025-05-26T01:57:03.7063620' AS DateTime2), CAST(N'2025-05-26T02:57:03.7043450' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (19, N'a8d8b2ac-05d7-4ac7-b07c-08f2e22195b6', CAST(N'2025-05-26T01:59:11.7182130' AS DateTime2), CAST(N'2025-05-26T02:59:11.7182130' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (20, N'95bc4dc4-8f8f-4e8c-828c-a596beab5bcb', CAST(N'2025-05-26T03:11:21.9337250' AS DateTime2), CAST(N'2025-05-26T04:11:21.9337250' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (21, N'1691bd73-4602-42cf-8b3d-9e59724bd149', CAST(N'2025-05-26T03:17:44.3375830' AS DateTime2), CAST(N'2025-05-26T04:17:44.3354760' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (22, N'22033f12-ec5d-46d7-9b55-5f2212d635c8', CAST(N'2025-05-26T04:23:42.6232470' AS DateTime2), CAST(N'2025-05-26T05:23:42.6199160' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (23, N'2f100ddd-8b14-4061-8b7f-e0c156d6c3c4', CAST(N'2025-05-26T04:25:29.7214430' AS DateTime2), CAST(N'2025-05-26T05:25:29.7208780' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (24, N'452b750b-175f-422c-b58c-3b2ddafdd166', CAST(N'2025-05-26T04:30:56.6619770' AS DateTime2), CAST(N'2025-05-26T05:30:56.6619770' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (25, N'c537eb36-e4e5-4ea1-9334-5d7e1ef890ae', CAST(N'2025-05-26T08:04:15.7072930' AS DateTime2), CAST(N'2025-05-26T09:04:15.7047510' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (26, N'f8ddc026-9cef-4f07-b384-4e0ba2a48577', CAST(N'2025-05-26T08:13:40.4605640' AS DateTime2), CAST(N'2025-05-26T09:13:40.4585470' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (27, N'07685f15-d189-4e1e-b987-9cf5ab78e9e3', CAST(N'2025-05-26T08:13:47.4969220' AS DateTime2), CAST(N'2025-05-26T09:13:47.4969220' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (28, N'183ded99-5053-45ef-b9ec-db4fd3c73616', CAST(N'2025-05-26T09:26:33.6734660' AS DateTime2), CAST(N'2025-05-26T10:26:33.6712400' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (29, N'99528f80-e498-4e48-a633-bf23d80afd28', CAST(N'2025-05-26T10:15:40.2050900' AS DateTime2), CAST(N'2025-05-26T11:15:40.2050900' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (30, N'1c93a40a-8fd7-4140-ad6f-00573b5d229d', CAST(N'2025-05-28T07:05:16.8933170' AS DateTime2), CAST(N'2025-05-28T10:25:16.8933170' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (31, N'9335757f-f972-43a6-ad30-66a133b2acf7', CAST(N'2025-05-28T07:09:04.4265610' AS DateTime2), CAST(N'2025-05-28T10:29:04.4265610' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (32, N'7b3b3ad1-b6f2-4fb9-a968-dd43f331b804', CAST(N'2025-05-28T09:01:00.6571060' AS DateTime2), CAST(N'2025-05-28T12:21:00.6555540' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (33, N'efd80a6a-304e-48d2-bdd1-b30a8b7abb6a', CAST(N'2025-05-28T09:24:31.0015000' AS DateTime2), CAST(N'2025-05-28T12:44:31.0015000' AS DateTime2))
INSERT [db].[token_blacklist] ([id], [jti], [created_at], [expires_at]) VALUES (34, N'abb86db1-159c-44be-9737-f2e39034a390', CAST(N'2025-05-29T09:31:58.2040870' AS DateTime2), CAST(N'2025-05-29T12:51:58.2025330' AS DateTime2))
SET IDENTITY_INSERT [db].[token_blacklist] OFF
GO
SET IDENTITY_INSERT [db].[User] ON 

INSERT [db].[User] ([id], [username], [password], [role]) VALUES (1, N'1545869750@qq.com', N'123456', N'admin')
INSERT [db].[User] ([id], [username], [password], [role]) VALUES (2, N'123456@qq.com', N'123456', N'user     ')
INSERT [db].[User] ([id], [username], [password], [role]) VALUES (3, N'584685@nysec.xyz', N'123456', N'repair')
INSERT [db].[User] ([id], [username], [password], [role]) VALUES (5, N'5842343685@nysec.xyz', N'123456789', N'admin')
INSERT [db].[User] ([id], [username], [password], [role]) VALUES (15, N'12313123123@qq.com', N'1231232', N'admin')
SET IDENTITY_INSERT [db].[User] OFF
GO
INSERT [db].[User_info] ([id], [telephone], [id_card], [name]) VALUES (1, 15389457331, 365545522612555412, N'颜海涛')
INSERT [db].[User_info] ([id], [telephone], [id_card], [name]) VALUES (2, 13459247698, 356612522556455142, N'马牛逼              ')
INSERT [db].[User_info] ([id], [telephone], [id_card], [name]) VALUES (3, 19875462453, 425455895136523652, N'撸老师              ')
INSERT [db].[User_info] ([id], [telephone], [id_card], [name]) VALUES (5, 14585245122, 565656565656565655, N'颜史蒂')
INSERT [db].[User_info] ([id], [telephone], [id_card], [name]) VALUES (15, 15280217244, 513427200809093610, N'段嘉许')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [apply_user_username]    Script Date: 2025/6/19 14:26:19 ******/
ALTER TABLE [db].[apply_user] ADD  CONSTRAINT [apply_user_username] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__token_bl__DC9086431CDB788B]    Script Date: 2025/6/19 14:26:19 ******/
ALTER TABLE [db].[token_blacklist] ADD UNIQUE NONCLUSTERED 
(
	[jti] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__token_bl__DC908643E8EB56A1]    Script Date: 2025/6/19 14:26:19 ******/
ALTER TABLE [db].[token_blacklist] ADD UNIQUE NONCLUSTERED 
(
	[jti] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [User_pk]    Script Date: 2025/6/19 14:26:19 ******/
ALTER TABLE [db].[User] ADD  CONSTRAINT [User_pk] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [db].[Repair_Order] ADD  DEFAULT (getdate()) FOR [CreateTime]
GO
ALTER TABLE [db].[token_blacklist] ADD  DEFAULT (sysdatetime()) FOR [created_at]
GO
ALTER TABLE [db].[Fee_Detail]  WITH CHECK ADD  CONSTRAINT [Fee_Detail_Property_Fee_Bill_BillID_fk] FOREIGN KEY([BillID])
REFERENCES [db].[Property_Fee_Bill] ([BillID])
GO
ALTER TABLE [db].[Fee_Detail] CHECK CONSTRAINT [Fee_Detail_Property_Fee_Bill_BillID_fk]
GO
ALTER TABLE [db].[Payment_Record]  WITH CHECK ADD  CONSTRAINT [Payment_Record_Property_Fee_Bill_BillID_fk] FOREIGN KEY([BillID])
REFERENCES [db].[Property_Fee_Bill] ([BillID])
GO
ALTER TABLE [db].[Payment_Record] CHECK CONSTRAINT [Payment_Record_Property_Fee_Bill_BillID_fk]
GO
ALTER TABLE [db].[Property_Fee_Bill]  WITH CHECK ADD  CONSTRAINT [Property_Fee_Bill_User_id_fk] FOREIGN KEY([PersonID])
REFERENCES [db].[User] ([id])
GO
ALTER TABLE [db].[Property_Fee_Bill] CHECK CONSTRAINT [Property_Fee_Bill_User_id_fk]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [Property_Info___fk_user_id] FOREIGN KEY([OwnerID])
REFERENCES [db].[User] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [Property_Info___fk_user_id]
GO
ALTER TABLE [db].[User_info]  WITH CHECK ADD  CONSTRAINT [User_info_User_id_fk] FOREIGN KEY([id])
REFERENCES [db].[User] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [db].[User_info] CHECK CONSTRAINT [User_info_User_id_fk]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__area] CHECK  (([db].[CheckArea]([Area])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__area]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__BuildingNo] CHECK  (([db].[CheckRoomNumber]([BuildingNo])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__BuildingNo]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__emile] CHECK  (([db].[CheckEmail]([username])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__emile]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__idcard] CHECK  (([db].[CheckIdcard]([IDCard])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__idcard]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__Pro_Type] CHECK  (([db].[CheckProperty_Type]([Property_Type])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__Pro_Type]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__role] CHECK  (([db].[CheckRole]([role])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__role]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__RoomNo] CHECK  (([db].[CheckRoomNumber]([RoomNo])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__RoomNo]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [CHECK__telephone] CHECK  (([db].[CheckTelephone]([telephone])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [CHECK__telephone]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_area] CHECK  (([db].[CheckArea]([Area])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_area]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_BuildingNo] CHECK  (([db].[CheckRoomNumber]([BuildingNo])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_BuildingNo]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_emile] CHECK  (([db].[CheckEmail]([username])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_emile]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_idcard] CHECK  (([db].[CheckIdcard]([IDCard])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_idcard]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_Pro_Type] CHECK  (([db].[CheckProperty_Type]([Property_Type])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_Pro_Type]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_role] CHECK  (([db].[CheckRole]([role])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_role]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_RoomNo] CHECK  (([db].[CheckRoomNumber]([RoomNo])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_RoomNo]
GO
ALTER TABLE [db].[apply_user]  WITH CHECK ADD  CONSTRAINT [检查_telephone] CHECK  (([db].[CheckTelephone]([telephone])=(1)))
GO
ALTER TABLE [db].[apply_user] CHECK CONSTRAINT [检查_telephone]
GO
ALTER TABLE [db].[Fee_Standard]  WITH CHECK ADD  CONSTRAINT [CHECK__name] CHECK  (([PropertyType]='住宅' OR [PropertyType]='店面' OR [PropertyType]='停车位'))
GO
ALTER TABLE [db].[Fee_Standard] CHECK CONSTRAINT [CHECK__name]
GO
ALTER TABLE [db].[Fee_Standard]  WITH CHECK ADD  CONSTRAINT [检查_name] CHECK  (([PropertyType]='住宅' OR [PropertyType]='店面' OR [PropertyType]='停车位'))
GO
ALTER TABLE [db].[Fee_Standard] CHECK CONSTRAINT [检查_name]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [CHECK__BuildingNo1] CHECK  (([db].[CheckRoomNumber]([BuildingNo])=(1)))
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [CHECK__BuildingNo1]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [CHECK__Property_Type] CHECK  (([db].[CheckProperty_Type]([PropertyType])=(1)))
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [CHECK__Property_Type]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [CHECK__roomNo1] CHECK  (([db].[CheckRoomNumber]([RoomNo])=(1)))
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [CHECK__roomNo1]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [检查_BuildingNo1] CHECK  (([db].[CheckRoomNumber]([BuildingNo])=(1)))
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [检查_BuildingNo1]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [检查_Property_Type] CHECK  (([db].[CheckProperty_Type]([PropertyType])=(1)))
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [检查_Property_Type]
GO
ALTER TABLE [db].[Property_Info]  WITH CHECK ADD  CONSTRAINT [检查_roomNo1] CHECK  (([db].[CheckRoomNumber]([RoomNo])=(1)))
GO
ALTER TABLE [db].[Property_Info] CHECK CONSTRAINT [检查_roomNo1]
GO
ALTER TABLE [db].[Repair_Order]  WITH CHECK ADD  CONSTRAINT [name_Urgency] CHECK  (([Urgency]<=(3) AND [Urgency]>(0)))
GO
ALTER TABLE [db].[Repair_Order] CHECK CONSTRAINT [name_Urgency]
GO
ALTER TABLE [db].[User]  WITH CHECK ADD  CONSTRAINT [CHECK__role1] CHECK  (([db].[CheckRole]([role])=(1)))
GO
ALTER TABLE [db].[User] CHECK CONSTRAINT [CHECK__role1]
GO
ALTER TABLE [db].[User]  WITH CHECK ADD  CONSTRAINT [CHECK__username1] CHECK  (([db].[CheckEmail]([username])=(1)))
GO
ALTER TABLE [db].[User] CHECK CONSTRAINT [CHECK__username1]
GO
ALTER TABLE [db].[User]  WITH CHECK ADD  CONSTRAINT [检查_role1] CHECK  (([db].[CheckRole]([role])=(1)))
GO
ALTER TABLE [db].[User] CHECK CONSTRAINT [检查_role1]
GO
ALTER TABLE [db].[User]  WITH CHECK ADD  CONSTRAINT [检查_username1] CHECK  (([db].[CheckEmail]([username])=(1)))
GO
ALTER TABLE [db].[User] CHECK CONSTRAINT [检查_username1]
GO
ALTER TABLE [db].[User_info]  WITH CHECK ADD  CONSTRAINT [CHECK__name1] CHECK  (([db].[CheckName]([name])=(1)))
GO
ALTER TABLE [db].[User_info] CHECK CONSTRAINT [CHECK__name1]
GO
ALTER TABLE [db].[User_info]  WITH CHECK ADD  CONSTRAINT [check_telephone] CHECK  (([db].[CheckTelephone]([telephone])=(1)))
GO
ALTER TABLE [db].[User_info] CHECK CONSTRAINT [check_telephone]
GO
ALTER TABLE [db].[User_info]  WITH CHECK ADD  CONSTRAINT [chekc_idcard] CHECK  (([db].[CheckIdcard]([id_card])=(1)))
GO
ALTER TABLE [db].[User_info] CHECK CONSTRAINT [chekc_idcard]
GO
ALTER TABLE [db].[User_info]  WITH CHECK ADD  CONSTRAINT [检查_name1] CHECK  (([db].[CheckName]([name])=(1)))
GO
ALTER TABLE [db].[User_info] CHECK CONSTRAINT [检查_name1]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'账单ID，外键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Detail', @level2type=N'COLUMN',@level2name=N'BillID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'费用类型' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Detail', @level2type=N'COLUMN',@level2name=N'FeeType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'计算方式' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Detail', @level2type=N'COLUMN',@level2name=N'Calculation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'金额' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Detail', @level2type=N'COLUMN',@level2name=N'Amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id，主键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'StandardID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房产类型' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'PropertyType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'费用类型' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'FreeType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'单价' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'UnitPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'开始日期' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'结末日湖' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房产名称' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Fee_Standard', @level2type=N'COLUMN',@level2name=N'Property_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'缴费ID，主键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Payment_Record', @level2type=N'COLUMN',@level2name=N'PaymentID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'账单ID，外键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Payment_Record', @level2type=N'COLUMN',@level2name=N'BillID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'缴费金额' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Payment_Record', @level2type=N'COLUMN',@level2name=N'PaymentAmount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'缴费时间' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Payment_Record', @level2type=N'COLUMN',@level2name=N'PaymentDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'缴费方式(现金/转账/微信等)' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Payment_Record', @level2type=N'COLUMN',@level2name=N'PaymentMethod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'账单ID，主键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'BillID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房产ID，外键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'计费周期' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'BillingCycle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'总金额' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'TotalAmount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态(‘未缴费’，‘已缴费’)' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'生成日期' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'GenerateDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'缴费截止日期' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill', @level2type=N'COLUMN',@level2name=N'DueDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'物业费账单表' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Fee_Bill'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房产ID，主键' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info', @level2type=N'COLUMN',@level2name=N'PropertyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'业主ID，外健' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info', @level2type=N'COLUMN',@level2name=N'OwnerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'楼称号' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info', @level2type=N'COLUMN',@level2name=N'BuildingNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房号' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info', @level2type=N'COLUMN',@level2name=N'RoomNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'建筑面积(㎡)' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info', @level2type=N'COLUMN',@level2name=N'Area'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房产类型' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info', @level2type=N'COLUMN',@level2name=N'PropertyType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房产信息表' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Property_Info'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'工单编号' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'OrderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'报修人ID(业主/员工)' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'ReporterID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'维修类型' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'RepairType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'报修标题' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'详细描述' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'紧急程度(1-5)' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'Urgency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态(待受理/已派工/维修中/已完成/已取消)' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'期望完成时间' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'ExpectedTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实际完成时间' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order', @level2type=N'COLUMN',@level2name=N'ActualFinishTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' 维修工单表' , @level0type=N'SCHEMA',@level0name=N'db', @level1type=N'TABLE',@level1name=N'Repair_Order'
GO
