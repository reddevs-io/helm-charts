# Vite Helm Chart

A Helm chart for deploying Vite applications on Kubernetes with optional Node.js backend support.

## Description

This chart deploys a Vite application using an Nginx web server to serve the static files. It's designed to be simple and lightweight, perfect for frontend applications built with Vite. The chart also supports an optional Node.js backend component for full-stack applications.

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
| `image.tag` | Image tag | `1.28-alpine` |
| `imagePullSecrets` | Image pull secrets | `[]` |
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the full name of the chart | `""` |
| `component` | Component label | `vite` |
| `tier` | Tier label | `frontend` |

### Image Credentials Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `imageCredentials.registry` | Private registry server | `""` |
| `imageCredentials.username` | Registry username | `""` |
| `imageCredentials.password` | Registry password | `""` |
| `imageCredentials.email` | Registry email | `""` |

### Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env.normal` | Normal environment variables (key-value pairs) | `[]` |
| `env.secret` | Secret environment variables (key-value pairs) | `[]` |

### Service Account Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.automount` | Automount service account token | `false` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |

### Pod Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podAnnotations` | Pod annotations | `{}` |
| `podLabels` | Pod labels | `{}` |
| `podSecurityContext` | Pod security context | `{}` |

### Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `securityContext.capabilities.drop` | Dropped capabilities | `[ALL]` |
| `securityContext.readOnlyRootFilesystem` | Read-only root filesystem | `true` |
| `securityContext.runAsNonRoot` | Run as non-root user | `true` |
| `securityContext.runAsUser` | User ID to run as | `1000` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8080` |

### Network Policy Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `networkPolicy.enabled` | Enable network policy | `true` |
| `networkPolicy.ingress` | Ingress rules | See values.yaml |
| `networkPolicy.policyTypes` | Policy types | `[Ingress]` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Resources Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.memory` | Memory limit | `300Mi` |
| `resources.limits.cpu` | CPU limit | Not set |
| `resources.requests.cpu` | CPU request | Not set |
| `resources.requests.memory` | Memory request | Not set |

### Health Probes Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.httpGet.path` | Liveness probe path | `/` |
| `livenessProbe.httpGet.port` | Liveness probe port | `http` |
| `livenessProbe.initialDelaySeconds` | Initial delay | `10` |
| `livenessProbe.periodSeconds` | Period | `10` |
| `readinessProbe.httpGet.path` | Readiness probe path | `/` |
| `readinessProbe.httpGet.port` | Readiness probe port | `http` |
| `readinessProbe.initialDelaySeconds` | Initial delay | `5` |
| `readinessProbe.periodSeconds` | Period | `5` |

### Autoscaling Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `1` |
| `autoscaling.maxReplicas` | Maximum replicas | `100` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization | Not set |

### Volumes Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `volumes` | Additional volumes | `[]` |
| `volumeMounts` | Additional volume mounts | `[]` |

### Scheduling Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity.nodeAffinity` | Node affinity rules | Linux nodes required |
| `affinity.podAntiAffinity` | Pod anti-affinity rules | Prefer different nodes |

### Vite Specific Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `vite.nginxConfig.enabled` | Enable custom nginx configuration | `false` |
| `vite.nginxConfig.config` | Custom nginx configuration content | See values.yaml |

### Node.js Backend Configuration

The chart supports an optional Node.js backend component. All Node.js parameters are prefixed with `nodejs.*`.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodejs.enable` | Enable Node.js backend | `false` |
| `nodejs.replicaCount` | Number of replicas | `1` |
| `nodejs.component` | Component label | `nodejs` |
| `nodejs.tier` | Tier label | `backend` |
| `nodejs.image.repository` | Image repository | `node` |
| `nodejs.image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `nodejs.image.tag` | Image tag | `24-alpine` |
| `nodejs.service.type` | Service type | `ClusterIP` |
| `nodejs.service.port` | Service port | `3000` |
| `nodejs.ingress.enabled` | Enable ingress | `false` |
| `nodejs.ingress.hosts` | Ingress hosts | See values.yaml |
| `nodejs.resources.limits.memory` | Memory limit | `300Mi` |
| `nodejs.livenessProbe.httpGet.path` | Liveness probe path | `/health` |
| `nodejs.readinessProbe.httpGet.path` | Readiness probe path | `/health` |

