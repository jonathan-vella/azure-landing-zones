    # usage .\Fix-PolicyAssignmentsMsiRoleAssignment.ps1 -ManagementGroupName 'mymanagementgroup'
    param (
        $ManagementGroupName
    )

    $ErrorActionPreference = 'Stop'

    $context = Get-AzContext

    if (-not $context) {
        Write-Error -Exception "Login to Azure first!"
    }

    $context = Get-AzContext

    if (-not $context) {
        Write-Error -Exception "Login to Azure first!"
    }

    # use this if you run this script in a pipeline
    # $token = ($context.TokenCache.ReadItems() | Sort-Object -Property ExpiresOn -Descending)[0].AccessToken

    # use this when running locally
    $context = Get-AzContext
    $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile;
    $rmProfileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile);
    $token = $rmProfileClient.AcquireAccessToken($context.Subscription.TenantId).AccessToken;


    $headers = @{
        'Host' = 'management.azure.com'
        'Content-Type' = 'application/json';
        'Authorization' = "Bearer $token";
    }

    $rootScope = [psobject]@{
        id = "/providers/Microsoft.Management/managementGroups/$( $ManagementGroupName  )" 
    }

    $mgUri = "https://management.azure.com/providers/Microsoft.Management/managementGroups/$( $ManagementGroupName )/descendants?api-version=2020-02-01"

    $result = Invoke-RestMethod -Uri $mgUri -Headers $headers -Method Get

    $scopes = $result.value
    $scopes += $rootScope 

    $assignmentsForRbacFix = @()

    foreach ($scope in $scopes) {
        Write-Output -InputObject "Looking for assignments requiring permissions in scope $( $scope.id )"

        #fitler out inherited assignments and Azure Security Center
        $assignments = Get-AzPolicyAssignment -Scope $scope.id -ErrorAction SilentlyContinue | Where-Object -FilterScript { 
            $_.Properties.Scope -eq $scope.id -and `
            -not $_.ResourceId.EndsWith('SecurityCenterBuiltIn') -and `
            $_.Identity
        }

        $assignmentsForRbacFix += $assignments
    }


    foreach ($assignmentRbacFix in $assignmentsForRbacFix) {
        $msiObjectId = $assignmentRbacFix.Identity.principalId

        $policyDefinitions = @()

        $policyDefinition = Get-AzPolicyDefinition -Id $assignmentRbacFix.Properties.PolicyDefinitionId -ErrorAction SilentlyContinue

        if ($policyDefinition) {
            $policyDefinitions += $policyDefinition #not tested without initiative!
        } else {
            $policySetDefinition = Get-AzPolicySetDefinition -Id $assignmentRbacFix.Properties.PolicyDefinitionId
            $policyDefinitions += $policySetDefinition.Properties.PolicyDefinitions | % { Get-AzPolicyDefinition -Id $_.PolicyDefinitionId }
        }

        $requiredRoles = @()

        foreach ($policy in $policyDefinitions) {

            foreach ($roleDefinitionId in $policy.Properties.PolicyRule.Then.Details.RoleDefinitionIds) {

                $roleId = ($roleDefinitionId  -split "/")[4]

                if ($requiredRoles -notcontains $roleId) {
                    $requiredRoles += $roleId 
                }
            }
        }

        #cleanup role assignments
        Get-AzRoleAssignment -Scope $assignmentRbacFix.Properties.Scope | Where-Object -Property ObjectType -EQ 'Unknown' | % {
            Remove-AzRoleAssignment -InputObject $_
            Write-Output -InputObject "Removed role assignment: $( $_ | ConvertTo-Json -Compress )"
        }

        foreach ($roleDefinitionId in $requiredRoles) {
            $roleAssignment = Get-AzRoleAssignment -Scope $assignmentRbacFix.Properties.Scope -ObjectId $msiObjectId -RoleDefinitionId  $roleDefinitionId

            if (-not $roleAssignment ) {
                $roleAssignment = New-AzRoleAssignment -Scope $assignmentRbacFix.Properties.Scope -ObjectId $msiObjectId -RoleDefinitionId $roleDefinitionId -ErrorAction Stop
                Write-Output -InputObject "Added role assignment: $( $roleAssignment | ConvertTo-Json -Compress )"
            }            
        }
    }
