# Azure Secure Landing Zone Architecture

## Overview

This project implements a secure Azure Landing Zone using core Azure networking and security services.

The objective is to demonstrate:

- Network segmentation
- Security boundaries
- Least privilege access control
- Cost-aware cloud design

---

## Network Architecture

Virtual Network:

10.0.0.0/16

Subnets:

- Management Subnet (10.0.1.0/24)
- Private Subnet (10.0.2.0/24)
- Workload Subnet (10.0.3.0/24)

---

## Security Controls

### Network Security Group

The private subnet is protected using a Network Security Group.

Implemented rule:

- Deny-Internet-Inbound

This prevents direct inbound traffic from the Internet.

### RBAC

Role Based Access Control was configured following the Principle of Least Privilege.

Assigned Role:

- Reader

The assigned user can view resources but cannot modify them.
