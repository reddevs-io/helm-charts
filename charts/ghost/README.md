## Ghost Helm Chart

This Helm chart deploys [Ghost](https://ghost.org/) — a powerful open-source publishing platform — onto a Kubernetes cluster. It includes all necessary resources to run Ghost with secure defaults, optional persistence, autoscaling, and ingress support.

### Prerequisites

* Kubernetes 1.16+ cluster
* Helm 3.x
* (Optional) Cert-Manager when using TLS via Ingress
* (Optional) A StorageClass for PersistentVolumeClaims

### Installing the Chart

To install the chart with the release name `my-ghost`:

```bash
helm repo add reddevs https://charts.reddevs.io
helm repo update
helm install my-ghost reddevs/ghost
```

You can override default values with `--set` or provide a custom `values.yaml`:

```bash
helm install my-ghost reddevs/ghost \
  --set replicaCount=2 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=blog.example.com \
  --set persistence.enabled=true \
  --set persistence.size=5Gi
```

### Upgrading the Chart

```bash
helm upgrade my-ghost reddevs/ghost
```

Review the [Helm upgrade guide](https://helm.sh/docs/helm/helm_upgrade/) for details on upgrading in-place.

### Uninstalling the Chart

```bash
helm uninstall my-ghost
```

This will remove all Kubernetes resources associated with the chart.

## Configuration

The following table lists the configurable parameters of the Ghost chart and their default values.

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `nameOverride`                                  | Override the chart name                                     | `""`                                                |
| `fullnameOverride`                              | Override the full resource name                             | `""`                                                |
| `replicaCount`                                  | Number of Ghost replicas                                    | `1`                                                 |
| `image.repository`                              | Ghost container image repository                            | `ghost`                                             |
| `image.tag`                                     | Ghost image tag                                             | `5-alpine`                                          |
| `image.pullPolicy`                              | Image pull policy                                           | `IfNotPresent`                                      |
| `imageCredentials`                              | Private registry credentials (registry, username, password) | `{}`                                                |
| `serviceAccount.create`                         | Create ServiceAccount                                       | `true`                                              |
| `serviceAccount.name`                           | Name of the ServiceAccount                                  | generated                                           |
| `serviceAccount.automount`                      | Automount SA token                                          | `false`                                             |
| `podAnnotations`                                | Annotations to add to pods                                  | `{}`                                                |
| `podLabels`                                     | Labels to add to pods                                       | `{}`                                                |
| `podSecurityContext`                            | Pod-level security context                                  | `{}`                                                |
| `securityContext`                               | Container-level security context                            | drops all capabilities, runs as non-root (uid 1000) |
| `service.type`                                  | Service type                                                | `ClusterIP`                                         |
| `service.port`                                  | Service port                                                | `2368`                                              |
| `networkPolicy.enabled`                         | Enable NetworkPolicy                                        | `true`                                              |
| `networkPolicy.ingress`                         | Ingress rules for NetworkPolicy                             | allow from all pods                                 |
| `ingress.enabled`                               | Enable Ingress                                              | `false`                                             |
| `ingress.className`                             | IngressClass name                                           | `""`                                                |
| `ingress.annotations`                           | Annotations for Ingress                                     | `{}`                                                |
| `ingress.hosts`                                 | List of hosts and paths                                     | chart-example.local                                 |
| `ingress.tls`                                   | TLS configuration for Ingress                               | `[]`                                                |
| `resources.limits.memory`                       | Memory limit for container                                  | `300Mi`                                             |
| `livenessProbe`                                 | Liveness probe settings                                     | http GET `/`, delay 10s, period 10s                 |
| `readinessProbe`                                | Readiness probe settings                                    | http GET `/`, delay 5s,  period 5s                  |
| `autoscaling.enabled`                           | Enable HPA                                                  | `false`                                             |
| `autoscaling.minReplicas`                       | Minimum number of pods                                      | `1`                                                 |
| `autoscaling.maxReplicas`                       | Maximum number of pods                                      | `100`                                               |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization (%)                               | `80`                                                |
| `persistence.enabled`                           | Enable PVC for content                                      | `false`                                             |
| `persistence.accessMode`                        | PVC access mode                                             | `ReadWriteOnce`                                     |
| `persistence.size`                              | PVC size                                                    | `1Gi`                                               |
| `persistence.storageClass`                      | StorageClass for PVC                                        | `""`                                                |
| `persistence.mountPath`                         | Mount path inside container                                 | `/var/lib/ghost/content`                            |
| `nodeSelector`                                  | Node selector for deployment                                | `{}`                                                |
| `tolerations`                                   | Pod tolerations                                             | `[]`                                                |
| `affinity`                                      | Pod affinity/anti-affinity rules                            | linux-only node affinity                            |

## Resource Details

### NetworkPolicy

When `networkPolicy.enabled=true`, a NetworkPolicy is created to allow ingress to Ghost pods from any other pod by default. Customize `networkPolicy.ingress` and `networkPolicy.policyTypes` to tighten access controls.

### ServiceAccount

A dedicated ServiceAccount (`{{ .Release.Name }}-ghost`) is created with `automountServiceAccountToken=false` for security. Use `serviceAccount.name` to reference an existing SA instead.

### Secrets & ConfigMap

* **Secret**: Holds sensitive variables (`env.secret`) for Ghost: `TEST_SECRET_VARIABLE_1`, `TEST_SECRET_VARIABLE_2`, etc.
* **ConfigMap**: Holds non-sensitive variables (`env.normal`) such as `TEST_VARIABLE_1`, `TEST_VARIABLE_2`.

Define environment variables in values:

```yaml
env:
  normal:
    - name: KEY1
      value: "value1"
  secret:
    - name: PASSWORD
      valueFrom:
        secretKeyRef:
          name: mysecret
          key: password
```

### Persistent Volume Claim

If `persistence.enabled=true`, a PVC is created to store Ghost content under `/var/lib/ghost/content`. See the `persistence` section in [Values](#configuration).

### Deployment

* Uses `ghost:5-alpine` by default to serve Ghost content; adjust `image.repository` and `image.tag` as needed.
* Security context drops all capabilities, runs as non-root user `1000`.
* Probes configured for liveness/readiness by default.
* Rolling update strategy: `maxSurge=1`, `maxUnavailable=0`.

### Horizontal Pod Autoscaler

When `autoscaling.enabled=true`, an HPA scales the Ghost deployment based on CPU and memory utilization (default 80%).

### Ingress

When `ingress.enabled=true`, an Ingress resource is created. Configure host rules, TLS, and annotations (e.g., enable `cert-manager` cluster issuer).

Example:

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: blog.example.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - blog.example.com
      secretName: blog-example-tls
```

### Container Registry Credentials

A pre-install hook creates a `dockerconfigjson` secret (`container-registry-cred`) for pulling private images. Provide `imageCredentials` or manually create `imagePullSecrets`.

```yaml
imageCredentials:
  registry: myregistry.io
  username: user
  password: pass

# Or:
imagePullSecrets:
  - name: container-registry-cred
```

## Customizing the Chart

You can override any parameter in the `values.yaml` or by using `--set`. For advanced customization, modify the templates directly or contribute to the chart on GitHub.

## Contributing

Contributions are welcome! Please open issues or pull requests against this repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
