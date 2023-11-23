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
Write-Output "This is the latest policy compliance states generated in the last day for all resources within the specified Subscription Id: $id"
Set-AzContext -SubscriptionId $id
Get-AzPolicyStateSummary -SubscriptionId $id
}
managementgroup {
Write-Output "This is the latest policy compliance states generated in the last day for all resources within the specified Management Group Id: $id"
Get-AzPolicyStateSummary -ManagementGroupName $id
}
resourcegroup {
Write-Output "This is the latest policy compliance states generated in the last day for all resources within the specified Resource Group Name: $id"
Get-AzPolicyStateSummary -ResourceGroupName $id
}
}