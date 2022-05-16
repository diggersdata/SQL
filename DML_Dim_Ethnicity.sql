USE [db-DataDiggers]
GO

TRUNCATE TABLE dbo.STG_Diversity_Config ;
insert into dbo.STG_Diversity_Config 
(Department_name, Diversity_Name, Diversity_Weightage)
values('D1','Woman','300')
, ('D1','Minority','200')

GO