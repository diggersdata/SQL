USE [db-DataDiggers]
GO

CREATE OR ALTER PROCEDURE edw.USP_Load_Facts
as
Begin

------Customer_Diversity_Mapping---------
TRUNCATE TABLE [edw].[Customer_Diversity_Mapping];

INSERT INTO [edw].[Customer_Diversity_Mapping]
(
[Customer_key]
,[Diversity_key]
)
Select distinct
	DC.Customer_Key
	,DDC.Diversity_Key 
	--,DE.Country_Name
	--,Dc.Customer_Origin_Country
from [dbo].[STG_DiversityInformation] as SDI
INNER JOIN [edw].[Dim_Customer] as DC
	ON sdi.[Primary_executive_Contact]=DC.[Customer_Name]
LEFT JOIN [edw].[Dim_Ethnicity] as DE
	On DE.Country_name=LTRIM(RTRIM(DC.Customer_Origin_Country))
LEFT JOIN [edw].[Dim_Diversity_Config] DDC
	ON 
	(CASE WHEN DE.Country_Name not in ('United States', 'United States of America') and DE.Ethnicity_Name is not null Then 'Minority' END 
							= DDC.Diversity_Name
							OR
	case when DC.Gender='Female' then 'Woman' else DC.Gender end  = DDC.Diversity_Name)
where DDC.Diversity_key is not null

--------edw.Fct_Customer_Diversity_Matrix------------
TRUNCATE TABLE [edw].[Fct_Customer_Diversity_Matrix];
INSERT INTO [edw].[Fct_Customer_Diversity_Matrix]
(
[Company_Key]
      ,[Ethnicity_Key]
      ,[Customer_key]
      ,[Is_Customer_Woman]
      ,[Is_Customer_Diverse]
      ,[Diversity_Score]
      ,[Is_Owner]
 )
Select distinct 
	DComp.Company_Key
	,DE.Ethnicity_Key
	,DCus.Customer_key
	,CASE When DCus.Gender in ('Woman','Female') Then 1 else 0 end
	,CASE When DE.Country_Name Not in ('United States', 'United States of America') and DE.Ethnicity_Name is not null Then 1 else 0 end
	,CDS.Diversity_Score
	,case when DCus.Customer_Type ='Owner' then 1 else 0 end
from dbo.STG_DiversityInformation SDI
Inner join edw.Dim_Company DComp
	on SDI.DUNS_Number=DComp.DUNS_Number
LEFT join edw.Dim_Customer DCus
	on SDI.Primary_executive_Contact=DCus.Customer_Name
LEFT join edw.Dim_Ethnicity DE
	on LTRIM(RTRIM(DCus.Customer_Origin_Country))=DE.Country_Name
LEFT join 
(	SELECT Customer_key
	, Sum(ISNULL(Diversity_Weightage,0)*0.01) as Diversity_Score  
	from edw.Customer_Diversity_Mapping CDM
	Inner join edw.Dim_Diversity_Config DDC
		on CDM.Diversity_key=DDC.Diversity_key
	Group by Customer_key
) CDS
on DCus.Customer_key=CDS.Customer_key


End

GO
