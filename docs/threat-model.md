# Threat Model

## Objective

This threat model identifies the main risks addressed by the Azure Secure Landing Zone and maps each risk to implemented security controls.

## Identified Threats and Mitigations

| Threat | Risk | Mitigation |
|---|---|---|
| Public exposure | Resources exposed directly to the Internet | Private subnet and NSG inbound deny rule |
| Excessive permissions | Users with more access than required | RBAC Reader role and least privilege review |
| Accidental deletion | Critical resources removed by mistake | Resource Lock with delete protection |
| Uncontrolled region deployment | Resources created in non-approved regions | Azure Policy allowed locations |
| Poor cost visibility | Unexpected Azure consumption | Budget alerts at 50%, 80% and 100% |
| Lack of ownership | Resources without clear responsibility | Governance tags |
| Lack of auditability | No visibility over administrative actions | Activity Log review |
| Misconfigured IaC | Terraform creates insecure resources | GitHub Actions and Checkov scan |

## Security Principles Applied

- Least privilege
- Network segmentation
- Secure-by-default design
- Governance as Code
- Cost-aware security
- Auditability
- DevSecOps validation

## Residual Risks

- No private VM deployed yet
- No centralized logging workspace deployed
- No Key Vault deployed in this version
- No Microsoft Defender for Cloud paid plan enabled

## Future Mitigations

- Add private Ubuntu VM without public IP
- Add Azure Key Vault
- Add Log Analytics
- Add custom Azure Policies
- Review and remediate Checkov findings
