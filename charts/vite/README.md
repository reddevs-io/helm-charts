# Vite Helm Chart

A Helm chart for deploying Vite applications on Kubernetes.

## Description

This chart deploys a Vite application using an Nginx web server to serve the static files. It's designed to be simple and lightweight, perfect for frontend applications built with Vite.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-vite-app`:

```bash
helm install my-vite-app ./charts/vite
```

## Uninstalling the Chart

To uninstall/delete the `my-vite-app` deployment:

```bash
helm delete my-vite-app
```

## Configuration

The following table lists the configurable parameters of the Vite chart and their default values.

### Basic Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `nginx` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `alpine` |
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the full name of the chart | `""` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Vite Specific Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `vite.buildDir` | Build output directory | `dist` |
| `vite.port` | Port for the web server | `80` |
| `vite.nginxConfig` | Custom nginx configuration | See values.yaml |

### Autoscaling Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `1` |
| `autoscaling.maxReplicas` | Maximum replicas | `100` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization | `80` |

### Container Registry Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `containerRegistry.enabled` | Enable private registry secret | `false` |
| `containerRegistry.secretName` | Secret name for registry | `""` |
| `containerRegistry.server` | Registry server | `""` |
| `containerRegistry.username` | Registry username | `""` |
| `containerRegistry.password` | Registry password | `""` |

## Usage Examples

### Basic Deployment

```bash
helm install my-vite-app ./charts/vite
```

### With Custom Image

```bash
helm install my-vite-app ./charts/vite \
  --set image.repository=my-registry/my-vite-app \
  --set image.tag=v1.0.0
```

### With Ingress Enabled

```bash
helm install my-vite-app ./charts/vite \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=my-app.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

### With Autoscaling

```bash
helm install my-vite-app ./charts/vite \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=2 \
  --set autoscaling.maxReplicas=10
```

## Building Your Vite App for Kubernetes

To use this chart with your Vite application, you'll need to:

1. Build your Vite app: `npm run build`
2. Create a Docker image with the built files
3. Use that image with this Helm chart

Example Dockerfile for a Vite app:

```dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Notes

- The chart uses Nginx Alpine by default to serve static files
- The nginx configuration includes SPA routing support (fallback to index.html)
- Static assets are cached for 1 year for optimal performance
- Health checks are configured for both liveness and readiness probes
