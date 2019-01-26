CREATE PROCEDURE [dbo].[DeleteRoleAssignment]
    @RoleAssignmentId INT
AS
BEGIN
    DELETE FROM [dbo].[RoleAssignment]
        WHERE [dbo].[RoleAssignment].[Id] = @RoleAssignmentId
END
