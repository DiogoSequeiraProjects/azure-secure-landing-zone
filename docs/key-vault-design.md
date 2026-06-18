# Azure Key Vault Design

## Objective

Azure Key Vault is planned as a future improvement for this landing zone to centralize secrets, keys and certificates.

## Planned Use Cases

- Store administrative secrets
- Store application secrets
- Avoid hardcoded credentials
- Support secure workload deployments

## Security Benefits

- Centralized secret management
- Access controlled through Azure RBAC
- Auditability
- Integration with managed identities

## Cost Decision

Azure Key Vault was not deployed in the current version to keep the project within a strict zero-cost implementation model.

It remains documented as a planned security enhancement.
