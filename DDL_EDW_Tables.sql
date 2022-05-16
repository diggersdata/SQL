USE [db-DataDiggers]
GO

IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Dim_Ethnicity')
BEGIN
--DROP TABLE IF EXISTS [edw].[Dim_Ethnicity];
CREATE TABLE [edw].[Dim_Ethnicity]
(
 [Ethnicity_Key]  INT NOT NULL Identity(1,1) Primary Key,
 [Country_Name]   Nvarchar(100)  NULL ,
 [Ethnicity_Name] Nvarchar(100)  NULL ,
 [Created_Date]   DATETIME NOT NULL DEFAULT(GETDATE()),
 [Updated_Date]   DATETIME NOT NULL DEFAULT(GETDATE())
 )
END

IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Dim_Customer')
BEGIN
 --DROP TABLE IF EXISTS [edw].[Dim_Customer];
 CREATE TABLE [edw].[Dim_Customer]
(
 [Customer_key]            INT NOT NULL Identity(1,1) Primary Key,
 [Customer_Name]           Nvarchar(100)  NULL ,
 [Customer_type]           Nvarchar(100)  NULL ,
 [Leadership_Type]         Nvarchar(50)  NULL ,
 [Leadership_Role]         Nvarchar(100)  NULL ,
 [Gender]                  Nvarchar(50)  NULL ,
 [Customer_Origin_Country] Nvarchar(50)  NULL ,
 [Is_Active]               INT NOT NULL ,
 [Created_Date]            DATETIME NOT NULL DEFAULT(GETDATE()),
 [Updated_Date]            DATETIME NOT NULL DEFAULT(GETDATE())
 
 )
 END

IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Dim_Company')
BEGIN
 --DROP TABLE IF EXISTS [edw].[Dim_Company];
 CREATE TABLE [edw].[Dim_Company]
(
 [Company_Key]    INT NOT NULL Identity(1,1) Primary Key,
 [DUNS_Number]    INT NOT NULL ,
 [DUNS_Name]      Nvarchar(500) NULL ,
 [County]         Nvarchar(100) NULL ,
 [Street_Address] Nvarchar(1000) NULL ,
 [City]           Nvarchar(100) NULL ,
 [State]          Nvarchar(100) NULL ,
 [Zip_code]       INT NULL ,
 [Phone_Number]   Nvarchar(50) NULL ,
 [Longitude]      Nvarchar(50) NULL ,
 [Latitude]       Nvarchar(50) NULL ,
 [Is_Active]      bit NOT NULL ,
 [Created_Date]   DATETIME NOT NULL DEFAULT(GETDATE()),
 [Updated_Date]   DATETIME NOT NULL DEFAULT(GETDATE())
 )
END


IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Dim_Diversity_Config')
BEGIN

--DROP TABLE IF EXISTS [edw].[Dim_Diversity_Config];
CREATE TABLE [edw].[Dim_Diversity_Config]
(
 [Diversity_key]       INT NOT NULL Identity(1,1) Primary Key,
 [Department_Name]     Nvarchar(100) NULL ,
 [Diversity_Name]      Nvarchar(100) NULL ,
 [Diversity_Weightage] INT NOT NULL ,
 [Is_active]           INT NOT NULL ,
 [Created_Date]        DATETIME NOT NULL DEFAULT(GETDATE()) ,
 [Updated_Date]        DATETIME NOT NULL DEFAULT(GETDATE())
 )
 END

 IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Customer_Diversity_Mapping')
BEGIN
 --DROP TABLE IF EXISTS [edw].[Customer_Diversity_Mapping];
 CREATE TABLE [edw].[Customer_Diversity_Mapping]
(
 [Customer_key]  INT NOT NULL ,
 [Diversity_key] INT NULL ,
 [Load_Date] Date NOT NULL DEFAULT(CAST(GETDATE() as DATE)),
 CONSTRAINT [FK_Customer_Diversity_Mapping_Diversity_key] FOREIGN KEY ([Diversity_key])  REFERENCES [edw].[Dim_Diversity_Config]([Diversity_key]),
 CONSTRAINT [FK_Customer_Diversity_Mapping_Customer_key] FOREIGN KEY ([Customer_key])  REFERENCES [edw].[Dim_Customer]([Customer_key])
)
END

IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Fct_Customer_Diversity_Matrix')
BEGIN
 --DROP TABLE IF EXISTS [edw].[Fct_Customer_Diversity_Matrix];
CREATE TABLE [edw].[Fct_Customer_Diversity_Matrix]
(
 [Company_Key]         INT NOT NULL ,
 [Ethnicity_Key]       INT NULL ,
 [Customer_key]        INT NULL ,
 [Is_Customer_Woman]   bit  NULL ,
 [Is_Customer_Diverse] bit  NULL ,
 [Diversity_Score]     Float  NULL ,
 [Is_Owner]            INT  NULL ,
 [Load_Date]           date NOT NULL DEFAULT(GETDATE()),
 CONSTRAINT [FK_Fct_Customer_Diversity_Matrix_Customer_key] FOREIGN KEY ([Customer_key])  REFERENCES [edw].[Dim_Customer]([Customer_key]),
 CONSTRAINT [FK_Fct_Customer_Diversity_Matrix_Ethnicity_Key] FOREIGN KEY ([Ethnicity_Key])  REFERENCES [edw].[Dim_Ethnicity]([Ethnicity_Key]),
 CONSTRAINT [FK_Fct_Customer_Diversity_Matrix_Company_Key] FOREIGN KEY ([Company_Key])  REFERENCES [edw].[Dim_Company]([Company_Key])
)
END
IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='edw' and TABLE_NAME='Customer_Diversity_Mapping')
BEGIN
--drop table [edw].[Customer_Diversity_Mapping]
CREATE TABLE [edw].[Customer_Diversity_Mapping]
(
 [Customer_key]  INT NOT NULL ,
 [Diversity_key] INT NULL ,
 [Load_Date] Date NOT NULL DEFAULT(CAST(GETDATE() as DATE)),
 CONSTRAINT [FK_Customer_Diversity_Mapping_Customer_key] FOREIGN KEY ([Customer_key])  REFERENCES [edw].[Dim_Customer]([Customer_key]),
 CONSTRAINT [FK_Customer_Diversity_Mapping_Diversity_Key] FOREIGN KEY ([Diversity_key])  REFERENCES [edw].[Dim_Diversity_Config]([Diversity_key])
 )
 END

 GO