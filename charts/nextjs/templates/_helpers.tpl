{{/*
Expand the name of the chart.
*/}}
{{- define "nextjs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nextjs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a docker registry secret
*/}}
{{- define "imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nextjs.common.selectorLabels" -}}
app: {{ template "nextjs.name" . }}
{{- end }}

{{/*
Create a default fully qualified nextjs name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextjs.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "nextjs.labels" -}}
{{ include "nextjs.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nextjs.selectorLabels" -}}
helm.sh/chart: {{ include "nextjs.chart" . }}
app.kubernetes.io/name: {{ include "nextjs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "nextjs.common.selectorLabels" . }}
component: {{ .Values.component | quote }}
tier: {{ .Values.tier | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nextjs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nextjs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextjs.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride }}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name "redis" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "nextjs.redis.labels" -}}
{{ include "nextjs.redis.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nextjs.redis.selectorLabels" -}}
helm.sh/chart: {{ include "nextjs.chart" . }}
app.kubernetes.io/name: {{ include "nextjs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "nextjs.common.selectorLabels" . }}
component: {{ .Values.redis.component | quote }}
tier: {{ .Values.redis.tier | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nextjs.redis.serviceAccountName" -}}
{{- if .Values.redis.serviceAccount.create }}
{{- default (include "nextjs.redis.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.redis.serviceAccount.name }}
{{- end }}
{{- end }}
