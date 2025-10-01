# RedDevs Helm Charts Repository

Welcome to the official Helm chart repository for RedDevs!  

This repository hosts production-ready Helm charts for deploying various applications and services on Kubernetes. Each chart is designed with security best practices, scalability, and ease of use in mind.

## 🚀 Quick Start

### Add the Helm Repository

```bash
helm repo add reddevs https://charts.reddevs.io
helm repo update
```

### Install a Chart

```bash
# Example: Install Ghost blogging platform
helm install my-ghost reddevs/ghost

# Example: Install Next.js application
helm install my-nextjs reddevs/nextjs
```

## 📦 Available Charts

| Chart | Version | App Version | Description |
|-------|---------|-------------|-------------|
| [ghost](charts/ghost) | 1.3.1 | 5-alpine | Open-source publishing platform for professional bloggers |
| [nextjs](charts/nextjs) | 1.4.1 | 1.16.0 | Production-ready Next.js application deployment |
| [outline](charts/outline) | 1.2.1 | 0.87.4 | Modern team wiki and documentation platform |
| [symfony](charts/symfony) | - | - | PHP Symfony framework application deployment |
| [vite](charts/vite) | - | - | Modern frontend build tool and development server |
| [wordpress](charts/wordpress) | - | - | Popular content management system (CMS) |

## ✨ Key Features

All charts in this repository include:

- **Security First**: Non-root containers, dropped capabilities, read-only root filesystems where applicable
- **Network Policies**: Built-in NetworkPolicy support for pod-to-pod communication control
- **Autoscaling**: Horizontal Pod Autoscaler (HPA) support for dynamic scaling
- **Persistence**: PersistentVolumeClaim support for stateful applications
- **Ingress**: Configurable ingress with TLS/SSL support
- **External Secrets**: Integration with External Secrets Operator for secure secrets management
- **Service Accounts**: Dedicated ServiceAccounts with minimal permissions
- **Health Checks**: Liveness and readiness probes configured
- **Resource Management**: Sensible resource limits and requests
- **High Availability**: Pod anti-affinity rules for spreading across nodes

## 📋 Prerequisites

- **Kubernetes**: 1.16+ cluster
- **Helm**: 3.x
- **Optional**: 
  - [cert-manager](https://cert-manager.io/) for automatic TLS certificate management
  - [External Secrets Operator](https://external-secrets.io/) for secrets management
  - StorageClass configured for PersistentVolumeClaims

## 📖 Chart Documentation

Each chart includes comprehensive documentation with:
- Detailed configuration parameters
- Installation and upgrade instructions
- Examples and use cases
- Troubleshooting guides

Visit the individual chart directories for complete documentation:
- [Ghost Chart Documentation](charts/ghost/README.md)
- [Next.js Chart Documentation](charts/nextjs/README.md)
- [Outline Chart Documentation](charts/outline/README.md)
- [Symfony Chart Documentation](charts/symfony/README.md)
- [Vite Chart Documentation](charts/vite/README.md)
- [WordPress Chart Documentation](charts/wordpress/README.md)

## 🔧 Configuration

All charts support extensive customization through `values.yaml`. You can override default values using:

```bash
# Using --set flag
helm install my-release reddevs/chart-name \
  --set replicaCount=3 \
  --set ingress.enabled=true

# Using custom values file
helm install my-release reddevs/chart-name -f custom-values.yaml
```

## 🔄 Upgrading Charts

```bash
# Update repository
helm repo update

# Upgrade release
helm upgrade my-release reddevs/chart-name

# Upgrade with new values
helm upgrade my-release reddevs/chart-name -f updated-values.yaml
```

## 🗑️ Uninstalling Charts

```bash
helm uninstall my-release
```

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your changes:
- Follow Helm best practices
- Include appropriate documentation
- Pass linting with `helm lint`
- Include examples where applicable

## 🐛 Issues and Support

If you encounter any issues or have questions:
- Open an issue on [GitHub](https://github.com/reddevs-io/helm-charts/issues)
- Check existing issues for solutions
- Provide detailed information about your environment and the problem

## 👥 Maintainers

- **Francis Makokha**
  - Email: francis@reddevs.io
  - Website: [blog.reddevs.io](https://blog.reddevs.io)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Chart Repository**: https://charts.reddevs.io
- **GitHub Repository**: https://github.com/reddevs-io/helm-charts
- **Documentation**: Individual chart READMEs in the `charts/` directory

---

Made with ❤️ by [RedDevs](https://blog.reddevs.io)
