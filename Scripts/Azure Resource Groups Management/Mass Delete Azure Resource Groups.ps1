# Force Delete All Resource Groups in a Subscription using a Matching Filter
# AKA Nuke My Azure

# Variables
$subscription = 'my subscription name'
$filter = 'filter e.g. ilc*'

# Set the subscription context.
Set-AzContext -Subscription $subscription

# Find Resource Groups by Filter to Verify Selection
Get-AzResourceGroup | ? ResourceGroupName -match $filter | Select-Object ResourceGroupName
 
# Async delete Azure Resource Groups by Filter. 
# Uncomment the following line if you really know what you are doing; there's no way back :-)
# Get-AzResourceGroup | ? ResourceGroupName -match $filter | Remove-AzResourceGroup -AsJob -Force

# Monitor Azure Resource Group deletion progress
Get-Job

# Optional - Remove All Policy Assignments
get-AzPolicyAssignment | Remove-AzPolicyAssignment
Get-AzPolicySetDefinition -custom | Remove-AzPolicySetDefinition -force
Get-AzPolicyDefinition -custom | Remove-AzPolicyDefinition -force
