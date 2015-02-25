


-- GET ALL NEWSPAPER - MAGAZINES EXISTS WITH THEIR CODE
insert into Newsbeast_no_tables.dbo.cms_DC_NewsPapers
select *
from dbo.cms_DC_NewsPapers


insert into Newsbeast_no_tables.dbo.cms_DC_NewsPaperFreq
select *
from dbo.cms_DC_NewsPaperFreq


insert into Newsbeast_no_tables.dbo.cms_DC_NewsPapersCategories
select *
from dbo.cms_DC_NewsPapersCategories




--cms_DC_NewsPapers
--cms_DC_NewsPapersCategories
--cms_DC_NewsPaperFreq
--cms_DC_NewsPaperPublications
--cms_GetNewId
--cms_Identities


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cms_GetNewId]'))
BEGIN
	DROP PROC [cms_GetNewId]
END


/****** Object:  StoredProcedure [dbo].[cms_GetNewId]    Script Date: 02/24/2015 14:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[cms_GetNewId]
	@Table NVARCHAR(200),
	@Field NVARCHAR(200),
	@NewId INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Key NVARCHAR(400)
	SELECT @Key = '[' + @Table + '].[' + @Field + ']'
	
	IF NOT EXISTS(SELECT * FROM [cms_Identities] WHERE [IdentityKey] = @Key)
	BEGIN
		DECLARE @Sql NVARCHAR(MAX)
		DECLARE @Id INT
		DECLARE @Params NVARCHAR(MAX)
		
		SELECT @Sql = 'SELECT @Id = ISNULL(MAX([' + @Field + ']), 1) FROM [' + @Table + ']'
		SELECT @Params = '@Id INT OUTPUT'
		
		EXECUTE sp_executesql @Sql, @Params,@Id = @NewId OUTPUT

		INSERT INTO [cms_Identities]([IdentityKey], [IdentityValue]) 
		VALUES (@Key, @NewId)
	END
	ELSE 
	BEGIN
		SELECT @NewId = MAX([IdentityValue]) FROM [cms_Identities] WHERE [IdentityKey] = @Key
	END
	UPDATE [cms_Identities] SET [IdentityValue] = @NewId + 1 WHERE [IdentityKey] = @Key
END



/*

CREATE cms_Identities

*/


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_Identities_IdentityValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_Identities] DROP CONSTRAINT [DF_cms_Identities_IdentityValue]
END

GO

/****** Object:  Table [dbo].[cms_Identities]    Script Date: 02/24/2015 14:33:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cms_Identities]') AND type in (N'U'))
DROP TABLE [dbo].[cms_Identities]
GO

/****** Object:  Table [dbo].[cms_Identities]    Script Date: 02/24/2015 14:33:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cms_Identities](
	[IdentityKey] [nvarchar](400) NOT NULL,
	[IdentityValue] [int] NOT NULL,
 CONSTRAINT [PK_cms_Identities] PRIMARY KEY CLUSTERED 
(
	[IdentityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[cms_Identities] ADD  CONSTRAINT [DF_cms_Identities_IdentityValue]  DEFAULT ((1)) FOR [IdentityValue]
GO



/*

CREATE [cms_DC_NewsPaperFreq]

*/


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPaperFreq_status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPaperFreq] DROP CONSTRAINT [DF_cms_DC_NewsPaperFreq_status]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPaperFreq_statusChangedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPaperFreq] DROP CONSTRAINT [DF_cms_DC_NewsPaperFreq_statusChangedDate]
END

GO

/****** Object:  Table [dbo].[cms_DC_NewsPaperFreq]    Script Date: 02/24/2015 14:31:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cms_DC_NewsPaperFreq]') AND type in (N'U'))
DROP TABLE [dbo].[cms_DC_NewsPaperFreq]
GO


/****** Object:  Table [dbo].[cms_DC_NewsPaperFreq]    Script Date: 02/24/2015 14:31:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[cms_DC_NewsPaperFreq](
	[rowID] [int] NOT NULL,
	[langID] [int] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[statusChangedDate] [datetime] NOT NULL,
	[fr_title] [nvarchar](500) NULL,
	[fr_image] [nvarchar](500) NULL,
 CONSTRAINT [PK_cms_DC_NewsPaperFreq] PRIMARY KEY CLUSTERED 
(
	[rowID] ASC,
	[langID] ASC,
	[status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[cms_DC_NewsPaperFreq] ADD  CONSTRAINT [DF_cms_DC_NewsPaperFreq_status]  DEFAULT ('published') FOR [status]
GO

ALTER TABLE [dbo].[cms_DC_NewsPaperFreq] ADD  CONSTRAINT [DF_cms_DC_NewsPaperFreq_statusChangedDate]  DEFAULT (getdate()) FOR [statusChangedDate]
GO





/*

CREATE [cms_DC_NewsPapersCategories]

*/

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPapersCategories_status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPapersCategories] DROP CONSTRAINT [DF_cms_DC_NewsPapersCategories_status]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPapersCategories_statusChangedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPapersCategories] DROP CONSTRAINT [DF_cms_DC_NewsPapersCategories_statusChangedDate]
END

GO