The Node.js backend supports the same configuration options as the frontend (env, serviceAccount, podAnnotations, podLabels, securityContext, networkPolicy, autoscaling, volumes, volumeMounts, nodeSelector, tolerations, affinity).

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

### With Private Registry

```bash
helm install my-vite-app ./charts/vite \
  --set image.repository=my-registry.com/my-vite-app \
  --set image.tag=v1.0.0 \
  --set imageCredentials.registry=my-registry.com \
  --set imageCredentials.username=myuser \
  --set imageCredentials.password=mypassword \
  --set imageCredentials.email=myemail@example.com
```

### With Environment Variables

```bash
helm install my-vite-app ./charts/vite \
  --set env.normal.API_URL=https://api.example.com \
  --set env.normal.ENVIRONMENT=production \
  --set env.secret.API_KEY=secret-key-here
```

### With Ingress Enabled

```bash
helm install my-vite-app ./charts/vite \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=my-app.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

### With Autoscaling

```bash
helm install my-vite-app ./charts/vite \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=2 \
  --set autoscaling.maxReplicas=10 \
  --set autoscaling.targetCPUUtilizationPercentage=70
```

### With Node.js Backend

Deploy a full-stack application with Vite frontend and Node.js backend:

```bash
helm install my-fullstack-app ./charts/vite \
  --set image.repository=my-registry/my-vite-frontend \
  --set image.tag=v1.0.0 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=app.example.com \
  --set nodejs.enable=true \
  --set nodejs.image.repository=my-registry/my-node-backend \
  --set nodejs.image.tag=v1.0.0 \
  --set nodejs.ingress.enabled=true \
  --set nodejs.ingress.hosts[0].host=api.example.com
```

### With Custom Nginx Configuration

```bash
helm install my-vite-app ./charts/vite \
  --set vite.nginxConfig.enabled=true \
  --set-file vite.nginxConfig.config=./custom-nginx.conf
```

## Building Your Vite App for Kubernetes

To use this chart with your Vite application, you'll need to:

1. Build your Vite app: `npm run build`
2. Create a Docker image with the built files
3. Use that image with this Helm chart

### Example Dockerfile for Vite Frontend

```dockerfile
FROM nginx:1.28-alpine

# Copy built files
COPY dist/ /usr/share/nginx/html/

# Create nginx user and set permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Use non-root user
USER nginx

# Expose port 8080 (not 80, as we run as non-root)
EXPOSE 8080

# Custom nginx config for non-root
RUN echo 'server { \
    listen 8080; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ { \
        expires 1y; \
        add_header Cache-Control "public, immutable"; \
    } \
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
```

### Example Dockerfile for Node.js Backend

```dockerfile
FROM node:24-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Use non-root user
USER node

# Expose port 3000
EXPOSE 3000

CMD ["node", "server.js"]
```

## Architecture

This Helm chart supports two deployment architectures:

### 1. Frontend Only (Default)
- Deploys a Vite static site served by Nginx
- Suitable for static sites or SPAs that consume external APIs
- Lightweight and simple

### 2. Full-Stack (Frontend + Backend)
- Deploys both Vite frontend and Node.js backend
- Each component has its own deployment, service, and optional ingress
- Backend typically runs on port 3000, frontend on port 8080
- Suitable for applications requiring a custom API backend

## Security Features

The chart includes several security best practices by default:

- **Non-root user**: Containers run as user ID 1000
- **Read-only root filesystem**: Prevents runtime modifications
- **Dropped capabilities**: All Linux capabilities are dropped
- **Network policies**: Enabled by default to control traffic
- **Pod anti-affinity**: Spreads pods across nodes for high availability
- **Service account**: Dedicated service account with automount disabled

## Notes

- The chart uses Nginx 1.28-alpine by default to serve static files
- The nginx configuration includes SPA routing support (fallback to index.html)
- Static assets are cached for 1 year for optimal performance
- Health checks are configured for both liveness and readiness probes
- The default service port is 8080 (not 80) to support non-root containers
- Network policies are enabled by default for enhanced security
- When using the Node.js backend, ensure your backend exposes a `/health` endpoint for health checks
