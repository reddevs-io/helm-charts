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

#### Upgrading to 1.5.0 — breaking selector change

Before 1.5.0 the Deployment and Service selectors included the version-bearing
labels `helm.sh/chart` and `app.kubernetes.io/version` plus
`app.kubernetes.io/managed-by`. Every chart-version bump therefore rewrote the
Deployment's `spec.selector`, which Kubernetes treats as **immutable** — the
upgrade fails with `field is immutable`. 1.5.0 narrows the selector to the stable
identity labels (`app`, `app.kubernetes.io/instance`, `app.kubernetes.io/name`,
`component`, `tier`) and keeps the full label set on resource metadata and pod
templates.

Existing releases must have their Deployments replaced once on the way to 1.5.0:

```bash
kubectl delete deployment my-ghost --cascade=orphan   # and my-ghost-redis if enabled
helm upgrade my-ghost reddevs/ghost
```

(`--cascade=orphan` keeps the running pods alive until the new Deployment adopts
them.) Under ArgoCD, either delete the Deployment the same way before the first
sync or let Argo replace it (`Replace=true` sync option) for that one sync.

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
| `imageCredentials.create`                       | Render the `container-registry-cred` Secret from the values below. Set `false` to let an external controller (e.g. ESO) own it | `true`            |
| `imageCredentials.registry`                     | Private registry URL (also gates the Secret: empty ⇒ not rendered) | `""`                                         |
| `imageCredentials.username`                     | Private registry username                                   | `""`                                                |
| `imageCredentials.password`                     | Private registry password                                   | `""`                                                |
| `imageCredentials.email`                        | Private registry email                                      | `""`                                                |
| `strategy.type`                                 | Deployment update strategy (`RollingUpdate` or `Recreate`) — use `Recreate` with ReadWriteOnce PVCs | `RollingUpdate`             |
| `strategy.rollingUpdate.maxSurge`               | Max surge (only rendered for `RollingUpdate`)               | `1`                                                 |
| `strategy.rollingUpdate.maxUnavailable`         | Max unavailable (only rendered for `RollingUpdate`)         | `0`                                                 |
| `env.normal`                                    | Map of plain environment variables (rendered into a ConfigMap) | `{}`                                             |
| `env.secret`                                    | Map of secret environment variables (rendered into a Secret) | `{}`                                               |
| `env.existingSecret`                            | Name of a pre-existing Secret to load env vars from via `envFrom.secretRef`. When set, the chart renders no env Secret | `""`      |
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
| `redis.strategy.type`                           | Redis update strategy (`RollingUpdate` or `Recreate`)       | `RollingUpdate`                                     |
| `redis.env.normal`                              | Redis plain environment variables                           | `{}`                                                |
| `redis.env.secret`                              | Redis secret environment variables                          | `{}`                                                |
| `redis.env.existingSecret`                      | Pre-existing Secret for Redis env vars (see `env.existingSecret`) | `""`                                          |
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

Environment variables are declared as plain key/value maps. `env.normal` entries
are rendered into a ConfigMap, `env.secret` entries into a Secret, and both are
wired into the container via `configMapKeyRef` / `secretKeyRef`:

```yaml
env:
  normal:
    NODE_ENV: "production"
    url: "https://blog.example.com"
  secret:
    database__connection__password: "s3cr3t"
```

#### Using an existing Secret (GitOps / External Secrets)

Set `env.existingSecret` to the name of a Secret that already exists in the
namespace — typically one produced by the External Secrets Operator or Vault, so
no secret material ever lands in Git. The chart then renders **no** env Secret of
its own and instead loads every key of that Secret via `envFrom.secretRef`:

```yaml
env:
  normal:
    NODE_ENV: "production"
  existingSecret: reddevs-blog-ghost
```

`env.secret` is ignored while `existingSecret` is set. The same switch exists for
the Redis component as `redis.env.existingSecret`.

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

The generated PVC carries `helm.sh/resource-policy: keep`, so neither a `helm uninstall` nor an ArgoCD prune deletes the data volume — detach it explicitly if you really intend to reclaim the storage. Because the default access mode is `ReadWriteOnce`, set `strategy.type: Recreate` as well: a `RollingUpdate` surge pod deadlocks trying to attach a volume the old pod still holds.

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
* Update strategy is configurable via `strategy`; it defaults to `RollingUpdate` with `maxSurge=1`, `maxUnavailable=0`. The `rollingUpdate` block is only emitted for the `RollingUpdate` type — `strategy.type: Recreate` renders `strategy: {type: Recreate}` alone.
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
      REDIS_MAXMEMORY: "256mb"
      REDIS_MAXMEMORY_POLICY: "allkeys-lru"
```

To connect Ghost to Redis, configure Ghost's environment variables:

```yaml
env:
  normal:
    adapters__cache__Redis: "true"
    adapters__cache__Redis__host: "my-ghost-redis"
    adapters__cache__Redis__port: "6379"
```

### Container Registry Credentials

The chart renders a `dockerconfigjson` Secret named `container-registry-cred` for pulling private images. It is only emitted when **both** `imageCredentials.create` is `true` (the default) and `imageCredentials.registry` is non-empty — so a chart install with no registry configured never creates an empty-credential Secret that would collide with a real one in the namespace.

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

Set `imageCredentials.create: false` when the Secret is owned by something else (External Secrets Operator, a sealed secret, or a manually-created one). The chart then renders no credentials at all and simply references the Secret through `imagePullSecrets`:

```yaml
imageCredentials:
  create: false

imagePullSecrets:
  - name: container-registry-cred
```

## Customizing the Chart

You can override any parameter in the `values.yaml` or by using `--set`. For advanced customization, modify the templates directly or contribute to the chart on GitHub.

## Contributing

Contributions are welcome! Please open issues or pull requests against this repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
