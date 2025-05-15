# Azure Landing Zones

This repository provides a comprehensive set of resources, templates, and scripts to help you implement Azure Landing Zones for enterprise-scale governance, security, and compliance. It includes:

- **Azure Policy Definitions**: Custom and built-in policy definitions for enforcing standards across your Azure environment.
- **Policy as Code (IaC) Examples**: Infrastructure-as-Code (IaC) samples for deploying and testing Azure policies using Bicep and YAML.
- **Automation Scripts**: PowerShell and other scripts to automate policy assignments, remediation, and resource management.
- **Workbooks**: Dashboards and workbooks for monitoring compliance and resource health.

## Repository Structure

- `Az Policy Definitions/` — Custom policy definitions, initiatives, and supporting files.
- `Az Policy IaC Test/` — IaC templates and test configurations for policy deployment.
- `Az Policy Identity Assignment/` — Scripts and pipelines for managing policy identity assignments.
- `Az Policy Remediation via ADO Pipeline/` — Azure DevOps pipeline templates for policy remediation.
- `Az Policy Remediation via Az Automation/` — Automation scripts and resources for policy remediation.
- `Scripts/` — Utility scripts for Azure resource and policy management.
- `Workbooks/` — Monitoring and reporting workbooks.

## Getting Started

1. Clone this repository:
   ```sh
   git clone https://github.com/your-org/azure-landing-zones.git
   ```
2. Review the `Az Policy Definitions/` folder for available policies and initiatives.
3. Use the provided scripts and templates to deploy and manage policies in your Azure environment.

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements or new policy definitions.

## License

See the `LICENSE` file for details.
