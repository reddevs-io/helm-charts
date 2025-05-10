# Next.js Helm Chart

This Helm chart deploys a Next.js application along with a Redis cache to a Kubernetes cluster. It provides all the necessary Kubernetes resources for a production-ready deployment, including Deployments, Services, Persistent Volume Claims, Ingress, Horizontal Pod Autoscaler, ServiceAccounts, and initialization Jobs.

## Components

- **Next.js Application**: Deployed as a Kubernetes Deployment, exposed via a Service and Ingress, and configured with a Persistent Volume Claim for data storage.
- **Redis Cache**: Deployed as a separate Deployment and Service, providing caching capabilities for the Next.js application.
- **ServiceAccounts**: Separate ServiceAccounts for the Next.js app and Redis, with security best practices applied.
- **Secrets**: Docker registry credentials for pulling images from a private registry.
- **Horizontal Pod Autoscaler**: Automatically scales the Next.js deployment based on CPU utilization.
- **Init Job**: Runs initialization tasks before the main application starts.

## Prerequisites

- Kubernetes cluster (version 1.16+ recommended)
- Helm 3.x installed
- Persistent storage provisioner available in the cluster

## Installation

To install the chart with the default values, run:

````shell
helm install release-name charts/nextjs
````

To customize the deployment, create a `values.yaml` file and pass it to the install command:

````shell
helm install release-name charts/nextjs -f values.yaml
````

## Configuration

The following configuration options are available and can be set in your `values.yaml` file:

- **image.repository**: The container image repository for the Next.js app.
- **image.tag**: The image tag to deploy.
- **redis.image.repository**: The container image repository for Redis.
- **redis.image.tag**: The Redis image tag to deploy.
- **service.type**: The type of Kubernetes Service to create (default: ClusterIP).
- **ingress.enabled**: Enable or disable Ingress resource.
- **ingress.hosts**: List of hostnames for the Ingress.
- **persistence.enabled**: Enable or disable persistent storage for Next.js.
- **persistence.size**: Size of the persistent volume claim.
- **hpa.enabled**: Enable or disable Horizontal Pod Autoscaler.
- **hpa.minReplicas**: Minimum number of replicas for the Next.js deployment.
- **hpa.maxReplicas**: Maximum number of replicas for the Next.js deployment.
- **hpa.targetCPUUtilizationPercentage**: Target CPU utilization for scaling.

Refer to the `values.yaml` file for a complete list of configurable parameters.

## Resources Created

- Deployment for Next.js application
- Deployment for Redis cache
- Service for Next.js application (port 3000)
- Service for Redis (port 6379)
- PersistentVolumeClaim for Next.js data
- Ingress for external access to the Next.js app
- ServiceAccounts for both Next.js and Redis
- Secret for Docker registry credentials
- HorizontalPodAutoscaler for Next.js
- Initialization Job for pre-install and pre-upgrade hooks

## Security

- ServiceAccounts are created with `automountServiceAccountToken: false` for improved security.
- Containers run as non-root users and drop all Linux capabilities.
- Secrets are used for Docker registry authentication.

## Uninstallation

To uninstall the chart and delete all associated resources, run:
````shell
helm uninstall release-name
````


## License

This Helm chart is provided under the MIT License.

## Support

For issues, questions, or feature requests, please open an issue in the repository where this chart is maintained.
