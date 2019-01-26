CREATE TYPE [dbo].[udtt_ContractProperties] AS TABLE (
    [ContractAddress]       NVARCHAR (255)  NOT NULL,
    [WorkflowPropertyId]    INT             NOT NULL,
    [ContractPropertyValue] NVARCHAR (4000) NOT NULL);

