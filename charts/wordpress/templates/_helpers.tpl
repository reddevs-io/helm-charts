{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wordpress.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wordpress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create unified labels for wordpress components
*/}}
{{- define "wordpress.common.matchLabels" -}}
app: {{ template "wordpress.name" . }}
{{- end -}}

{{/*
Create unified labels for wordpress components
*/}}
{{- define "wordpress.labels" -}}
{{ include "wordpress.matchLabels" . }}
{{- end -}}

{{- define "wordpress.matchLabels" -}}
component: {{ .Values.name | quote }}
tier: {{ .Values.tier | quote }}
{{ include "wordpress.common.matchLabels" . }}
{{- end -}}

{{/*
Create the name of the deploy service account to use
*/}}
{{- define "wordpress.serviceAccountName" -}}
{{- default (include "wordpress.fullname" .) .Values.externalSecrets.serviceAccountName }}
{{- end }}
