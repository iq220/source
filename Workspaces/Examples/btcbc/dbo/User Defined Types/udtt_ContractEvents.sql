CREATE TYPE [dbo].[udtt_ContractEvents] AS TABLE (
    [TransactionHash]    NVARCHAR (255) NOT NULL,
    [ApplicationId]      INT            NOT NULL,
    [ContractAddress]    NVARCHAR (255) NOT NULL,
    [WorkflowId]         INT            NOT NULL,
    [ActionName]         NVARCHAR (255) NOT NULL,
    [WorkflowStateValue] INT            NOT NULL);

