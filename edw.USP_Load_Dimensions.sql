USE [db-DataDiggers]
GO

CREATE OR ALTER PROCEDURE edw.USP_Load_Dimensions
AS
BEGIN


------------Dim_Company------------
Truncate table [edw].[Dim_Company];
insert into [edw].[Dim_Company]
(

      [DUNS_Number]
      ,[DUNS_Name]
      ,[County]
      ,[Street_Address]
      ,[City]
      ,[State]
      ,[Zip_code]
      ,[Phone_Number]
      ,[Longitude]
      ,[Latitude]
	  ,[Is_Active]
)

select DISTINCT
	 CAST(s.[DUNS_Number] as Int)
      , s.[DUNS_Name] 
      , s.[County] 
      ,s.[Street_Address] 
      ,s.[City] 
      ,s.[State] 
      ,CAST( s.[Zip_Code]  as Int)
      ,replace(s.[Phone_Number],'.0','')
	  , cg.Longitude
	  ,cg.Latitude
	  ,1
 from  [dbo].[STG_DiversityInformation] s
 left join [STG_City_Geography] cg
on s.City=cg.city_Name


--Dim_Customer---

Truncate table [edw].[Dim_Customer];
INSERT INTO [edw].[Dim_Customer]
(
[Customer_Name]
      ,[Customer_type]
      ,[Leadership_Type]
      ,[Leadership_Role]
      ,[Gender]
      ,[Customer_Origin_Country]
      ,[Is_Active]
	  )

SELECT 
Distinct 
[Primary_executive_Contact]
,CASE when lower([Primary_executive_Contact]) like '%owner%' then 'Owner' else 'Leader' end as Customer_Type
      ,'Primary'
      ,''
	  ,[Primary_Leadership_Gender]
      ,[Primary_Leadership_Country]
      ,1
FROM 
[dbo].[STG_DiversityInformation];


----Dim_Diversity_Config---------
Truncate TABLE [edw].[Dim_Diversity_Config];
INSERT INTO [edw].[Dim_Diversity_Config]
(
[Department_Name]
,[Diversity_Name]
,[Diversity_Weightage]
,[Is_active]
)

SELECT 
[Department_Name]
      ,[Diversity_Name]
      ,[Diversity_Weightage]
	  ,1
  FROM [dbo].[STG_Diversity_Config];

----[edw].[Dim_Ethnicity]-------
TRUNCATE TABLE [edw].[Dim_Ethnicity];
Insert Into [edw].[Dim_Ethnicity]
([Country_Name]
      ,[Ethnicity_Name]
      ,[Is_Active]
)
select DISTINCT Country_Name
, CASE WHEN country_Name in 
(
'Argentina'
,'Bolivia'
,'Chile'
,'Colombia'
,'Costa Rica'
,'Cuba'
,'Dominican Republic'
,'Ecuador'
,'El Salvador'
,'Equatorial Guinea'
,'Guatemala'
,'Honduras'
,'Mexico'
,'Nicaragua'
,'Panama'
,'Paraguay'
,'Peru'
,'Puerto Rico'
,'Spain'
,'Uruguay'
,'Venezuela'
,'Brazil'
,'Haiti') Then 'Hispanic or Latino'
When Country_Name in 
('Nigeria','Ethiopia','Egypt','DR Congo','South Africa','Tanzania','Kenya','Uganda','Algeria','Sudan','Morocco','Angola','Ghana','Mozambique','Madagascar','Cameroon'
,'Niger','Burkina Faso','Mali','Malawi','Zambia','Senegal','Chad','Somalia','Zimbabwe','Guinea','Rwanda','Benin','Tunisia','Burundi'
,'South Sudan','Togo','Sierra Leone','Libya','Congo','Liberia','Central African Republic','Mauritania','Eritrea','Namibia','Gambia','Botswana','Gabon','Lesotho','Guinea-Bissau','Equatorial Guinea','Mauritius','Eswatini'
,'Djibouti','Réunion','Comoros','Western Sahara','Cabo Verde','Mayotte','Sao Tome & Principe','Seychelles','Saint Helena'
) Then 'Black or African American'
--When Country_Name in 
--('') Then 'Native American or Indigeneous'
When Country_Name in 
('China','Indonesia','Pakistan','Bangladesh','Japan','Philippines','Vietnam','Turkey','Iran','Thailand','Myanmar','South Korea','Iraq','Afghanistan'
,'Saudi Arabia','Uzbekistan','Malaysia','Yemen','Nepal','North Korea','Sri Lanka','Kazakhstan','Syria','Cambodia','Jordan','Azerbaijan',
'United Arab Emirates','Tajikistan','Israel','Laos','Lebanon','Kyrgyzstan','Turkmenistan','Singapore','Oman','State of Palestine',
'Kuwait','Georgia','Mongolia','Armenia','Qatar','Bahrain','Timor-Leste','Cyprus','Bhutan','Maldives','Brunei') Then 'Asian-Pacific Americans'
When Country_Name in 
('India') Then 'Asian-Indian Americans'
When Country_Name in 
('United States of America') Then 'American'
end as Ethncity_Name
,1
FROM [dbo].[STG_Countries]

--select * from [edw].[Dim_Ethnicity]
END

GO