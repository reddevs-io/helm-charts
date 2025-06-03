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
* **Replica settings**: `replicaCount`  
* **Container image**: `image.repository`, `image.tag`, `image.pullPolicy`  
* **Credentials & pull secrets**: `imageCredentials`, `imagePullSecrets`  
* **Environment variables**: `env.normal`, `env.secret`  
* **External Secrets**: `externalSecrets.enabled`, `externalSecrets.refreshInterval`, provider and data mappings  
* **Ingress**: `ingress.enabled`, `ingress.className`, `ingress.annotations`, `ingress.hosts`, `ingress.tls`  
* **Autoscaling**: `autoscaling.enabled`, `minReplicas`, `maxReplicas`, `targetCPUUtilizationPercentage`, `targetMemoryUtilizationPercentage`  
* **Service account**: `serviceAccount.create`, `serviceAccount.name`, `serviceAccount.automount`  
* **Pod metadata & security**: `podAnnotations`, `podLabels`, `podSecurityContext`, `securityContext`  
* **Service & networking**: `service.type`, `service.port`, `networkPolicy.enabled`, `networkPolicy.ingress`  
* **Init job**: `initJob.enabled`, `initJob.command`  
* **Volumes & mounts**: `volumes`, `volumeMounts`  
* **Node scheduling**: `nodeSelector`, `tolerations`, `affinity`  
* **Probes**: `livenessProbe`, `readinessProbe`  
* **PHP & Nginx Unit**: `phpIni.memory_limit`, `nginxUnit.enable`, `nginxUnit.content`

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
