{{/*
Expand the name of the chart.
*/}}
{{- define "nextjs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default nextjs fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextjs.nextjs.fullname" -}}
{{- if .Values.nextjs.fullnameOverride }}
{{- .Values.nextjs.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nextjs.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default storybook fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextjs.storybook.fullname" -}}
{{- if .Values.storybook.fullnameOverride }}
{{- .Values.storybook.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.storybook.nameOverride }}
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
{{- define "nextjs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nextjs.common.matchLabels" -}}
helm.sh/chart: {{ include "nextjs.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ template "nextjs.name" . }}
{{- end -}}

{{/*
Create unified labels for nextjs components
*/}}
{{- define "nextjs.nextjs.labels" -}}
{{ include "nextjs.nextjs.matchLabels" . }}
{{- end -}}

{{- define "nextjs.nextjs.matchLabels" -}}
component: {{ .Values.nextjs.name | quote }}
tier: {{ .Values.nextjs.tier | quote }}
{{ include "nextjs.common.matchLabels" . }}
{{- end -}}

{{/*
Create unified labels for storybook components
*/}}
{{- define "nextjs.storybook.labels" -}}
{{ include "nextjs.storybook.matchLabels" . }}
{{- end -}}

{{- define "nextjs.storybook.matchLabels" -}}
component: {{ .Values.storybook.name | quote }}
tier: {{ .Values.storybook.tier | quote }}
{{ include "nextjs.common.matchLabels" . }}
{{- end -}}

{{/*
Create the name of the nextjs service account to use
*/}}
{{- define "nextjs.nextjs.serviceAccountName" -}}
{{- if .Values.nextjs.serviceAccount.create }}
{{- default (include "nextjs.nextjs.fullname" .) .Values.nextjs.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.nextjs.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the storybook service account to use
*/}}
{{- define "nextjs.storybook.serviceAccountName" -}}
{{- if .Values.storybook.serviceAccount.create }}
{{- default (include "nextjs.storybook.fullname" .) .Values.storybook.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.storybook.serviceAccount.name }}
{{- end }}
{{- end }}
