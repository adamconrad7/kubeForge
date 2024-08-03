# KubeForge

KubeForge is a comprehensive Kubernetes provisioner. It provides a complete stack for setting up a Kubernetes cluster on AWS EC2 instances using Terraform and Ansible.

## Latest Update
- Automatic Cilium installation and configuration with Ansible

## Prerequisites

Before you begin, ensure you have the following:

1. An AWS account with billing enabled
2. Terraform installed locally
3. Ansible installed locally
4. Git installed locally

## Quick Start

1. Clone the repository:
   ```
   git clone https://github.com/adamconrad7/kubeforge.git
   cd kubeforge
   ```

2. Set up your AWS credentials:
   ```
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   ```

3. Run the setup script:
   ```
   ./scripts/setup.sh
   ```

This script will:
- Use Terraform to provision EC2 instances on AWS
- Use Ansible to install and configure K3s, Cilium, and other components
- Set up monitoring with Prometheus and Grafana
- Deploy Argo Workflows and Argo CD

## Project Structure

- `terraform/`: Contains Terraform configurations for AWS infrastructure
- `ansible/`: Contains Ansible playbooks and roles for cluster setup
- `kubernetes/`: Contains Kubernetes manifests and Helm charts
- `argo/`: Contains Argo Workflows and CD configurations
- `monitoring/`: Contains Prometheus and Grafana configurations
- `scripts/`: Contains utility scripts for setup and teardown

## Cleanup

To tear down the infrastructure and clean up resources:

```
./scripts/teardown.sh
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
## OpsMaxing

