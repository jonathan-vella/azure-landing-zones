# Azure Policy Initiative: VNET Address Guard Rails

## Description

Azure custom Policy Initiative definition including policy definitions:

- [Deny Subnet Size](https://github.com/PieterbasNagengast/AzurePolicy-DenySubnetSize)
- [Deny equal Address space and Subnet size](https://github.com/PieterbasNagengast/AzurePolicy-DenyEqualSubnetSizeAndAddressSpace)
- [Max Address space](https://github.com/PieterbasNagengast/AzurePolicy-VNETMaxAddressSpaces)

> **_NOTE:_** Template uses Linked Templates to above mentioned repos

## Background/Use case

### Deny Subnet Size

Used in scenarios where you want to deny the creation of a subnet which is equal to the VNET Address space.
Example: Landing Zone VNETs all have /24 address spaces and you don't want to allow the creation of /24 subnets.
If this policy is assigned with the parameter set to /24:

- Creation of /24 subnet is denied
- Creation of smaller subnets is allowed
- Works both for:
  - Creating new VNETs
  - Updating/adding Subnet on existing VNETs

> **_NOTE:_** With this policy the creation of bigger subnets (e.g. /23 or /22 etc.) isn't possible; Subnets cannot be bigger than VNET address space.

### Deny equal Address space and Subnet size

Used in scenarios where you want to deny the creation of VNETs that have an equal Subnet size and Address space.
Example: Landing Zone VNETs all have /24 address spaces and you don't want to the creation of /24 subnets.
If this policy is assigned:

- Creation of VNETs with equal Address space and Subnet size is denied
- Creation of smaller subnets is allowed
- Works Creating new VNETs

> **_NOTE:_** This policy allows the creation of subnets to existing VNETs with equal Address space and Subnet size. VNET will be marked as non-compliant in Azure Policy dash.

### Max Address Space

Used in scenarios where you want to limit the amount of Address Spaces VNETs can have.
The maximum allowed Address Spaces can be specified as parameter.
If this policy is assigned:

- Creation of VNETs which exceeds the Maximum Address Spaces specified in parameters are denied

> **_NOTE:_** Existing VNETs which exceeds the Maximum Address Spaces specified in parameters will be marked as non-compliant in Azure Policy dash.

## Deploy

Deploy Policy initiative to Management Group or Subscription level.
Assign policy and provide parameters for:

- Denied Subnet size (e.g. /24)
- Max allowed Address spaces (e.g. 1)
- Effect type of each policy (Deny, Audit, Disabled)

| Description                      | Template                                                                                                                                                                                                                                                             |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Deploy to Azure Management Group | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FPieterbasNagengast%2FAzurePolicySet-VNETAddressGuardRails%2Fmain%2FVNET-Address-Guard-rails-MgmtGrp.json) |
| Deploy to Azure Subscription     | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FPieterbasNagengast%2FAzurePolicySet-VNETAddressGuardRails%2Fmain%2FVNET-Address-Guard-rails-Sub.json)     |
