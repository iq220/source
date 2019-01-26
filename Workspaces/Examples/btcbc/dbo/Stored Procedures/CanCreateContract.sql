CREATE PROCEDURE [dbo].[CanCreateContract]
(
    @WorkflowId INT,
    @UserId INT
)
AS
BEGIN
	DECLARE @initRoleId INT

    SELECT @initRoleId = wfi.[Id]
    FROM [dbo].[WorkflowInitiator] AS wfi
    INNER JOIN [dbo].[RoleAssignment] AS urm ON urm.[ApplicationRoleId] = wfi.[ApplicationRoleId]
    WHERE urm.[UserId] = @UserId AND wfi.[WorkflowId] = @WorkflowId

    DECLARE @ReturnVal INT = 1
    if @initRoleId IS NULL
    BEGIN
        SET @ReturnVal = 0
    END
    SELECT @ReturnVal AS Status
END