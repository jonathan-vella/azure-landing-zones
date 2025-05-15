# Az Policy Definitions

This folder contains a comprehensive collection of Azure Policy definitions, initiatives, and supporting resources to help enforce governance, compliance, and security standards across your Azure environment.

## Folder Structure and Contents

- **arm-api-versions/**: Policies for controlling and restricting Azure Resource Manager (ARM) API versions, including:
  - `control-preview-api/`: Restrict use of preview APIs.
  - `required-minimum-api-version/`: Enforce minimum API versions.
  - `restrict-to-specific-api-version/`: Limit resources to specific API versions.
- **audit-resources-without-tags/**: Policy to audit resources that do not have required tags.
- **audit-storage-account-without-lifecycle-mgmt-policy/**: Policy to audit storage accounts missing a lifecycle management policy.
- **Configure Azure SQL PITR/**: Policies and templates to configure Point-in-Time Restore (PITR) for Azure SQL resources.
- **Deny Machine Learning Services based on SKU/**: Policies to restrict ML services by SKU.
- **Deny non-allowed VMs based on SKU/**: Policies to audit or deny deployment of non-approved VM SKUs.
- **deny-resource-deletion/**: Policies to prevent deletion of critical resources.
- **deploy-vm-shutdown-schedule/**: Policies to deploy VM auto-shutdown schedules.
- **deploy-windows-defender-vm-extension-custom-config/**: Policies to deploy Windows Defender VM extension with custom configuration.
- **deploy-windows-defender-vm-extension-sql-vm/**: Policies for Defender extension on SQL VMs.
- **enforce-win-server-hybrid-use-benefit/**: Enforce use of Windows Server Hybrid Use Benefit.
- **event-hub-minimum-tls-version/**: Enforce minimum TLS version for Event Hubs.
- **event-hub-network-ruleset-restrict-public-network-access/**: Restrict public network access for Event Hubs.
- **event-hub-restrict-public-network-access/**: Additional Event Hub public access restrictions.
- **initiative-definitions/**: Groupings of related policies (initiatives) for easier assignment and management.
- **private-endpoints/**: Policies related to Azure Private Endpoints.
- **private-endpoints-dns-registration/**: Enforce DNS registration for private endpoints.
- **resource-diagnostics-settings/**: Policies to enforce diagnostic settings on resources.
- **resource-tagging/**: Policies to enforce or audit resource tagging standards.
- **restrict-all-asm-resources/**: Restrict use of classic (ASM) resources.
- **restrict-public-ips/**: Restrict creation of public IP addresses.
- **restrict-public-storageAccount/**: Restrict public access to storage accounts.
- **restrict-resource-managed-identity/**: Restrict use of managed identities.
- **restrict-service-tags-in-nsgs/**: Restrict use of service tags in network security groups.
- **restrict-storageAccount-firewall-rules/**: Enforce firewall rules on storage accounts.
- **restrict-vm-nic-from-connecting-to-subnet/**: Restrict VM NICs from connecting to certain subnets.
- **sql-server-auditing/**: Enforce auditing on SQL servers.
- **virtual-network-guardrails/**: Policies for virtual network security and compliance.
- **vm-without-customer-managed-boot-diag-storage-account/**: Audit VMs missing customer-managed boot diagnostics storage accounts.

## Usage

- Browse the subfolders for specific policy definitions and initiatives.
- Each policy folder typically contains an `azurepolicy.json` file with the policy definition.
- Use these policies to enforce governance and compliance in your Azure subscriptions.

## Contribution

Contributions are welcome! Please submit a pull request or open an issue for new policies or improvements.
