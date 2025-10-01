## Ghost Helm Chart

This Helm chart deploys [Ghost](https://ghost.org/) — a powerful open-source publishing platform — onto a Kubernetes cluster. It includes all necessary resources to run Ghost with secure defaults, optional persistence, autoscaling, Redis caching, External Secrets integration, and ingress support.

### Prerequisites

* Kubernetes 1.16+ cluster
* Helm 3.x
* (Optional) Cert-Manager when using TLS via Ingress
* (Optional) A StorageClass for PersistentVolumeClaims
* (Optional) External Secrets Operator for secrets management

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

### Ghost Application

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `nameOverride`                                  | Override the chart name                                     | `""`                                                |
| `fullnameOverride`                              | Override the full resource name                             | `""`                                                |
| `component`                                     | Component label for resources                               | `ghost`                                             |
| `tier`                                          | Tier label for resources                                    | `blog`                                              |
| `replicaCount`                                  | Number of Ghost replicas                                    | `1`                                                 |
| `image.repository`                              | Ghost container image repository                            | `ghost`                                             |
| `image.tag`                                     | Ghost image tag                                             | `5-alpine`                                          |
| `image.pullPolicy`                              | Image pull policy                                           | `IfNotPresent`                                      |
| `imagePullSecrets`                              | Image pull secrets                                          | `[]`                                                |
| `imageCredentials.registry`                     | Private registry URL                                        | `""`                                                |
| `imageCredentials.username`                     | Private registry username                                   | `""`                                                |
| `imageCredentials.password`                     | Private registry password                                   | `""`                                                |
| `imageCredentials.email`                        | Private registry email                                      | `""`                                                |
| `env.normal`                                    | Array of normal environment variables                       | `[]`                                                |
| `env.secret`                                    | Array of secret environment variables                       | `[]`                                                |
| `serviceAccount.create`                         | Create ServiceAccount                                       | `true`                                              |
| `serviceAccount.name`                           | Name of the ServiceAccount                                  | generated                                           |
| `serviceAccount.automount`                      | Automount SA token                                          | `false`                                             |
| `serviceAccount.annotations`                    | ServiceAccount annotations                                  | `{}`                                                |
| `podAnnotations`                                | Annotations to add to pods                                  | `{}`                                                |
| `podLabels`                                     | Labels to add to pods                                       | `{}`                                                |
| `podSecurityContext`                            | Pod-level security context                                  | `{}`                                                |
| `securityContext.capabilities.drop`             | Dropped capabilities                                        | `["ALL"]`                                           |
| `securityContext.readOnlyRootFilesystem`        | Read-only root filesystem                                   | `false`                                             |
| `securityContext.runAsNonRoot`                  | Run as non-root user                                        | `true`                                              |
| `securityContext.runAsUser`                     | User ID to run as                                           | `1000`                                              |
| `service.type`                                  | Service type                                                | `ClusterIP`                                         |
| `service.port`                                  | Service port                                                | `2368`                                              |
| `resources.limits.memory`                       | Memory limit for container                                  | `300Mi`                                             |
| `livenessProbe.exec.command`                    | Liveness probe command                                      | `wget` with X-Forwarded-Proto header                |
| `livenessProbe.initialDelaySeconds`             | Liveness probe initial delay                                | `60`                                                |
| `livenessProbe.timeoutSeconds`                  | Liveness probe timeout                                      | `5`                                                 |
| `livenessProbe.periodSeconds`                   | Liveness probe period                                       | `30`                                                |
| `livenessProbe.failureThreshold`                | Liveness probe failure threshold                            | `3`                                                 |
| `readinessProbe.exec.command`                   | Readiness probe command                                     | `wget` with X-Forwarded-Proto header                |
| `readinessProbe.initialDelaySeconds`            | Readiness probe initial delay                               | `30`                                                |
| `readinessProbe.timeoutSeconds`                 | Readiness probe timeout                                     | `5`                                                 |
| `readinessProbe.periodSeconds`                  | Readiness probe period                                      | `10`                                                |
| `readinessProbe.failureThreshold`               | Readiness probe failure threshold                           | `3`                                                 |
| `volumes`                                       | Additional volumes                                          | node-cache emptyDir                                 |
| `volumeMounts`                                  | Additional volume mounts                                    | node-cache at /home/node/.cache                     |
| `nodeSelector`                                  | Node selector for deployment                                | `{}`                                                |
| `tolerations`                                   | Pod tolerations                                             | `[]`                                                |
| `affinity.nodeAffinity`                         | Node affinity rules                                         | Linux nodes only                                    |
| `affinity.podAntiAffinity`                      | Pod anti-affinity rules                                     | Prefer spreading across nodes                       |

### Network Policy

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `networkPolicy.enabled`                         | Enable NetworkPolicy                                        | `true`                                              |
| `networkPolicy.ingress`                         | Ingress rules for NetworkPolicy                             | allow from all pods                                 |
| `networkPolicy.policyTypes`                     | Policy types                                                | `["Ingress"]`                                       |

### Ingress

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `ingress.enabled`                               | Enable Ingress                                              | `false`                                             |
| `ingress.className`                             | IngressClass name                                           | `""`                                                |
| `ingress.annotations`                           | Annotations for Ingress                                     | `{}`                                                |
| `ingress.hosts`                                 | List of hosts and paths                                     | chart-example.local                                 |
| `ingress.tls`                                   | TLS configuration for Ingress                               | `[]`                                                |

### Autoscaling

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `autoscaling.enabled`                           | Enable HPA                                                  | `false`                                             |
| `autoscaling.minReplicas`                       | Minimum number of pods                                      | `1`                                                 |
| `autoscaling.maxReplicas`                       | Maximum number of pods                                      | `100`                                               |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization (%)                               | `80`                                                |

### Persistence

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `persistence.enabled`                           | Enable PVC for content                                      | `false`                                             |
| `persistence.accessMode`                        | PVC access mode                                             | `ReadWriteOnce`                                     |
| `persistence.size`                              | PVC size                                                    | `2Gi`                                               |
| `persistence.storageClass`                      | StorageClass for PVC                                        | `""`                                                |
| `persistence.mountPath`                         | Mount path inside container                                 | `/var/lib/ghost/content`                            |
| `persistence.existingClaim`                     | Use existing PVC instead of creating new one                | `""`                                                |

### External Secrets

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `externalSecrets.enabled`                       | Enable External Secrets Operator integration                | `false`                                             |
| `externalSecrets.refreshInterval`               | How often to sync secrets from remote                       | `1h`                                                |
| `externalSecrets.awsProvider.enabled`           | Enable AWS Secrets Manager provider                         | `false`                                             |
| `externalSecrets.awsProvider.region`            | AWS region                                                  | `eu-central-1`                                      |
| `externalSecrets.awsProvider.iam.accessKey`     | AWS IAM access key                                          | `""`                                                |
| `externalSecrets.awsProvider.iam.secretAccessKey` | AWS IAM secret access key                                 | `""`                                                |
| `externalSecrets.data`                          | Array of secret mappings                                    | `[]`                                                |

### Redis Cache (Optional Component)

| Parameter                                       | Description                                                 | Default                                             |
| ----------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| `redis.enable`                                  | Enable Redis caching component                              | `false`                                             |
| `redis.fullnameOverride`                        | Override Redis full name                                    | `""`                                                |
| `redis.component`                               | Component label for Redis                                   | `redis`                                             |
| `redis.tier`                                    | Tier label for Redis                                        | `cache`                                             |
| `redis.replicaCount`                            | Number of Redis replicas                                    | `1`                                                 |
| `redis.image.repository`                        | Redis image repository                                      | `redis`                                             |
| `redis.image.tag`                               | Redis image tag                                             | `8-alpine`                                          |
| `redis.image.pullPolicy`                        | Redis image pull policy                                     | `IfNotPresent`                                      |
| `redis.imagePullSecrets`                        | Redis image pull secrets                                    | `[]`                                                |
| `redis.env.normal`                              | Redis normal environment variables                          | `[]`                                                |
| `redis.env.secret`                              | Redis secret environment variables                          | `[]`                                                |
| `redis.serviceAccount.create`                   | Create Redis ServiceAccount                                 | `true`                                              |
| `redis.serviceAccount.automount`                | Automount Redis SA token                                    | `false`                                             |
| `redis.serviceAccount.annotations`              | Redis ServiceAccount annotations                            | `{}`                                                |
| `redis.serviceAccount.name`                     | Redis ServiceAccount name                                   | generated                                           |
| `redis.podAnnotations`                          | Redis pod annotations                                       | `{}`                                                |
| `redis.podLabels`                               | Redis pod labels                                            | `{}`                                                |
| `redis.podSecurityContext`                      | Redis pod security context                                  | `{}`                                                |
| `redis.securityContext.capabilities.drop`       | Redis dropped capabilities                                  | `["ALL"]`                                           |
| `redis.securityContext.readOnlyRootFilesystem`  | Redis read-only root filesystem                             | `true`                                              |
| `redis.securityContext.runAsNonRoot`            | Redis run as non-root                                       | `true`                                              |
| `redis.securityContext.runAsUser`               | Redis user ID                                               | `999`                                               |
| `redis.service.type`                            | Redis service type                                          | `ClusterIP`                                         |
| `redis.service.port`                            | Redis service port                                          | `6379`                                              |
| `redis.networkPolicy.enabled`                   | Enable Redis NetworkPolicy                                  | `true`                                              |
| `redis.networkPolicy.ingress`                   | Redis ingress rules                                         | allow from all pods                                 |
| `redis.networkPolicy.policyTypes`               | Redis policy types                                          | `["Ingress"]`                                       |
| `redis.resources.limits.memory`                 | Redis memory limit                                          | `300Mi`                                             |
| `redis.livenessProbe.exec.command`              | Redis liveness probe command                                | `redis-cli ping`                                    |
| `redis.livenessProbe.initialDelaySeconds`       | Redis liveness probe initial delay                          | `10`                                                |
| `redis.livenessProbe.periodSeconds`             | Redis liveness probe period                                 | `10`                                                |
| `redis.readinessProbe.exec.command`             | Redis readiness probe command                               | `redis-cli ping`                                    |
| `redis.readinessProbe.initialDelaySeconds`      | Redis readiness probe initial delay                         | `5`                                                 |
| `redis.readinessProbe.periodSeconds`            | Redis readiness probe period                                | `5`                                                 |
| `redis.autoscaling.enabled`                     | Enable Redis HPA                                            | `false`                                             |
| `redis.volumes`                                 | Redis additional volumes                                    | `[]`                                                |
| `redis.volumeMounts`                            | Redis additional volume mounts                              | `[]`                                                |
| `redis.nodeSelector`                            | Redis node selector                                         | `{}`                                                |
| `redis.tolerations`                             | Redis tolerations                                           | `[]`                                                |
| `redis.affinity.nodeAffinity`                   | Redis node affinity                                         | Linux nodes only                                    |

## Resource Details

### NetworkPolicy

When `networkPolicy.enabled=true`, a NetworkPolicy is created to allow ingress to Ghost pods from any other pod by default. Customize `networkPolicy.ingress` and `networkPolicy.policyTypes` to tighten access controls.

### ServiceAccount

A dedicated ServiceAccount (`{{ .Release.Name }}-ghost`) is created with `automountServiceAccountToken=false` for security. Use `serviceAccount.name` to reference an existing SA instead.

### Environment Variables

Define environment variables using arrays in values:

```yaml
env:
  normal:
    - name: NODE_ENV
      value: "production"
    - name: url
      value: "https://blog.example.com"
  secret:
    - name: database__connection__password
      valueFrom:
        secretKeyRef:
          name: ghost-secrets
          key: db-password
```

### External Secrets Operator

When `externalSecrets.enabled=true`, the chart integrates with the [External Secrets Operator](https://external-secrets.io/) to sync secrets from external secret management systems like AWS Secrets Manager, HashiCorp Vault, or Azure Key Vault.

Example configuration for AWS Secrets Manager:

```yaml
externalSecrets:
  enabled: true
  refreshInterval: "1h"
  awsProvider:
    enabled: true
    region: eu-central-1
    iam:
      accessKey: "AKIAIOSFODNN7EXAMPLE"
      secretAccessKey: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  data:
    - secretKey: database__connection__password
      envName: database__connection__password
      remoteRef:
        key: ghost-production-secrets
        property: db_password
    - secretKey: mail__options__auth__pass
      envName: mail__options__auth__pass
      remoteRef:
        key: ghost-production-secrets
        property: smtp_password
        version: "AWSCURRENT"
```

The External Secrets Operator will:
1. Connect to AWS Secrets Manager using the provided IAM credentials
2. Fetch secrets from the specified keys
3. Create Kubernetes secrets that are mounted as environment variables in Ghost pods
4. Automatically refresh secrets based on the `refreshInterval`

### Persistent Volume Claim

If `persistence.enabled=true`, a PVC is created to store Ghost content under `/var/lib/ghost/content`. This ensures your blog posts, images, and themes persist across pod restarts.

Example with existing claim:

```yaml
persistence:
  enabled: true
  existingClaim: "my-existing-ghost-pvc"
```

Or create a new PVC:

```yaml
persistence:
  enabled: true
  size: 10Gi
  storageClass: "fast-ssd"
  accessMode: ReadWriteOnce
```

### Deployment

* Uses `ghost:5-alpine` by default to serve Ghost content; adjust `image.repository` and `image.tag` as needed.
* Security context drops all capabilities, runs as non-root user `1000`.
* Probes configured using `wget` commands with `X-Forwarded-Proto` header for liveness/readiness checks.
* Rolling update strategy: `maxSurge=1`, `maxUnavailable=0`.
* Default volumes include a node-cache emptyDir mounted at `/home/node/.cache` for npm caching.

### Horizontal Pod Autoscaler

When `autoscaling.enabled=true`, an HPA scales the Ghost deployment based on memory utilization (default 80%).

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetMemoryUtilizationPercentage: 75
```

### Ingress

When `ingress.enabled=true`, an Ingress resource is created. Configure host rules, TLS, and annotations (e.g., enable `cert-manager` cluster issuer).

Example with TLS:

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
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

### Redis Cache Component

The chart includes an optional Redis component that can be enabled for caching. When `redis.enable=true`, a Redis deployment is created alongside Ghost.

Example configuration:

```yaml
redis:
  enable: true
  replicaCount: 1
  resources:
    limits:
      memory: "512Mi"
  env:
    normal:
      - name: REDIS_MAXMEMORY
        value: "256mb"
      - name: REDIS_MAXMEMORY_POLICY
        value: "allkeys-lru"
```

To connect Ghost to Redis, configure Ghost's environment variables:

```yaml
env:
  normal:
    - name: adapters__cache__Redis
      value: "true"
    - name: adapters__cache__Redis__host
      value: "{{ .Release.Name }}-redis"
    - name: adapters__cache__Redis__port
      value: "6379"
```

### Container Registry Credentials

A pre-install hook creates a `dockerconfigjson` secret (`container-registry-cred`) for pulling private images. Provide `imageCredentials` or manually create `imagePullSecrets`.

```yaml
imageCredentials:
  registry: myregistry.io
  username: myuser
  password: mypassword
  email: user@example.com

# Or reference existing secret:
imagePullSecrets:
  - name: my-existing-registry-secret
```

## Customizing the Chart

You can override any parameter in the `values.yaml` or by using `--set`. For advanced customization, modify the templates directly or contribute to the chart on GitHub.

## Contributing

Contributions are welcome! Please open issues or pull requests against this repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
