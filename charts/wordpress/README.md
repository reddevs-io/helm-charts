# WordPress Helm Chart

This Helm chart deploys [WordPress](https://wordpress.org/) — a widely used open-source content management system — onto a Kubernetes cluster. It includes secure defaults, optional ExternalSecrets integration, persistence (themes, plugins, uploads), autoscaling, and Ingress support.

## Prerequisites

* Kubernetes 1.16+  
* Helm 3.x  
* (Optional) Cert-Manager for TLS via Ingress  
* (Optional) A StorageClass for PersistentVolumeClaims  
* (Optional) AWS IAM & ExternalSecrets setup if using `externalSecrets`

## Installing the Chart

Add the RedDevs repository and install the chart:

```bash
helm repo add reddevs https://charts.reddevs.io
helm repo update
helm install my-wordpress reddevs/wordpress
```

Override default values with `--set` or a custom `values.yaml`:

```bash
helm install my-wordpress reddevs/wordpress \
  --set image.repository=wordpress \
  --set image.tag=5.8-apache \
  --set replicaCount=2 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=blog.example.com \
  --set externalSecrets.enabled=true \
  --set externalSecrets.awsProvider.enabled=true \
  --set externalSecrets.data[0].secretKey=DATABASE_PASSWORD \
  --set externalSecrets.data[0].remoteRef.key=my-aws-secret \
  --set externalSecrets.data[0].remoteRef.property=password
```

## Upgrading the Chart

```bash
helm upgrade my-wordpress reddevs/wordpress
```

## Uninstalling the Chart

```bash
helm uninstall my-wordpress
```

## Configuration

The following table lists commonly used configurable parameters of the WordPress chart and their default values. See `values.yaml` for the full list.

| Parameter                                         | Description                                                      | Default                       |
| ------------------------------------------------- | ---------------------------------------------------------------- | ----------------------------- |
| `nameOverride`                                    | Override the chart name                                          | `""`                          |
| `fullnameOverride`                                | Override the full resource name                                  | `""`                          |
| `replicaCount`                                    | Number of WordPress replicas                                     | `1`                           |
| `image.repository`                                | WordPress container image repository                             | `""`                          |
| `image.tag`                                       | WordPress image tag                                              | `""` (appVersion: "1.16.0")   |
| `image.pullPolicy`                                | Image pull policy                                                | `IfNotPresent`                |
| `imageCredentials.registry`                       | Registry for private images                                      | `""`                          |
| `imageCredentials.username`                       | Username for private registry                                    | `""`                          |
| `imageCredentials.password`                       | Password for private registry                                    | `""`                          |
| `imageCredentials.email`                          | Email for private registry                                       | `""`                          |
| `imagePullSecrets`                                | Image pull secrets for private registry                          | `[]`                          |
| `env.normal`                                      | List of non-sensitive environment variables                      | `[]`                          |
| `env.secret`                                      | List of secret environment variables                             | `[]`                          |
| `externalSecrets.enabled`                         | Enable ExternalSecrets integration                               | `false`                       |
| `externalSecrets.refreshInterval`                 | Refresh interval for ExternalSecrets                             | `"1h"`                        |
| `externalSecrets.awsProvider.enabled`             | Enable AWS provider for ExternalSecrets                          | `false`                       |
| `phpIni.memory_limit`                             | PHP `memory_limit` setting                                       | `"200M"`                      |
| `serviceAccount.create`                           | Create a Kubernetes ServiceAccount                               | `true`                        |
| `serviceAccount.automount`                        | Automount ServiceAccount token                                   | `true`                        |
| `securityContext.readOnlyRootFilesystem`          | Enforce read-only root filesystem                                | `true`                        |
| `securityContext.runAsNonRoot`                    | Run container as non-root                                        | `true`                        |
| `service.type`                                    | Kubernetes Service type                                          | `ClusterIP`                   |
| `service.port`                                    | Service port                                                     | `80`                          |
| `ingress.enabled`                                 | Enable Ingress                                                   | `false`                       |
| `ingress.className`                               | IngressClass name                                                | `""`                          |
| `ingress.annotations`                             | Annotations to add to Ingress                                    | `{}`                          |
| `ingress.hosts`                                   | Ingress host definitions                                         | `- host: chart-example.local` |
| `ingress.tls`                                     | TLS configuration for Ingress                                    | `[]`                          |
| `autoscaling.enabled`                             | Enable Horizontal Pod Autoscaler                                 | `false`                       |
| `resources.limits.memory`                         | Memory limit for container                                       | `"200Mi"`                     |
| `livenessProbe.httpGet.path`                      | Path for liveness probe                                          | `/`                           |
| `livenessProbe.httpGet.port`                      | Port for liveness probe                                          | `http`                        |
| `readinessProbe.httpGet.path`                     | Path for readiness probe                                         | `/`                           |
| `readinessProbe.httpGet.port`                     | Port for readiness probe                                         | `http`                        |
| `networkPolicy.enabled`                           | Enable NetworkPolicy                                             | `true`                        |
| `nodeSelector`                                    | Node selector for pods                                           | `{}`                          |
| `tolerations`                                     | Pod tolerations                                                  | `[]`                          |
| `affinity`                                        | Pod affinity and anti-affinity rules                             | See `values.yaml`             |
| `persistence.enabled`                             | Enable persistence for themes, plugins, and uploads               | `false`                       |
| `persistence.themes.enabled`                      | Enable PVC for themes                                            | `true`                        |
| `persistence.themes.accessMode`                   | Access mode for themes PVC                                       | `ReadWriteMany`               |
| `persistence.themes.size`                         | Size of themes PVC                                               | `1Gi`                         |
| `persistence.themes.storageClass`                 | StorageClass for themes PVC                                      | `""`                          |
| `persistence.plugins.enabled`                     | Enable PVC for plugins                                           | `true`                        |
| `persistence.plugins.accessMode`                  | Access mode for plugins PVC                                      | `ReadWriteMany`               |
| `persistence.plugins.size`                        | Size of plugins PVC                                              | `1Gi`                         |
| `persistence.plugins.storageClass`                | StorageClass for plugins PVC                                     | `""`                          |
| `persistence.uploads.enabled`                     | Enable PVC for uploads                                           | `true`                        |
| `persistence.uploads.accessMode`                  | Access mode for uploads PVC                                      | `ReadWriteMany`               |
| `persistence.uploads.size`                        | Size of uploads PVC                                              | `2Gi`                         |
| `persistence.uploads.storageClass`                | StorageClass for uploads PVC                                     | `""`                          |

## Linter Configuration

Use the provided `linter-values.yaml` to validate chart rendering and policies:

```bash
helm lint charts/wordpress --values charts/wordpress/linter-values.yaml
```

## Resource Details

### NetworkPolicy

When `networkPolicy.enabled=true`, a NetworkPolicy is created to allow ingress to WordPress pods. Customize `networkPolicy.ingress` and `networkPolicy.policyTypes` as needed.

### ServiceAccount

A ServiceAccount is created by default. Use `serviceAccount.name` to reference an existing account or disable creation.

### Secrets & ConfigMap

- **ConfigMap**: Holds non-sensitive `env.normal` variables.  
- **Secret**: Holds `env.secret` variables for sensitive data.

### Deployment

The WordPress Deployment runs the specified image with PHP settings from `phpIni`, login to private registries if configured, and respects `securityContext`.

### Horizontal Pod Autoscaler

When `autoscaling.enabled=true`, an HPA scales the deployment based on CPU and memory utilization (defaults to 80%).

### Ingress

When `ingress.enabled=true`, an Ingress resource is created. Configure hosts, TLS, and annotations (e.g., Cert-Manager) via `ingress` values.

### PersistentVolumeClaims

When `persistence.enabled=true`, PersistentVolumeClaims are created for themes, plugins, and uploads. Configure each under the `persistence` section of `values.yaml`:

- **Themes** (`persistence.themes.*`): stores theme files.
- **Plugins** (`persistence.plugins.*`): stores plugin files.
- **Uploads** (`persistence.uploads.*`): stores media uploads.

Sub-options include `enabled`, `accessMode`, `size`, and `storageClass`.

### Volumes & VolumeMounts

Use the `volumes` and `volumeMounts` values to attach custom volumes (e.g., for uploads or caching).

## Usage Notes

Get the application URL by running these commands:

```bash
# If using Ingress:
echo "Application URL:"
kubectl get ingress --namespace <namespace> -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"

# If using NodePort:
export NODE_PORT=$(kubectl get --namespace <namespace> -o jsonpath="{.spec.ports[0].nodePort}" services RELEASE-NAME-wordpress)
export NODE_IP=$(kubectl get nodes --namespace <namespace> -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT

# If using ClusterIP + port-forward:
export POD_NAME=$(kubectl get pods --namespace <namespace> -l "app.kubernetes.io/name=wordpress,app.kubernetes.io/instance=<release>" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace <namespace> $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080"
kubectl --namespace <namespace> port-forward $POD_NAME 8080:$CONTAINER_PORT
```

## Contributing

Contributions are welcome! Please open issues or pull requests against this repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
