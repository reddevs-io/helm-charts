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

| Name                | Description                                          | Value                                        |
| ------------------- | ---------------------------------------------------- | -------------------------------------------- |
| `image.repository`  | Outline image repository                             | `docker.getoutline.com/outlinewiki/outline` |
| `image.tag`         | Outline image tag (immutable tags are recommended)  | `latest`                                     |
| `image.pullPolicy`  | Outline image pull policy                            | `IfNotPresent`                               |
| `imagePullSecrets`  | Outline image pull secrets                           | `[]`                                         |

### Outline Configuration parameters

| Name                    | Description                                    | Value             |
| ----------------------- | ---------------------------------------------- | ----------------- |
| `component`             | Outline component label                        | `outline`         |
| `tier`                  | Outline tier label                             | `documentation`   |
| `replicaCount`          | Number of Outline replicas to deploy          | `1`               |
| `env.normal`            | Normal environment variables                   | `{}`              |
| `env.secret`            | Secret environment variables                   | `{}`              |

### Outline Service parameters

| Name                  | Description                                          | Value       |
| --------------------- | ---------------------------------------------------- | ----------- |
| `service.type`        | Outline service type                                 | `ClusterIP` |
| `service.port`        | Outline service HTTP port                            | `3000`      |

### Outline Ingress parameters

| Name                       | Description                                              | Value                    |
| -------------------------- | -------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress record generation for Outline            | `false`                  |
| `ingress.className`        | IngressClass that will be used to implement the Ingress | `""`                     |
| `ingress.annotations`      | Additional annotations for the Ingress resource         | `{}`                     |
| `ingress.hosts`            | An array with hosts and paths                            | `[{"host": "chart-example.local", "paths": [{"path": "/", "pathType": "ImplementationSpecific"}]}]` |
| `ingress.tls`              | TLS configuration for additional hostnames              | `[]`                     |

### Outline Persistence parameters

| Name                        | Description                                      | Value               |
| --------------------------- | ------------------------------------------------ | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims | `false`           |
| `persistence.accessMode`    | Persistent Volume access mode                    | `ReadWriteOnce`     |
| `persistence.size`          | Persistent Volume size                           | `5Gi`               |
| `persistence.storageClass`  | Persistent Volume storage class                  | `""`                |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence | `""`             |

### Outline Autoscaling parameters

| Name                                            | Description                                                                                                          | Value   |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled`                           | Enable Horizontal POD autoscaling for Outline                                                                       | `false` |
| `autoscaling.minReplicas`                       | Minimum number of Outline replicas                                                                                  | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of Outline replicas                                                                                  | `100`   |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                | `80`    |

### Redis parameters

| Name                    | Description                                    | Value       |
| ----------------------- | ---------------------------------------------- | ----------- |
| `redis.enable`          | Deploy Redis as part of the release           | `false`     |
| `redis.image.repository`| Redis image repository                         | `redis`     |
| `redis.image.tag`       | Redis image tag                                | `8-alpine`  |
| `redis.service.port`    | Redis service port                             | `6379`      |

### PostgreSQL parameters

| Name                        | Description                                    | Value           |
| --------------------------- | ---------------------------------------------- | --------------- |
| `postgres.enable`           | Deploy PostgreSQL as part of the release      | `false`         |
| `postgres.image.repository` | PostgreSQL image repository                    | `postgres`      |
| `postgres.image.tag`        | PostgreSQL image tag                           | `18-alpine`     |
| `postgres.service.port`     | PostgreSQL service port                        | `5432`          |
| `postgres.persistence.size` | PostgreSQL persistent volume size              | `8Gi`           |

### External Secrets parameters

| Name                                    | Description                                    | Value       |
| --------------------------------------- | ---------------------------------------------- | ----------- |
| `externalSecrets.enabled`               | Enable External Secrets integration           | `false`     |
| `externalSecrets.awsProvider.enabled`   | Enable AWS Secrets Manager provider           | `false`     |
| `externalSecrets.awsProvider.region`    | AWS region                                     | `eu-central-1` |

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
- NetworkPolicy for pod-to-pod communication control
- SecurityContext with non-root user
- ReadOnlyRootFilesystem where possible
- Resource limits and requests

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

## Troubleshooting

### Common Issues

1. **Outline fails to start**: Check that all required environment variables are set, especially authentication provider credentials.

2. **Database connection issues**: Verify that PostgreSQL is running and accessible, and that the DATABASE_URL is correct.

3. **Authentication not working**: Ensure that your authentication provider (Google, Azure, etc.) is properly configured with the correct redirect URLs.

### Useful Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=outline

# View logs
kubectl logs -l app.kubernetes.io/name=outline

# Check configuration
kubectl describe configmap <release-name>-outline
```

## Contributing

Please read the contribution guidelines before submitting pull requests.

## License

This Helm chart is licensed under the MIT License.
