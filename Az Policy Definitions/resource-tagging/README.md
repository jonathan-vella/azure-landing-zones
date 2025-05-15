# Resource Tagging Policies

This folder contains Azure Policy definitions and related resources for enforcing, auditing, and managing resource tagging standards across your Azure environment.

## Policy Descriptions

- **inherit-multiple-tags-from-resource-group.json**: Inherits up to nine specified tags from the parent resource group to resources that are missing those tags, ensuring tag consistency across resources.
- **enforce-resource-group-tags.json**: Denies creation of resource groups that do not have required tags such as `environment`, `costcenter`, `owner`, `workload`, or `sla`.
- **enforce-resource-group-tags-exclude-resource-groups-based-on-name.json**: Enforces required tags on resource groups, but excludes groups with names matching certain patterns (e.g., AzureBackupRG*, ResourceMover*, databricks-rg*, etc.).
- **enforce-resource-group-tags-and-values.json**: Similar to the previous policy, but also enforces specific tag values and excludes resource groups based on name patterns.
- **Append Tags to Resource Groups.json**: Modifies resource groups to append missing tags (such as Application, Environment, CostCenter, SLA, Department, Owner) with specified values if they do not exist.

## Usage

- Assign these policies at the subscription or management group level to standardize tagging across your environment.
- Use policy assignments to specify required tag names and values as parameters.
- Monitor compliance in the Azure Policy portal and remediate non-compliant resources as needed.

## Why Tagging Matters

Consistent resource tagging enables better cost management, automation, security, and operational insights in Azure. These policies help ensure your resources are always properly tagged.

## Contribution

Contributions are welcome! Please submit a pull request or open an issue for new tagging policies or improvements.
