{{/*
Expand the name of the chart.
*/}}
{{- define "drupal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default drupal fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "drupal.drupal.fullname" -}}
{{- if .Values.drupal.fullnameOverride }}
{{- .Values.drupal.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.drupal.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default redis fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "drupal.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride }}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.redis.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default solr fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "drupal.solr.fullname" -}}
{{- if .Values.solr.fullnameOverride }}
{{- .Values.solr.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.solr.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "drupal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "drupal.common.matchLabels" -}}
helm.sh/chart: {{ include "drupal.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ template "drupal.name" . }}
{{- end -}}

{{/*
Create unified labels for drupal components
*/}}
{{- define "drupal.drupal.labels" -}}
{{ include "drupal.drupal.matchLabels" . }}
{{- end -}}

{{- define "drupal.drupal.matchLabels" -}}
component: {{ .Values.drupal.name | quote }}
tier: {{ .Values.drupal.tier | quote }}
{{ include "drupal.common.matchLabels" . }}
{{- end -}}

{{/*
Create unified labels for redis components
*/}}
{{- define "drupal.redis.labels" -}}
{{ include "drupal.redis.matchLabels" . }}
{{- end -}}

{{- define "drupal.redis.matchLabels" -}}
component: {{ .Values.redis.name | quote }}
tier: {{ .Values.redis.tier | quote }}
{{ include "drupal.common.matchLabels" . }}
{{- end -}}

{{/*
Create unified labels for redis components
*/}}
{{- define "drupal.solr.labels" -}}
{{ include "drupal.solr.matchLabels" . }}
{{- end -}}

{{- define "drupal.solr.matchLabels" -}}
component: {{ .Values.solr.name | quote }}
tier: {{ .Values.solr.tier | quote }}
{{ include "drupal.common.matchLabels" . }}
{{- end -}}

{{/*
Create the name of the drupal service account to use
*/}}
{{- define "drupal.drupal.serviceAccountName" -}}
{{- if .Values.drupal.serviceAccount.create }}
{{- default (include "drupal.drupal.fullname" .) .Values.drupal.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.drupal.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the redis service account to use
*/}}
{{- define "drupal.redis.serviceAccountName" -}}
{{- if .Values.redis.serviceAccount.create }}
{{- default (include "drupal.redis.fullname" .) .Values.redis.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.redis.serviceAccount.name }}
{{- end }}
{{- end }}
