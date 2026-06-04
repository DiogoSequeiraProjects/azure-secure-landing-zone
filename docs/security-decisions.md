# Security Decisions

## Why subnet segmentation?

Subnet segmentation reduces the attack surface and isolates workloads.

The architecture separates:

- Management resources
- Private resources
- Workload resources

---

## Why use an NSG?

The NSG acts as a network-level firewall.

It was configured to deny inbound Internet traffic to the private subnet.

---

## Why use RBAC?

RBAC limits permissions according to user responsibilities.

The Reader role demonstrates Least Privilege by providing visibility without administrative rights.
