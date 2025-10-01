# Symfony Helm Chart

A Helm chart for deploying a Symfony application on Kubernetes with secure defaults, optional External Secrets support, and ingress configuration.

## Prerequisites

* Kubernetes 1.16+ cluster  
* Helm 3.x  
* External Secrets Operator (for `.Values.externalSecrets`)  
* Cert-Manager (for TLS via Ingress)

## Installing the Chart

Add the RedDevs Helm repository and install the chart:

```bash
helm repo add reddevs https://charts.reddevs.io
helm repo update
helm install my-symfony reddevs/symfony
```

To override default values, use `--set` flags or provide a custom `values.yaml`:

```bash
helm install my-symfony reddevs/symfony \
  --set replicaCount=2,ingress.enabled=true,ingress.hosts[0].host=example.com
# or
helm install my-symfony reddevs/symfony -f custom-values.yaml
```

## Upgrading the Chart

```bash
helm upgrade my-symfony reddevs/symfony
```

## Uninstalling the Chart

```bash
helm uninstall my-symfony
```

## Configuration (High-Level Summary)

The following categories of parameters are available. See `values.yaml` for complete details and defaults:

* **Name overrides**: `nameOverride`, `fullnameOverride`  
* **Labels**: `component`, `tier`  
* **Replica settings**: `replicaCount`  
* **Container image**: `image.repository`, `image.tag`, `image.pullPolicy`  
* **Credentials & pull secrets**: `imageCredentials`, `imagePullSecrets`  
* **Environment variables**: `env.normal`, `env.secret`  
* **External Secrets**: `externalSecrets.enabled`, `externalSecrets.refreshInterval`, provider and data mappings  
* **External Secrets Database URL**: `externalSecretsDbUrl.enabled`, `externalSecretsDbUrl.rdsSecretKey`, database connection parameters  
* **Ingress**: `ingress.enabled`, `ingress.className`, `ingress.annotations`, `ingress.hosts`, `ingress.tls`  
* **Autoscaling**: `autoscaling.enabled`, `minReplicas`, `maxReplicas`, `targetCPUUtilizationPercentage`, `targetMemoryUtilizationPercentage`  
* **Service account**: `serviceAccount.create`, `serviceAccount.name`, `serviceAccount.automount`  
* **Pod metadata & security**: `podAnnotations`, `podLabels`, `podSecurityContext`, `securityContext`  
* **Resources**: `resources.limits`, `resources.requests`  
* **Service & networking**: `service.type`, `service.port`, `networkPolicy.enabled`, `networkPolicy.ingress`  
* **Init job**: `initJob.enabled`, `initJob.command`  
* **Volumes & mounts**: `volumes`, `volumeMounts`  
* **Node scheduling**: `nodeSelector`, `tolerations`, `affinity`  
* **Probes**: `livenessProbe`, `readinessProbe`  
* **PHP & Nginx Unit**: `phpIni.memory_limit`, `nginxUnit.enable`, `nginxUnit.content`

## External Secrets Database URL

This chart provides a specialized feature for automatically constructing Symfony's `DATABASE_URL` environment variable from AWS RDS secrets stored in AWS Secrets Manager. This is particularly useful when using AWS RDS databases where credentials are managed by AWS.

### How It Works

When enabled, the chart:
1. Fetches the database username and password from AWS Secrets Manager using the specified RDS secret key
2. Automatically constructs a properly formatted `DATABASE_URL` with URL-encoded credentials
3. Combines the fetched credentials with your configured database connection parameters (engine, host, port, database name)
4. Creates a Kubernetes secret containing the complete `DATABASE_URL`

### Configuration

Enable and configure the feature in your `values.yaml`:

```yaml
externalSecretsDbUrl:
  enabled: true
  refreshInterval: "1h"
  rdsSecretKey: "my-rds-secret-name"  # The AWS Secrets Manager secret name
  awsProvider:
    enabled: true
    region: eu-central-1
    iam:
      accessKey: "AKIA..."
      secretAccessKey: "secret..."
  data:
    engine: "mysql"           # Database engine (mysql, postgresql, etc.)
    host: "mydb.abc123.eu-central-1.rds.amazonaws.com"
    port: "3306"
    dbName: "symfony_db"
```

### Result

The chart will automatically create a `DATABASE_URL` in the format:
```
mysql://username:password@mydb.abc123.eu-central-1.rds.amazonaws.com:3306/symfony_db
```

Where `username` and `password` are fetched from the AWS secret and properly URL-encoded.

### Notes

- The AWS Secrets Manager secret must contain `username` and `password` properties
- This feature requires the External Secrets Operator to be installed in your cluster
- The IAM credentials must have permissions to read from AWS Secrets Manager
- Credentials in the URL are automatically URL-encoded to handle special characters

## Resource Details

| Kind           | Purpose                             | Template Path                           |
| -------------- | ----------------------------------- | --------------------------------------- |
| ConfigMap      | Non-sensitive environment variables | `templates/symfony/configmap.yaml`      |
| Secret         | Sensitive vars & External Secrets   | `templates/symfony/secret/*.yaml`       |
| Deployment     | Symfony application pods            | `templates/symfony/deployment.yaml`     |
| Service        | Expose pods internally              | `templates/symfony/service.yaml`        |
| Ingress        | HTTP/S routing                      | `templates/symfony/ingress.yaml`        |
| HPA            | Horizontal Pod Autoscaler           | `templates/symfony/hpa.yaml`            |
| Init Job       | Pre-deploy initialization            | `templates/symfony/job-init.yaml`       |
| NetworkPolicy  | Pod ingress controls                | `templates/symfony/networkpolicy.yaml`  |
| ServiceAccount | Pod identity                        | `templates/symfony/serviceaccount.yaml` |

## Getting the Application URL

View access instructions after installation:

```bash
helm get notes my-symfony
```

This will display the URL or port-forward command based on your service or ingress configuration.

## Contributing

Contributions are welcome! Please open issues or pull requests against the [reddevs-io/helm-charts](https://github.com/reddevs-io/helm-charts) repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