/****** Object:  Table [dbo].[cms_DC_NewsPapersCategories]    Script Date: 02/24/2015 14:27:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cms_DC_NewsPapersCategories]') AND type in (N'U'))
DROP TABLE [dbo].[cms_DC_NewsPapersCategories]
GO

/****** Object:  Table [dbo].[cms_DC_NewsPapersCategories]    Script Date: 02/24/2015 14:27:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[cms_DC_NewsPapersCategories](
	[rowID] [int] NOT NULL,
	[langID] [int] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[statusChangedDate] [datetime] NOT NULL,
	[CatName] [nvarchar](500) NULL,
	[CatOrder] [int] NULL,
	[CatCode] [nvarchar](500) NULL,
	[Active] [bit] NULL,
	[LowerCatName] [nvarchar](500) NULL,
 CONSTRAINT [PK_cms_DC_NewsPapersCategories] PRIMARY KEY CLUSTERED 
(
	[rowID] ASC,
	[langID] ASC,
	[status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[cms_DC_NewsPapersCategories] ADD  CONSTRAINT [DF_cms_DC_NewsPapersCategories_status]  DEFAULT ('published') FOR [status]
GO

ALTER TABLE [dbo].[cms_DC_NewsPapersCategories] ADD  CONSTRAINT [DF_cms_DC_NewsPapersCategories_statusChangedDate]  DEFAULT (getdate()) FOR [statusChangedDate]
GO



/*

CREATE cms_DC_NewsPaperPublications

*/


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPaperPublications_status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPaperPublications] DROP CONSTRAINT [DF_cms_DC_NewsPaperPublications_status]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPaperPublications_statusChangedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPaperPublications] DROP CONSTRAINT [DF_cms_DC_NewsPaperPublications_statusChangedDate]
END

GO

/****** Object:  Table [dbo].[cms_DC_NewsPaperPublications]    Script Date: 02/24/2015 14:23:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cms_DC_NewsPaperPublications]') AND type in (N'U'))
DROP TABLE [dbo].[cms_DC_NewsPaperPublications]
GO

/****** Object:  Table [dbo].[cms_DC_NewsPaperPublications]    Script Date: 02/24/2015 14:23:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[cms_DC_NewsPaperPublications](
	[rowID] [int] NOT NULL,
	[langID] [int] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[statusChangedDate] [datetime] NOT NULL,
	[Publ_Title] [nvarchar](500) NULL,
	[Publ_Date] [datetime] NULL,
	[Publ_Photo] [nvarchar](500) NULL,
	[Publ_ID] [nvarchar](500) NULL,
	[Pub_back] [bit] NULL,
	[copied] [bit] NULL,
 CONSTRAINT [PK_cms_DC_NewsPaperPublications] PRIMARY KEY CLUSTERED 
(
	[rowID] ASC,
	[langID] ASC,
	[status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[cms_DC_NewsPaperPublications] ADD  CONSTRAINT [DF_cms_DC_NewsPaperPublications_status]  DEFAULT ('published') FOR [status]
GO

ALTER TABLE [dbo].[cms_DC_NewsPaperPublications] ADD  CONSTRAINT [DF_cms_DC_NewsPaperPublications_statusChangedDate]  DEFAULT (getdate()) FOR [statusChangedDate]
GO



/*

CREATE [cms_DC_NewsPapers]

*/

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPapers_status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPapers] DROP CONSTRAINT [DF_cms_DC_NewsPapers_status]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cms_DC_NewsPapers_statusChangedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cms_DC_NewsPapers] DROP CONSTRAINT [DF_cms_DC_NewsPapers_statusChangedDate]
END

GO


/****** Object:  Table [dbo].[cms_DC_NewsPapers]    Script Date: 02/24/2015 14:21:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cms_DC_NewsPapers]') AND type in (N'U'))
DROP TABLE [dbo].[cms_DC_NewsPapers]
GO

/****** Object:  Table [dbo].[cms_DC_NewsPapers]    Script Date: 02/24/2015 14:21:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[cms_DC_NewsPapers](
	[rowID] [int] NOT NULL,
	[langID] [int] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[statusChangedDate] [datetime] NOT NULL,
	[Title] [nvarchar](500) NULL,
	[PaperUrl] [nvarchar](500) NULL,
	[Category] [nvarchar](500) NULL,
	[ID] [nvarchar](500) NULL,
	[freq] [nvarchar](500) NULL,
	[isInactive] [bit] NULL,
	[MagazineCategory] [nvarchar](500) NULL,
	[ActiveNewsGr] [bit] NULL,
	[Rank] [int] NULL,
 CONSTRAINT [PK_cms_DC_NewsPapers] PRIMARY KEY CLUSTERED 
(
	[rowID] ASC,
	[langID] ASC,
	[status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[cms_DC_NewsPapers] ADD  CONSTRAINT [DF_cms_DC_NewsPapers_status]  DEFAULT ('published') FOR [status]
GO

ALTER TABLE [dbo].[cms_DC_NewsPapers] ADD  CONSTRAINT [DF_cms_DC_NewsPapers_statusChangedDate]  DEFAULT (getdate()) FOR [statusChangedDate]
GO


