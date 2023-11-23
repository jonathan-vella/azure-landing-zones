[Infrastructure as Code Testing with Azure Policy](/t5/core-infrastructure-and-security/infrastructure-as-code-testing-with-azure-policy/ba-p/3921765)
======================================================================================================================================================

‎Sep 25 2023 01:00 AM

Have you ever wanted to test an ARM template or Bicep template against Azure Policy deployed in your environment – so that you could determine if the resource was going to be compliant or non-compliant? Or develop some tests against deployed policy to ensure that the policies themselves were working? Until now this would require long testing cycles where resources would be deployed, you would trigger a policy scan and then wait until a result was returned before deciding if the test was successful.

The post examines how you can use PSRule for Azure and Enterprise Policy as Code (EPAC) together to evaluate templates against deployed policy rules

[PSRule for Azure](https://azure.github.io/PSRule.Rules.Azure/) has now introduced a preview feature where you can take existing policies in your environment and convert them to rules which you can test your infrastructure as code deployments against. This feature is on top of the [390 rules](https://azure.github.io/PSRule.Rules.Azure/features/#start-day-one) implemented by PSRule to ensure your deployments are in line with Microsoft’s Well Architected Framework before they are deployed into your environment.

[Enterprise Policy As Code](https://aka.ms/epac) can be used to manage Azure Policy in an environment using code for a stateful policy experience – and supports extracting policies from an existing environment for management. Updates have been made to its extraction commands to allow it to support the new functionality that PSRule offers.

Follow along with the sample scenario below to see how this works.

#### Sample Scenario

_I’m developing some templates for a new infrastructure as code deployment into Azure – how do I know if the resources I’m going to be deploying are compliant with policies deployed in my environment?_

A common scenario, and if you aren’t familiar with the team that manages Azure Policy you could spend a lot of time trying to work out if your resources are going to be compliant or not.

Let’s dive into that project and see how these tools can help. The sample code is [available on GitHub](https://github.com/anwather/iac-psrule) for you to review.

Firstly, some pre-requisite tools to install – you need Az PowerShell and some other PowerShell modules before you can start.

    Install-Module Az -Scope CurrentUser
    Install-Module PSRule.Rules.Azure -Scope CurrentUser -AllowPrerelease
    Install-Module EnterprisePolicyAsCode -Scope CurrentUser
    

Next, we need to set up these tools so they can be used. In the repository above are the files you will need: -

*   [ps-rule.yaml](https://github.com/anwather/iac-psrule/blob/main/ps-rule.yaml) (For PSRule configuration)
*   [global-settings.jsonc](https://github.com/anwather/iac-psrule/blob/main/global-settings.jsonc) (For EPAC Configuration)

The ps-rule.yaml file contains settings for PSRule including a section to say only include Azure Policy rules when running. Hint - if you comment out the _rules_ section all 390 rules from PSRule for Azure will be evaluated against the templates.

We need to make some changes to the global-settings.jsonc file to set it up for the environment so EPAC can work.

Adjust the commented sections in the file to match your environment – you can provide your tenant ID and a deployment scope for where your resources are going to be deployed to. When we extract the policies EPAC will determine all policies that apply to the scope from the tenant root level down.

    {
        "$schema": "https://raw.githubusercontent.com/Azure/enterprise-azure-policy-as-code/main/Schemas/global-settings-schema.json",
        "pacOwnerId": "2ab423a7-e6db-4ad1-9605-7629f1b4b4e6",
        "pacEnvironments": [
            {
                "pacSelector": "psrule",
                "cloud": "AzureCloud",
                "tenantId": "6b40ddff-60b7-41dd-9121-168cdb1a6e80", // Update with your tenant Id
                "deploymentRootScope": "/subscriptions/00000000-0000-0000-000000000000" // Update with the scope your resources will be deployed at
            }
        ]
    }
    

Finally, there are some sample Bicep templates in the repository – which we can test against. I have policies in my environment to enforce tagging, locations, and all the default deployed [Azure Landing Zone policies](https://aka.ms/alz/policies).

#### Extracting the Policy Objects

To extract the existing policy objects in your environment you can run the command below. This will look at the scope in your global-settings.jsonc file and extract all the definitions for the policies assigned from the tenant root level down to the scope you have supplied.

    Export-AzPolicyResources -DefinitionsRootFolder .\ -Mode psrule -OutputFolder .\

A file called psrule.assignment.json will be created. This file contains all the policy assignments and definitions assigned to the scope you specified.

#### Convert Policy Objects to PSRule Rules

PSRule has a robust way of specifying rules which support YAML, JSON and PowerShell. It contains a function which allows you to convert the extracted objects above into a set of rules that PSRule understands.

Use the code below to create the rules file – and copy it into the path that PSRule expects.

    Export-AzPolicyAssignmentRuleData -AssignmentFile .\psrule.assignment.json -OutputPath .\ps-rule

Don’t be alarmed if there are errors when this command runs – there are still some bugs being worked out, but it should generate a file similar to the one below.

![Picture1.png](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/506960iF0870377419CF5CE/image-size/large?v=v2&px=999 "Picture1.png")

This file contains all the rules converted to a format the PSRule understands – for example here is the rule created from the policy definition that is in place to control resource locations.

    {
        "apiVersion": "github.com/microsoft/PSRule/v1",
        "kind": "Rule",
        "metadata": {
            "name": "Azure.Policy.b8a4e2d03e09",
            "displayName": "Allowed locations",
            "tags": {
                "Azure.Policy/category": "General"
            },
            "annotations": {
                "Azure.Policy/id": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c",
                "Azure.Policy/version": "1.0.0"
            }
        },
        "spec": {
            "recommend": "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region.",
            "with": [
                "PSRule.Rules.Azure\\Azure.Resource.SupportsTags"
            ],
            "where": {
                "allOf": [
                    {
                        "field": "location",
                        "notIn": [
                            "australiaeast"
                        ]
                    },
                    {
                        "field": "location",
                        "notEquals": "global"
                    },
                    {
                        "notEquals": "Microsoft.AzureActiveDirectory/b2cDirectories",
                        "type": "."
                    }
                ]
            },
            "condition": {
                "value": "deny",
                "equals": false
            }
        }
    }

#### Testing Against Templates

Finally, the testing can be done – use the code below to evaluate the templates you have against the policy rules.

    Assert-PSRule -InputPath .\ -Module "PSRule.Rules.Azure" -Format File

There will be a lot of output – failures against policy are going to be highlighted as below.

This is a missing network access rule on my storage account template: -

![Picture2.png](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/506963i0F852A6D249BAC07/image-size/large?v=v2&px=999 "Picture2.png")\\

Missing tags: -

![Picture3.png](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/506964i1428F6E829F01BCF/image-size/large?v=v2&px=999 "Picture3.png")

Incorrect location: -

![Picture4.png](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/506965iA3B1A04A7AAB5541/image-size/large?v=v2&px=999 "Picture4.png")

If this is a bit hard to read – you can export the results to a CSV file using the command below which will make sorting and filtering easier.

    Assert-PSRule -InputPath .\ -Module "PSRule.Rules.Azure" -Format File -OutputFormat Csv -OutputPath exceptions.csv

![Picture5.png](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/506966iC12E63BB42D68E3D/image-size/large?v=v2&px=999 "Picture5.png")

What you have now is a straightforward way to test if templates are going to be valid according to Azure Policy. PSRule can export this information as NUnit3 as well which means that with a little bit of work I can incorporate the test results into an Azure Pipeline and get some nice visual output. The sample pipeline I used is [available in the repository](https://github.com/anwather/iac-psrule/blob/main/pipeline.yaml) with the other code.

![Picture6.png](https://techcommunity.microsoft.com/t5/image/serverpage/image-id/506967iBB27EFC55A1B466A/image-size/large?v=v2&px=999 "Picture6.png")

#### Conclusion

Up until now testing infrastructure as code templates against Azure Policy has been difficult and time consuming. Using tools available in PSRule for Azure and Enterprise Policy as Code you can determine compliance of templated resources prior to deploying them.

Please be aware that the feature for PSRule is still in preview, however it shows exciting potential for what could be possible in the future.

Please be aware that this is still an early capability and as such there will be bugs! If you have errors and would like some help please reach out to the following projects based on what you are having issues with.

*   For Export-AzPolicyResources issues and setting up the global-settings reach out the [EPAC](https://github.com/Azure/enterprise-azure-policy-as-code/issues)
*   For Export-AzPolicyAssignmentRuleData and Assert-PSRuleData reach out to [PSRule for Azure](https://github.com/Azure/PSRule.Rules.Azure/issues)

#### Disclaimer

The sample scripts are not supported under any Microsoft standard support program or service. The sample scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages.
