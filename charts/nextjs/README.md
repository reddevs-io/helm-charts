# Next.js Helm Chart

This Helm chart deploys a Next.js application on a Kubernetes cluster. It also includes an optional Storybook deployment.

## Chart Details

This chart will create the following Kubernetes resources:
- Deployment for the Next.js application
- Service for the Next.js application
- Ingress (optional)
- ServiceAccount
- Optional Storybook deployment

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0+

## Installing the Chart

### Using the Chart from the Repository

This chart is available in the Brussels.io internal Helm chart repository. To use it:

1. Add the Brussels.io internal Helm repository to your Helm installation:

   ```bash
   helm repo add io-brussels https://charts.brussels.io-internal.dev
   helm repo update
   ```

2. Install the chart with the release name `my-release`:

   ```bash
   helm install my-release io-brussels/nextjs
   ```

   Replace `nextjs` with the actual name of the chart in the repository if it's different.

3. To override default values, you can either specify them on the command line:

   ```bash
   helm install my-release io-brussels/nextjs --set nextjs.replicaCount=3
   ```

   Or create a custom `values.yaml` file and use it:

   ```bash
   helm install my-release io-brussels/nextjs -f my-values.yaml
   ```

### Installing from Local Files

If you have the chart files locally, you can install the chart with:

```bash
helm install my-release /path/to/chart
```

## Configuration

The following table lists the configurable parameters of the Next.js chart and their default values.

### Next.js Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nextjs.replicaCount` | Number of Next.js replicas | `1` |
| `nextjs.image.repository` | Next.js image repository | `nginx` |
| `nextjs.image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `nextjs.image.tag` | Image tag | `""` (defaults to chart appVersion) |
| `nextjs.env.normal` | Normal environment variables | `[]` |
| `nextjs.env.secret` | Secret environment variables | `[]` |
| `nextjs.imagePullSecrets` | Image pull secrets | `[]` |
| `nextjs.nameOverride` | Override chart name | `""` |
| `nextjs.fullnameOverride` | Override full chart name | `""` |
| `nextjs.serviceAccount.create` | Create service account | `true` |
| `nextjs.serviceAccount.automount` | Automount service account token | `true` |
| `nextjs.serviceAccount.annotations` | Service account annotations | `{}` |
| `nextjs.serviceAccount.name` | Service account name | `""` |
| `nextjs.podAnnotations` | Pod annotations | `{}` |
| `nextjs.podLabels` | Pod labels | `{}` |
| `nextjs.service.type` | Service type | `ClusterIP` |
| `nextjs.service.port` | Service port | `3000` |
| `nextjs.ingress.enabled` | Enable ingress | `false` |
| `nextjs.resources` | CPU/Memory resource requests/limits | `{}` |
| `nextjs.livenessProbe` | Liveness probe configuration | `httpGet` on `/` |
| `nextjs.readinessProbe` | Readiness probe configuration | `httpGet` on `/` |
| `nextjs.autoscaling.enabled` | Enable autoscaling | `false` |
| `nextjs.volumes` | Additional volumes | `[]` |
| `nextjs.volumeMounts` | Additional volume mounts | `[]` |

### Storybook Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `storybook.enable` | Enable Storybook deployment | `false` |
| `storybook.replicaCount` | Number of Storybook replicas | `1` |
| `storybook.image.repository` | Storybook image repository | `nginx` |
| `storybook.image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `storybook.image.tag` | Image tag | `""` |
| `storybook.env.normal` | Normal environment variables | `[]` |
| `storybook.env.secret` | Secret environment variables | `[]` |
| `storybook.service.type` | Service type | `ClusterIP` |
| `storybook.service.port` | Service port | `80` |
| `storybook.ingress.enabled` | Enable ingress | `false` |

## Usage

1. Modify the `values.yaml` file to set the desired configuration options.
2. Install or upgrade the chart using Helm:

   ```bash
   helm upgrade --install my-release io-brussels/nextjs -f values.yaml
   ```

3. Access your Next.js application using the configured ingress or service.

## Customization

To customize the chart further, you can:

1. Override values using the `--set` flag in the Helm command.
2. Modify the templates in the `templates/` directory (if you have local access to the chart).
3. Create your own `values.yaml` file with your specific configuration.

## Troubleshooting

If you encounter issues:

1. Check the pod status: `kubectl get pods`
2. View pod logs: `kubectl logs <pod-name>`
3. Describe the pod for events: `kubectl describe pod <pod-name>`

For more information on Helm chart development and usage, refer to the [Helm documentation](https://helm.sh/docs/).