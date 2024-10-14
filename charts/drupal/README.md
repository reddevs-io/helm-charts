# Drupal Helm Chart

This Helm chart deploys a Drupal application along with Redis and optional Solr on Kubernetes.

## Components

1. Drupal
2. Redis (optional)
3. Solr (optional)

## Configuration

### Drupal

#### Basic Configuration

- `drupal.replicaCount`: Number of Drupal replicas (default: 1)
- `drupal.image.repository`: Drupal image repository (default: nginx)
- `drupal.image.tag`: Drupal image tag (default: chart appVersion)
- `drupal.image.pullPolicy`: Image pull policy (default: IfNotPresent)

#### Environment Variables

- `drupal.env.normal`: List of normal environment variables
- `drupal.env.secret`: List of secret environment variables

#### PHP and Unit Configuration

- `drupal.phpConfig`: Custom PHP configuration
- `drupal.unitConfig`: Custom Unit configuration

#### Cron Jobs

- `drupal.cron.drupal.enable`: Enable Drupal cron job (default: true)
- `drupal.cron.drupal.schedule`: Cron job schedule (default: "0 */3 * * *")

#### Service Account

- `drupal.serviceAccount.create`: Create a service account (default: true)
- `drupal.serviceAccount.name`: Name of the service account

#### Ingress

- `drupal.ingress.enabled`: Enable ingress (default: false)
- `drupal.ingress.className`: Ingress class name
- `drupal.ingress.annotations`: Ingress annotations
- `drupal.ingress.hosts`: List of ingress hosts

#### Resources

- `drupal.resources.limits.memory`: Memory limit (default: 256Mi)
- `drupal.resources.requests.memory`: Memory request (default: 256Mi)

#### Persistence

- `drupal.volumes.drupal-public-files`: Configuration for public files volume
- `drupal.volumes.drupal-private-files`: Configuration for private files volume
- `drupal.volumes.drupal-simple-oauth-keys`: Configuration for OAuth keys volume

### Redis

- `redis.enable`: Enable Redis (default: true)
- `redis.replicaCount`: Number of Redis replicas (default: 1)
- `redis.image.repository`: Redis image repository (default: redis)
- `redis.image.tag`: Redis image tag (default: "7-alpine")

#### Redis Resources

- `redis.resources.limits.memory`: Memory limit (default: 512Mi)
- `redis.resources.requests.memory`: Memory request (default: 512Mi)

### Solr

- `solr.enable`: Enable Solr (default: false)
- `solr.replicaCount`: Number of Solr replicas (default: 1)
- `solr.image.repository`: Solr image repository (default: solr)
- `solr.image.tag`: Solr image tag (default: "9-slim")

## Usage

### Using the Remote Repository

This Helm chart is hosted in a remote repository. To use it, follow these steps:

1. Add the Helm repository:

   ```
   helm repo add io-brussels https://charts.brussels.io-internal.dev
   ```

2. Update your local Helm chart repository cache:

   ```
   helm repo update
   ```

3. Install the Drupal chart:

   ```
   helm install my-drupal-release io-brussels/drupal
   ```

   You can customize the installation by providing a values file:

   ```
   helm install my-drupal-release io-brussels/drupal -f my-values.yaml
   ```

4. To upgrade an existing release:

   ```
   helm upgrade my-drupal-release io-brussels/drupal
   ```

### Local Development

If you're working with a local copy of the chart:

1. Customize the `values.yaml` file according to your requirements.
2. Install the Helm chart:

   ```
   helm install my-drupal-release ./drupal-chart
   ```

3. To upgrade an existing release:

   ```
   helm upgrade my-drupal-release ./drupal-chart
   ```

## Notes

- Ensure that you have the required PersistentVolumes available for Drupal's file storage.
- If enabling Solr, make sure to configure Drupal to use the Solr service.
- The default configuration uses ClusterIP for services. Modify the service types if you need external access.
- When using the remote repository, make sure you have network access to `https://charts.brussels.io-internal.dev`.

For more detailed information on each configuration option, please refer to the comments in the `values.yaml` file.
