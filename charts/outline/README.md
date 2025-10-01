# Outline Helm Chart

A Helm chart for deploying [Outline](https://www.getoutline.com/) - a modern team knowledge base and wiki.

## Description

This chart deploys Outline on a Kubernetes cluster using the Helm package manager. Outline is a fast, collaborative, knowledge base for your team built using React and Node.js.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-outline`:

```bash
helm install my-outline ./outline
```

The command deploys Outline on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-outline` deployment:

```bash
helm delete my-outline
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `nameOverride`            | String to partially override outline.fullname  | `""`  |
| `fullnameOverride`        | String to fully override outline.fullname      | `""`  |

### Outline Image parameters

| Name                       | Description                                          | Value                    |
| -------------------------- | ---------------------------------------------------- | ------------------------ |
| `image.repository`         | Outline image repository                             | `outlinewiki/outline`    |
| `image.tag`                | Outline image tag (immutable tags are recommended)  | `0.87.4`                 |
| `image.pullPolicy`         | Outline image pull policy                            | `IfNotPresent`           |
| `imagePullSecrets`         | Outline image pull secrets                           | `[]`                     |
| `imageCredentials.registry`| Docker registry for private images                   | `""`                     |
| `imageCredentials.username`| Username for private registry                        | `""`                     |
| `imageCredentials.password`| Password for private registry                        | `""`                     |
| `imageCredentials.email`   | Email for private registry                           | `""`                     |

### Outline Configuration parameters

| Name                    | Description                                    | Value             |
| ----------------------- | ---------------------------------------------- | ----------------- |
| `component`             | Outline component label                        | `outline`         |
| `tier`                  | Outline tier label                             | `documentation`   |
| `replicaCount`          | Number of Outline replicas to deploy          | `1`               |
| `env.normal`            | Normal environment variables                   | `[]`              |
| `env.secret`            | Secret environment variables                   | `[]`              |

### Service Account parameters

| Name                          | Description                                              | Value   |
| ----------------------------- | -------------------------------------------------------- | ------- |
| `serviceAccount.create`       | Specifies whether a service account should be created   | `true`  |
| `serviceAccount.automount`    | Automatically mount ServiceAccount API credentials      | `false` |
| `serviceAccount.annotations`  | Annotations to add to the service account               | `{}`    |
| `serviceAccount.name`         | The name of the service account to use                  | `""`    |

### Pod Configuration parameters

| Name                    | Description                                    | Value   |
| ----------------------- | ---------------------------------------------- | ------- |
| `podAnnotations`        | Annotations to add to the pod                 | `{}`    |
| `podLabels`             | Labels to add to the pod                      | `{}`    |
| `podSecurityContext`    | Pod security context                          | `{}`    |

### Security Context parameters

| Name                                      | Description                                    | Value    |
| ----------------------------------------- | ---------------------------------------------- | -------- |
| `securityContext.capabilities.drop`       | Linux capabilities to drop                     | `["ALL"]`|
| `securityContext.readOnlyRootFilesystem`  | Mount root filesystem as read-only            | `false`  |
| `securityContext.runAsNonRoot`            | Run container as non-root user                | `true`   |
| `securityContext.runAsUser`               | User ID to run the container                  | `1001`   |

### Outline Service parameters

| Name                  | Description                                          | Value       |
| --------------------- | ---------------------------------------------------- | ----------- |
| `service.type`        | Outline service type                                 | `ClusterIP` |
| `service.port`        | Outline service HTTP port                            | `3000`      |

### Network Policy parameters

| Name                       | Description                                    | Value                           |
| -------------------------- | ---------------------------------------------- | ------------------------------- |
| `networkPolicy.enabled`    | Enable NetworkPolicy                          | `true`                          |
| `networkPolicy.ingress`    | Ingress rules for NetworkPolicy               | `[{"from": [{"podSelector": {}}]}]` |
| `networkPolicy.policyTypes`| Policy types for NetworkPolicy                | `["Ingress"]`                   |

### Outline Ingress parameters

| Name                       | Description                                              | Value                    |
| -------------------------- | -------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress record generation for Outline            | `false`                  |
| `ingress.className`        | IngressClass that will be used to implement the Ingress | `""`                     |
| `ingress.annotations`      | Additional annotations for the Ingress resource         | `{}`                     |
| `ingress.hosts`            | An array with hosts and paths                            | `[{"host": "chart-example.local", "paths": [{"path": "/", "pathType": "ImplementationSpecific"}]}]` |
| `ingress.tls`              | TLS configuration for additional hostnames              | `[]`                     |

### Resource Limits parameters

| Name                  | Description                                    | Value      |
| --------------------- | ---------------------------------------------- | ---------- |
| `resources.limits`    | Resource limits for the Outline container     | `{"memory": "512Mi"}` |
| `resources.requests`  | Resource requests for the Outline container   | `{}`       |

### Health Probes parameters

| Name                                    | Description                                    | Value   |
| --------------------------------------- | ---------------------------------------------- | ------- |
| `livenessProbe.httpGet.path`            | Path for liveness probe                       | `/`     |
| `livenessProbe.httpGet.port`            | Port for liveness probe                       | `http`  |
| `livenessProbe.initialDelaySeconds`     | Initial delay for liveness probe              | `60`    |
| `livenessProbe.timeoutSeconds`          | Timeout for liveness probe                    | `5`     |
| `livenessProbe.periodSeconds`           | Period for liveness probe                     | `30`    |
| `livenessProbe.failureThreshold`        | Failure threshold for liveness probe          | `3`     |
| `readinessProbe.httpGet.path`           | Path for readiness probe                      | `/`     |
| `readinessProbe.httpGet.port`           | Port for readiness probe                      | `http`  |
| `readinessProbe.initialDelaySeconds`    | Initial delay for readiness probe             | `30`    |
| `readinessProbe.timeoutSeconds`         | Timeout for readiness probe                   | `5`     |
| `readinessProbe.periodSeconds`          | Period for readiness probe                    | `10`    |
| `readinessProbe.failureThreshold`       | Failure threshold for readiness probe         | `3`     |

### Outline Persistence parameters

| Name                        | Description                                      | Value               |
| --------------------------- | ------------------------------------------------ | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims | `false`           |
| `persistence.accessMode`    | Persistent Volume access mode                    | `ReadWriteOnce`     |
| `persistence.size`          | Persistent Volume size                           | `5Gi`               |
| `persistence.storageClass`  | Persistent Volume storage class                  | `""`                |
| `persistence.mountPath`     | Mount path for persistent volume                 | `/var/lib/outline/data` |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence | `""`             |

### Volume Configuration parameters

| Name                  | Description                                    | Value                                      |
| --------------------- | ---------------------------------------------- | ------------------------------------------ |
| `volumes`             | Additional volumes for the pod                | `[{"name": "outline-data", "emptyDir": {}}]` |
| `volumeMounts`        | Additional volume mounts for the container    | `[{"name": "outline-data", "mountPath": "/var/lib/outline/data"}]` |

### Outline Autoscaling parameters

| Name                                            | Description                                                                                                          | Value   |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled`                           | Enable Horizontal POD autoscaling for Outline                                                                       | `false` |
| `autoscaling.minReplicas`                       | Minimum number of Outline replicas                                                                                  | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of Outline replicas                                                                                  | `100`   |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                | `80`    |

### Pod Scheduling parameters

| Name                  | Description                                    | Value   |
| --------------------- | ---------------------------------------------- | ------- |
| `nodeSelector`        | Node labels for pod assignment                | `{}`    |
| `tolerations`         | Tolerations for pod assignment                | `[]`    |
| `affinity`            | Affinity rules for pod assignment             | See values.yaml for default anti-affinity rules |

### CronJob parameters

| Name                                      | Description                                    | Value                |
| ----------------------------------------- | ---------------------------------------------- | -------------------- |
| `cronJob.enabled`                         | Enable scheduled maintenance CronJob          | `true`               |
| `cronJob.schedule`                        | Cron schedule for maintenance tasks           | `0 2 * * *`          |
| `cronJob.image.repository`                | Image repository for CronJob                  | `curlimages/curl`    |
| `cronJob.image.tag`                       | Image tag for CronJob                         | `8.16.0`             |
| `cronJob.image.pullPolicy`                | Image pull policy for CronJob                 | `IfNotPresent`       |
| `cronJob.successfulJobsHistoryLimit`      | Number of successful jobs to keep             | `3`                  |
| `cronJob.failedJobsHistoryLimit`          | Number of failed jobs to keep                 | `1`                  |
| `cronJob.resources.limits`                | Resource limits for CronJob                   | `{"memory": "64Mi"}` |
| `cronJob.resources.requests`              | Resource requests for CronJob                 | `{"memory": "64Mi"}` |

### Redis parameters

| Name                    | Description                                    | Value       |
| ----------------------- | ---------------------------------------------- | ----------- |
| `redis.enable`          | Deploy Redis as part of the release           | `false`     |
| `redis.image.repository`| Redis image repository                         | `redis`     |
| `redis.image.tag`       | Redis image tag                                | `8.2-alpine`|
| `redis.service.port`    | Redis service port                             | `6379`      |
| `redis.resources.limits`| Redis resource limits                          | `{"memory": "300Mi"}` |

### PostgreSQL parameters

| Name                        | Description                                    | Value           |
| --------------------------- | ---------------------------------------------- | --------------- |
| `postgres.enable`           | Deploy PostgreSQL as part of the release      | `false`         |
| `postgres.image.repository` | PostgreSQL image repository                    | `postgres`      |
| `postgres.image.tag`        | PostgreSQL image tag                           | `18-alpine`     |
| `postgres.service.port`     | PostgreSQL service port                        | `5432`          |
| `postgres.persistence.enabled` | Enable PostgreSQL persistence               | `true`          |
| `postgres.persistence.size` | PostgreSQL persistent volume size              | `8Gi`           |
| `postgres.resources.limits` | PostgreSQL resource limits                     | `{"memory": "512Mi"}` |

### External Secrets parameters

| Name                                    | Description                                    | Value       |
| --------------------------------------- | ---------------------------------------------- | ----------- |
| `externalSecrets.enabled`               | Enable External Secrets integration           | `false`     |
| `externalSecrets.refreshInterval`       | Refresh interval for secrets                  | `1h`        |
| `externalSecrets.awsProvider.enabled`   | Enable AWS Secrets Manager provider           | `false`     |
| `externalSecrets.awsProvider.region`    | AWS region                                     | `eu-central-1` |
| `externalSecrets.awsProvider.iam.accessKey` | AWS IAM access key                        | `""`        |
| `externalSecrets.awsProvider.iam.secretAccessKey` | AWS IAM secret access key            | `""`        |
| `externalSecrets.data`                  | Array of secret mappings                      | `[]`        |

## Configuration and Installation Details

### Environment Variables

Outline requires several environment variables to be configured. The most important ones are:

- `SECRET_KEY`: A 32-byte random key for encryption
- `UTILS_SECRET`: Another random key for utilities
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string (optional)

Authentication providers (at least one required):
- `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`
- `AZURE_CLIENT_ID` and `AZURE_CLIENT_SECRET`
- `DISCORD_CLIENT_ID` and `DISCORD_CLIENT_SECRET`

### CronJob Maintenance

By default, the chart deploys a CronJob that runs daily at 2 AM to perform maintenance tasks. This job calls the `/api/cron.daily` endpoint to:
- Clean up expired data
- Perform database maintenance
- Update search indexes

To disable the CronJob:

```yaml
cronJob:
  enabled: false
```

To customize the schedule:

```yaml
cronJob:
  schedule: "0 3 * * *"  # Run at 3 AM instead
```

### Using with External Database

To use an external PostgreSQL database, set `postgres.enable=false` and configure the `DATABASE_URL` in the secret environment variables:

```yaml
postgres:
  enable: false

env:
  secret:
    DATABASE_URL: "postgres://user:password@external-db:5432/outline"
```

### Using with External Redis

To use an external Redis instance, set `redis.enable=false` and configure the `REDIS_URL`:

```yaml
redis:
  enable: false

env:
  secret:
    REDIS_URL: "redis://external-redis:6379"
```

### Using Private Container Registry

To pull images from a private registry, configure the imageCredentials:

```yaml
imageCredentials:
  registry: "my-registry.example.com"
  username: "myuser"
  password: "mypassword"
  email: "user@example.com"
```

### Persistence

By default, Outline uses an emptyDir volume for data storage. For production use, enable persistence:

```yaml
persistence:
  enabled: true
  size: 10Gi
  storageClass: "fast-ssd"
```

### Security

The chart includes several security features:
- NetworkPolicy for pod-to-pod communication control (enabled by default)
- SecurityContext with non-root user (UID 1001)
- Capability dropping (ALL capabilities dropped)
- Resource limits to prevent resource exhaustion
- Pod anti-affinity rules for high availability

### Pod Scheduling

The chart includes default affinity rules to:
- Ensure pods run on Linux nodes
- Prefer spreading pods across different nodes (pod anti-affinity)

You can customize these with `nodeSelector`, `tolerations`, and `affinity` parameters.

## Examples

### Basic Installation

```bash
helm install outline ./outline \
  --set env.secret.SECRET_KEY="your-32-byte-secret-key" \
  --set env.secret.UTILS_SECRET="your-32-byte-utils-secret" \
  --set env.secret.GOOGLE_CLIENT_ID="your-google-client-id" \
  --set env.secret.GOOGLE_CLIENT_SECRET="your-google-client-secret"
```

### Installation with PostgreSQL and Redis

```bash
helm install outline ./outline \
  --set postgres.enable=true \
  --set redis.enable=true \
  --set persistence.enabled=true \
  --set env.secret.SECRET_KEY="your-32-byte-secret-key" \
  --set env.secret.UTILS_SECRET="your-32-byte-utils-secret" \
  --set env.secret.GOOGLE_CLIENT_ID="your-google-client-id" \
  --set env.secret.GOOGLE_CLIENT_SECRET="your-google-client-secret"
```

### Installation with Ingress

```bash
helm install outline ./outline \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host="outline.example.com" \
  --set ingress.hosts[0].paths[0].path="/" \
  --set ingress.hosts[0].paths[0].pathType="ImplementationSpecific"
```

### Installation with External Secrets

```bash
helm install outline ./outline \
  --set externalSecrets.enabled=true \
  --set externalSecrets.awsProvider.enabled=true \
  --set externalSecrets.awsProvider.region="us-east-1" \
  --set externalSecrets.awsProvider.iam.accessKey="your-access-key" \
  --set externalSecrets.awsProvider.iam.secretAccessKey="your-secret-key"
```

### Production Installation with All Features

```bash
helm install outline ./outline \
  --set replicaCount=3 \
  --set postgres.enable=true \
  --set postgres.persistence.enabled=true \
  --set postgres.persistence.size=20Gi \
  --set redis.enable=true \
  --set persistence.enabled=true \
  --set persistence.size=10Gi \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=3 \
  --set autoscaling.maxReplicas=10 \
  --set ingress.enabled=true \
  --set ingress.className="nginx" \
  --set ingress.hosts[0].host="outline.example.com" \
  --set resources.requests.cpu="500m" \
  --set resources.requests.memory="512Mi" \
  --set resources.limits.cpu="1000m" \
  --set resources.limits.memory="1Gi"
```

## Troubleshooting

### Common Issues

1. **Outline fails to start**: Check that all required environment variables are set, especially authentication provider credentials.

2. **Database connection issues**: Verify that PostgreSQL is running and accessible, and that the DATABASE_URL is correct.

3. **Authentication not working**: Ensure that your authentication provider (Google, Azure, etc.) is properly configured with the correct redirect URLs.

4. **CronJob failures**: Check the CronJob logs to see if the maintenance endpoint is accessible. The job needs to reach the Outline service at `http://<service-name>:3000/api/cron.daily`.

5. **Persistence issues**: If using persistence, ensure your StorageClass supports the requested access mode (ReadWriteOnce).

### Useful Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=outline

# View Outline logs
kubectl logs -l app.kubernetes.io/name=outline

# View CronJob logs
kubectl logs -l app.kubernetes.io/name=outline,component=cronjob

# Check configuration
kubectl describe configmap <release-name>-outline

# Check secrets
kubectl get secrets -l app.kubernetes.io/name=outline

# View CronJob status
kubectl get cronjobs -l app.kubernetes.io/name=outline

# Manually trigger CronJob
kubectl create job --from=cronjob/<release-name>-outline-cronjob manual-run-1
```

### Debug Mode

To enable debug logging, add the following environment variable:

```yaml
env:
  normal:
    DEBUG: "http,cache,emails"
    LOG_LEVEL: "debug"
```

## Contributing

Please read the contribution guidelines before submitting pull requests.

## License

This Helm chart is licensed under the MIT License.
