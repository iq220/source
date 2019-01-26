CREATE TYPE [dbo].[udtt_Transactions] AS TABLE (
    [TransactionHash]    NVARCHAR (255)  NOT NULL,
    [From]               NVARCHAR (255)  NOT NULL,
    [To]                 NVARCHAR (255)  NULL,
    [Value]              DECIMAL (32, 2) NULL,
    [ProvisioningStatus] INT             NOT NULL);

