# Next.js Helm Chart

This Helm chart deploys a Next.js application alongside an optional Redis cache in a Kubernetes cluster. It includes Kubernetes resources for:

* **Next.js frontend** (Deployment, Service, Ingress, NetworkPolicy, ServiceAccount, PVC, HPA, ConfigMap, Secret, Init Job)
* **Redis cache** (Deployment, Service, NetworkPolicy, ServiceAccount, ConfigMap, Secret)
* **Container registry credentials** (pre-install hook)

## Prerequisites

* Kubernetes 1.16+ cluster with the following APIs enabled:

    * `apps/v1`
    * `networking.k8s.io/v1`
    * `batch/v1`
    * `autoscaling/v2`
* Helm 3.x
* (Optional) cert-manager for TLS certificate provisioning


## Installing the Chart

```bash
helm repo add reddevs https://charts.reddevs.io
helm repo update

# Install the chart with release name "my-nextjs"
helm install my-nextjs reddevs/nextjs
```

To override default values, provide a custom `values.yaml` or `--set` flags:

```bash
helm install my-nextjs reddevs/nextjs \
  --set image.repository=myregistry/my-nextjs,image.tag=v1.2.3 \
  --set redis.enable=true
```
### Upgrading the Chart

```bash
helm upgrade my-nextjs reddevs/nextjs
```

