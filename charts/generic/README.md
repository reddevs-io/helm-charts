# Generic Helm Chart

A Helm chart for deploying a generic application on Kubernetes with secure defaults, optional External Secrets support, persistent volumes, and ingress configuration.

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
helm install my-app reddevs/generic
```

To override default values, use `--set` flags or provide a custom `values.yaml`:

```bash
helm install my-app reddevs/generic \
  --set replicaCount=2,ingress.enabled=true,ingress.hosts[0].host=example.com
# or
helm install my-app reddevs/generic -f custom-values.yaml
```

## Upgrading the Chart

```bash
helm upgrade my-app reddevs/generic
```

## Uninstalling the Chart

```bash
helm uninstall my-app
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
* **Ingress**: `ingress.enabled`, `ingress.className`, `ingress.annotations`, `ingress.hosts`, `ingress.tls`
* **HTTPRoute (Gateway API)**: `httpRoute.enabled`, `httpRoute.parentRefs`, `httpRoute.hostnames`, `httpRoute.rules`
* **Autoscaling**: `autoscaling.enabled`, `minReplicas`, `maxReplicas`, `targetCPUUtilizationPercentage`, `targetMemoryUtilizationPercentage`
* **Service account**: `serviceAccount.create`, `serviceAccount.name`, `serviceAccount.automount`
* **Pod metadata & security**: `podAnnotations`, `podLabels`, `podSecurityContext`, `securityContext`
* **Resources**: `resources.limits`, `resources.requests`
* **Service & networking**: `service.type`, `service.port`, `networkPolicy.enabled`, `networkPolicy.ingress`, `networkPolicy.egress`
* **Persistence**: `persistence.enabled`, `persistence.volumes` (named PVCs with accessMode, size, storageClass, mountPath)
* **Volumes & mounts**: `volumes`, `volumeMounts`
* **Node scheduling**: `nodeSelector`, `tolerations`, `affinity`
* **Probes**: `livenessProbe`, `readinessProbe`

## Persistence

The chart supports multiple named persistent volumes. Each volume creates a PVC and is automatically mounted in the deployment:

```yaml
persistence:
  enabled: true
  volumes:
    - name: data
      accessMode: ReadWriteOnce
      size: 5Gi
      storageClass: ""
      mountPath: /data
    - name: logs
      accessMode: ReadWriteOnce
      size: 1Gi
      storageClass: ""
      mountPath: /var/log/app
```

To use an existing claim, set `existingClaim`:

```yaml
persistence:
  enabled: true
  volumes:
    - name: data
      existingClaim: my-preexisting-pvc
      mountPath: /data
```

## External Secrets

When using the External Secrets Operator with AWS Secrets Manager:

```yaml
externalSecrets:
  enabled: true
  refreshInterval: "1h"
  awsProvider:
    enabled: true
    region: eu-central-1
    iam:
      accessKey: "AKIA..."
      secretAccessKey: "secret..."
  data:
    - secretKey: DATABASE_PASSWORD
      envName: DATABASE_PASSWORD
      remoteRef:
        key: my-aws-secret-name
        property: password
```

### Notes

- This feature requires the External Secrets Operator to be installed in your cluster
- The IAM credentials must have permissions to read from AWS Secrets Manager

## Resource Details

| Kind           | Purpose                             | Template Path                      |
| -------------- | ----------------------------------- | ---------------------------------- |
| ConfigMap      | Non-sensitive environment variables | `templates/configmap.yaml`         |
| Secret         | Sensitive vars & External Secrets   | `templates/secret/*.yaml`          |
| Deployment     | Application pods                    | `templates/deployment.yaml`        |
| Service        | Expose pods internally              | `templates/service.yaml`           |
| Ingress        | HTTP/S routing                      | `templates/ingress.yaml`           |
| HTTPRoute      | Gateway API routing                 | `templates/httproute.yaml`         |
| HPA            | Horizontal Pod Autoscaler           | `templates/hpa.yaml`               |
| PVC            | Persistent volume claims            | `templates/pvc.yaml`               |
| NetworkPolicy  | Pod ingress/egress controls         | `templates/networkpolicy.yaml`     |
| ServiceAccount | Pod identity                        | `templates/serviceaccount.yaml`    |

## Getting the Application URL

View access instructions after installation:

```bash
helm get notes my-app
```

This will display the URL or port-forward command based on your service or ingress configuration.

## Contributing

Contributions are welcome! Please open issues or pull requests against the [reddevs-io/helm-charts](https://github.com/reddevs-io/helm-charts) repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
