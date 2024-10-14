{{/*
Expand the name of the chart.
*/}}
{{- define "firefly-iii.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "firefly-iii.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified core name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "firefly-iii.core.fullname" -}}
{{- if .Values.core.fullnameOverride }}
{{- .Values.core.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name "core" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified database name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "firefly-iii.database.fullname" -}}
{{- if .Values.database.fullnameOverride }}
{{- .Values.database.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name "database" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified importer name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "firefly-iii.importer.fullname" -}}
{{- if .Values.importer.fullnameOverride }}
{{- .Values.importer.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name "importer" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Core labels
*/}}
{{- define "firefly-iii.core.labels" -}}
{{ include "firefly-iii.core.selectorLabels" . }}
{{- end }}

{{/*
Core selector labels
*/}}
{{- define "firefly-iii.core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "firefly-iii.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "firefly-iii.chart" . }}
component: {{ .Values.core.component | quote }}
tier: {{ .Values.core.tier | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Database labels
*/}}
{{- define "firefly-iii.database.labels" -}}
{{ include "firefly-iii.database.selectorLabels" . }}
{{- end }}

{{/*
Database selector labels
*/}}
{{- define "firefly-iii.database.selectorLabels" -}}
app.kubernetes.io/name: {{ include "firefly-iii.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "firefly-iii.chart" . }}
component: {{ .Values.database.component | quote }}
tier: {{ .Values.database.tier | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Importer labels
*/}}
{{- define "firefly-iii.importer.labels" -}}
{{ include "firefly-iii.importer.selectorLabels" . }}
{{- end }}

{{/*
Importer selector labels
*/}}
{{- define "firefly-iii.importer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "firefly-iii.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "firefly-iii.chart" . }}
component: {{ .Values.importer.component | quote }}
tier: {{ .Values.importer.tier | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
