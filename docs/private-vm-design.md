# Private Virtual Machine Design

## Objective

A private Ubuntu virtual machine is planned as a future workload inside the private subnet.

## Planned Configuration

- Operating System: Ubuntu Server
- Subnet: subnet-private
- Public IP: Disabled
- Access: Management subnet or Bastion in future version
- NSG: nsg-private-subnet

## Security Benefits

- No direct exposure to the Internet
- Network isolation
- Controlled administrative access
- Reduced attack surface

## Cost Decision

The VM was not deployed in this version to maintain a zero-cost implementation model.
