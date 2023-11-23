param(
[Parameter(Mandatory = $false)] [string] $type,
[Parameter(Mandatory = $false)] [string] $id,
[Parameter(Mandatory = $true)] [string] $AppID,
[Parameter(Mandatory = $true)] [string] $AppSecret,
[Parameter(Mandatory = $true)] [string] $tenantid
)

# .Import PowerShell Modules
Get-ChildItem -Path C:\Modules\az_*\Az.Accounts -Filter "*.psd1" -Recurse | Import-Module
Get-ChildItem -Path C:\Modules\az_*\Az.Resources -Filter "*.psd1" -Recurse | Import-Module
Get-ChildItem -Path C:\Modules\az_*\Az.PolicyInsights -Filter "*.psd1" -Recurse | Import-Module

# .Authentification
$CredApp = New-Object pscredential -ArgumentList ($AppID, ($AppSecret | ConvertTo-SecureString -Force -AsPlainText))
$Login = Login-AzAccount -TenantId $tenantid -Credential $CredApp -ServicePrincipal

switch ($type) {
subscription {
$nonCompliantPolicies = Get-AzPolicyState -SubscriptionId $id | Where-Object { $_.ComplianceState -eq "NonCompliant" -and $_.PolicyDefinitionAction -eq "deployIfNotExists" -and $_.PolicyAssignmentScope -like "*subscriptions*" }
Set-AzContext -SubscriptionId $id
foreach($policy in $nonCompliantPolicies)
{
Write-Output "Start remediation: $($policy.PolicyDefinitionName)"
$startremediation = Start-AzPolicyRemediation -Name "rem-$($policy.PolicyDefinitionName)" -PolicyAssignmentId $policy.PolicyAssignmentId -PolicyDefinitionReferenceId $policy.PolicyDefinitionId
}
}
managementgroup {
$nonCompliantPolicies = Get-AzPolicyState -ManagementGroupName $id | Where-Object { $_.ComplianceState -eq "NonCompliant" -and $_.PolicyDefinitionAction -eq "deployIfNotExists" -and $_.PolicyAssignmentScope -like "*managementGroups*" }
foreach($policy in $nonCompliantPolicies)
{
Write-Output "Start remediation: $($policy.PolicyDefinitionName)"
$startremediation = Start-AzPolicyRemediation -Name "rem-$($policy.PolicyDefinitionName)" -PolicyAssignmentId $policy.PolicyAssignmentId -PolicyDefinitionReferenceId $policy.PolicyDefinitionId
}
}
resourcegroup {
$nonCompliantPolicies = Get-AzPolicyState -ResourceGroupName $id | Where-Object { $_.ComplianceState -eq "NonCompliant" -and $_.PolicyDefinitionAction -eq "deployIfNotExists" -and $_.PolicyAssignmentScope -like "*$id*" }
foreach($policy in $nonCompliantPolicies)
{
Write-Output "Start remediation: $($policy.PolicyDefinitionName)"
$startremediation = Start-AzPolicyRemediation -Name "rem-$($policy.PolicyDefinitionName)" -PolicyAssignmentId $policy.PolicyAssignmentId -PolicyDefinitionReferenceId $policy.PolicyDefinitionId
}
}
}