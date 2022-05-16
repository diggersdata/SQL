USE [db-DataDiggers]
GO


IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='dbo' and TABLE_NAME='STG_DiversityInformation')
BEGIN
--DROP TABLE IF EXiSTS [dbo].[STG_DiversityInformation];
CREATE TABLE [dbo].[STG_DiversityInformation]
(
 [DUNS_Number]                nvarchar(50) NULL ,
 [DUNS_Name]                   nvarchar(500) NULL ,
 [County]                      nvarchar(100) NULL ,
 [Street_Address]              nvarchar(1000) NULL ,
 [City]                        nvarchar(100) NULL ,
 [State]                       nvarchar(100) NULL ,
 [Zip_Code]                    Nvarchar(50) NULL ,
 [Phone_Number]                nvarchar(50) NULL ,
 [Primary_executive_Contact]   nvarchar(100) NULL ,
 [Secondary_executive_Contact] nvarchar(100) NULL ,
 [Is_Woman_Owned]              Nvarchar(10) NULL ,
 [Minority_Owned_Description]  nvarchar(100) NULL ,
 [Primary_Leadership_Country]  nvarchar(100) NULL ,
 [Primary_Leadership_Gender]   nvarchar(50) NULL ,
  

);

END
GO


IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='dbo' and TABLE_NAME='STG_City_Geography')
BEGIN
--DROP TABLE IF EXiSTS [dbo].[STG_City_Geography];
CREATE TABLE [dbo].[STG_City_Geography]
(
 [City_Name] nvarchar(100) NULL ,
 [Latitude]  nvarchar(50) NULL ,
 [Longitude] nvarchar(50) NULL 

);
END
GO

IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='dbo' and TABLE_NAME='STG_Diversity_Config')
BEGIN
--DROP TABLE IF EXiSTS [dbo].[STG_Diversity_Config];
CREATE TABLE [dbo].[STG_Diversity_Config]
(
 [Department_Name]     nvarchar(100)  NULL ,
 [Diversity_Name]      nvarchar(100)  NULL ,
 [Diversity_Weightage] nvarchar(10)  NULL 

);
END
GO

IF NOT EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='dbo' and TABLE_NAME='STG_Countries')
BEGIN
--DROP TABLE IF EXiSTS [dbo].[STG_Countries];
CREATE TABLE [dbo].[STG_Countries]
(
 [Country_Code] nvarchar(10) NULL ,
 [Country_Name] nvarchar(100) NULL ,
 [Nationality]  nvarchar(100) NULL 

);
END
GO