Review the [Helm upgrade guide](https://helm.sh/docs/helm/helm_upgrade/) for details on upgrading in-place.

## Uninstalling the Chart

```bash
helm uninstall my-nextjs
```

This will remove all Kubernetes resources created by this chart.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

### Global Settings

| Parameter          | Description                      | Default      |
| ------------------ | -------------------------------- | ------------ |
| `nameOverride`     | Override the chart name          | `""`         |
| `fullnameOverride` | Override the full resource names | `""`         |
| `component`        | Common label for component       | `"nextjs"`   |
| `tier`             | Common label for tier            | `"frontend"` |

### Next.js Application

| Parameter                                    | Description                                                                | Default                                                          |
| -------------------------------------------- | -------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| `replicaCount`                               | Number of Next.js replicas                                                 | `1`                                                              |
| `image.repository`                           | Next.js container image repository                                         | `""`                                                             |
| `image.tag`                                  | Next.js image tag (defaults to appVersion)                                 | `""`                                                             |
| `image.pullPolicy`                           | Kubernetes image pull policy                                               | `IfNotPresent`                                                   |
| `imageCredentials`                           | Private registry credentials (`registry`, `username`, `password`, `email`) | `{}`                                                             |
| `imagePullSecrets`                           | Image pull secret names                                                    | `[]`                                                             |
| `serviceAccount.create`                      | Create ServiceAccount                                                      | `true`                                                           |
| `serviceAccount.automount`                   | Automount API token                                                        | `false`                                                          |
| `podAnnotations`                             | Additional annotations for pods                                            | `{}`                                                             |
| `podLabels`                                  | Additional labels for pods                                                 | `{}`                                                             |
| `podSecurityContext`                         | Security context settings for pods                                         | `{}`                                                             |
| `securityContext`                            | Container-level security context                                           | `drop ALL, readOnlyRootFilesystem, runAsNonRoot, runAsUser:1000` |
| `service.type`                               | Next.js Service type (`ClusterIP`, `NodePort`, `LoadBalancer`)             | `ClusterIP`                                                      |
| `service.port`                               | Next.js Service port                                                       | `3000`                                                           |
| `networkPolicy.enabled`                      | Enable NetworkPolicy                                                       | `true`                                                           |
| `networkPolicy.ingress`                      | Ingress rules for NetworkPolicy                                            | `- from: podSelector: {}`                                        |
| `ingress.enabled`                            | Enable Ingress                                                             | `false`                                                          |
| `ingress.className`                          | IngressClass name                                                          | `""`                                                             |
| `ingress.annotations`                        | Annotations for Ingress                                                    | `{}`                                                             |
| `ingress.hosts`                              | List of host rules (host, paths)                                           | `chart-example.local`                                            |
| `ingress.tls`                                | TLS configuration for Ingress                                              | `[]`                                                             |
| `resources.limits.memory`                    | Pod memory limit                                                           | `300Mi`                                                          |
| `livenessProbe`                              | Liveness probe configuration                                               | HTTP GET `/`, port http                                          |
| `readinessProbe`                             | Readiness probe configuration                                              | HTTP GET `/`, port http                                          |
| `autoscaling.enabled`                        | Enable Horizontal Pod Autoscaler                                           | `false`                                                          |
| `autoscaling.minReplicas`                    | Minimum replicas for HPA                                                   | `1`                                                              |
| `autoscaling.maxReplicas`                    | Maximum replicas for HPA                                                   | `100`                                                            |
| `autoscaling.targetCPUUtilizationPercentage` | CPU utilization target                                                     | `80`                                                             |
| `volumes`                                    | Additional volumes                                                         | `- name: node-cache, emptyDir`                                   |
| `volumeMounts`                               | Additional volume mounts                                                   | `- node-cache @ /home/node/.cache`                               |
| `persistence.enabled`                        | Enable PersistentVolumeClaim for `/data`                                   | `false`                                                          |
| `persistence.accessMode`                     | PVC access mode                                                            | `ReadWriteOnce`                                                  |
| `persistence.size`                           | PVC size                                                                   | `1Gi`                                                            |
| `persistence.storageClass`                   | StorageClass for PVC                                                       | `""`                                                             |
| `persistence.mountPath`                      | Mount path for PVC                                                         | `/data`                                                          |
| `nodeSelector`, `tolerations`, `affinity`    | Node scheduling controls                                                   | `{}`                                                             |
| `initJob.enabled`                            | Enable init Job                                                            | `false`                                                          |
| `initJob.command`                            | Init Job command                                                           | `""`                                                             |

### Redis Cache (Optional)

| Parameter                                       | Description                      | Default          |
| ----------------------------------------------- | -------------------------------- | ---------------- |
| `redis.enable`                                  | Deploy Redis alongside Next.js   | `false`          |
| `redis.replicaCount`                            | Number of Redis replicas         | `1`              |
| `redis.image.repository`                        | Redis container image repository | `redis`          |
| `redis.image.tag`                               | Redis image tag                  | `8-alpine`       |
| `redis.image.pullPolicy`                        | Kubernetes image pull policy     | `IfNotPresent`   |
| `redis.imagePullSecrets`                        | Image pull secret names          | `[]`             |
| `redis.serviceAccount.create`                   | Create ServiceAccount for Redis  | `true`           |
| `redis.serviceAccount.automount`                | Automount API token              | `false`          |
| `redis.networkPolicy.enabled`                   | Enable NetworkPolicy for Redis   | `true`           |
| `redis.service.type`                            | Redis Service type               | `ClusterIP`      |
| `redis.service.port`                            | Redis Service port               | `6379`           |
| `redis.resources.limits.memory`                 | Pod memory limit                 | `300Mi`          |
| `redis.livenessProbe`                           | Liveness probe configuration     | `redis-cli ping` |
| `redis.readinessProbe`                          | Readiness probe configuration    | `redis-cli ping` |
| `redis.autoscaling.enabled`                     | Enable HPA for Redis             | `false`          |
| `redis.nodeSelector`, `tolerations`, `affinity` | Node scheduling controls         | `{}`             |

---

## Resource Details

This chart creates the following Kubernetes resources:

| Resource                  | Kind                                   | Purpose                                 | Template Path                              |
| ------------------------- | -------------------------------------- | --------------------------------------- | ------------------------------------------ |
| Next.js Deployment        | apps/v1 Deployment                     | Running Next.js application pods        | `templates/nextjs/deployment.yaml`         |
| Next.js Service           | v1 Service                             | Exposes Next.js pods internally         | `templates/nextjs/service.yaml`            |
| Next.js Ingress           | networking.k8s.io/v1 Ingress           | External HTTP/S routing to Next.js      | `templates/nextjs/ingress.yaml`            |
| Next.js HPA               | autoscaling/v2 HorizontalPodAutoscaler | Auto-scale Next.js pods by CPU/memory   | `templates/nextjs/hpa.yaml`                |
| Next.js PVC               | v1 PersistentVolumeClaim               | Persist Next.js data volume             | `templates/nextjs/pvc.yaml`                |
| Next.js NetworkPolicy     | networking.k8s.io/v1 NetworkPolicy     | Control ingress to Next.js pods         | `templates/nextjs/networkpolicy.yaml`      |
| Next.js ServiceAccount    | v1 ServiceAccount                      | Service account for Next.js pods        | `templates/nextjs/serviceaccount.yaml`     |
| Next.js ConfigMap         | v1 ConfigMap                           | Configuration data for Next.js          | `templates/nextjs/configmap.yaml`          |
| Next.js Secret            | v1 Secret                              | Environment secrets for Next.js         | `templates/nextjs/secret.yaml`             |
| Next.js Init Job          | batch/v1 Job                           | Initialization job for pre-deploy tasks | `templates/nextjs/job-init.yaml`           |
| Redis Deployment          | apps/v1 Deployment                     | Running Redis cache pods                | `templates/redis/deployment.yaml`          |
| Redis Service             | v1 Service                             | Exposes Redis service internally        | `templates/redis/service.yaml`             |
| Redis NetworkPolicy       | networking.k8s.io/v1 NetworkPolicy     | Control ingress to Redis pods           | `templates/redis/networkpolicy.yaml`       |
| Redis ServiceAccount      | v1 ServiceAccount                      | Service account for Redis pods          | `templates/redis/serviceaccount.yaml`      |
| Redis ConfigMap           | v1 ConfigMap                           | Configuration data for Redis            | `templates/redis/configmap.yaml`           |
| Redis Secret              | v1 Secret                              | Environment secrets for Redis           | `templates/redis/secret.yaml`              |
| Container Registry Secret | v1 Secret                              | Docker registry credentials             | `templates/nextjs/container-registry.yaml` |

## Resource Details

### NetworkPolicy

When `networkPolicy.enabled=true`, a NetworkPolicy is created to allow ingress to pods from any other pod (within the namespace) by default. Customize `networkPolicy.ingress` and `networkPolicy.policyTypes` to tighten access controls.

### ServiceAccount

A dedicated ServiceAccount (`{{ .Release.Name }}-nextjs`) is created with `automountServiceAccountToken=false` for security. Use `serviceAccount.name` to reference an existing SA instead.

### Secrets & ConfigMap

* **Secret**: Holds sensitive variables (`env.secret`) for Ghost: `TEST_SECRET_VARIABLE_1`, `TEST_SECRET_VARIABLE_2`, etc.
* **ConfigMap**: Holds non-sensitive variables (`env.normal`) such as `TEST_VARIABLE_1`, `TEST_VARIABLE_2`.

Define environment variables in values:

```yaml
env:
  normal:
    TEST_VARIABLE_1: "test1"
    TEST_VARIABLE_2: "test2"
  secret:
    TEST_SECRET_VARIABLE_1: "testsecret1"
    TEST_SECRET_VARIABLE_2: "testsecret2"
```

### Persistent Volume Claim

If `persistence.enabled=true`, a PVC is created to store Ghost content under `/data`. See the `persistence` section in [Values](#configuration).

### Deployment

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
    - host: example.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - example.com
      secretName: nextjs-example-tls
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

## Contributing

Contributions are welcome! Please open issues or pull requests against this repository.

## License

This chart is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
