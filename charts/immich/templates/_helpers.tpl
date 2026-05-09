{{/*
Expand the name of the chart.
*/}}
{{- define "immich.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "immich.chart" -}}
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
Create unified common selector labels
*/}}
{{- define "immich.common.selectorLabels" -}}
app: {{ template "immich.name" . }}
{{- end -}}

{{/* ——— Server ——— */}}

{{- define "immich.server.fullname" -}}
{{- if .Values.server.fullnameOverride }}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name "server" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "immich.server.labels" -}}
{{ include "immich.server.selectorLabels" . }}
{{- end -}}

{{- define "immich.server.selectorLabels" -}}
{{ include "immich.common.selectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "immich.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
component: {{ .Values.server.component | quote }}
helm.sh/chart: {{ include "immich.chart" . }}
tier: {{ .Values.server.tier | quote }}
{{- end -}}

{{- define "immich.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "immich.server.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* ——— Machine Learning ——— */}}

{{- define "immich.machineLearning.fullname" -}}
{{- if .Values.machineLearning.fullnameOverride }}
{{- .Values.machineLearning.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name "machine-learning" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "immich.machineLearning.labels" -}}
{{ include "immich.machineLearning.selectorLabels" . }}
{{- end -}}

{{- define "immich.machineLearning.selectorLabels" -}}
{{ include "immich.common.selectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "immich.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
component: {{ .Values.machineLearning.component | quote }}
helm.sh/chart: {{ include "immich.chart" . }}
tier: {{ .Values.machineLearning.tier | quote }}
{{- end -}}

{{- define "immich.machineLearning.serviceAccountName" -}}
{{- if .Values.machineLearning.serviceAccount.create }}
{{- default (include "immich.machineLearning.fullname" .) .Values.machineLearning.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.machineLearning.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* ——— Redis ——— */}}

{{- define "immich.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride }}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "immich.redis.labels" -}}
{{ include "immich.redis.selectorLabels" . }}
{{- end -}}

{{- define "immich.redis.selectorLabels" -}}
{{ include "immich.common.selectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "immich.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
component: {{ .Values.redis.component | quote }}
helm.sh/chart: {{ include "immich.chart" . }}
tier: {{ .Values.redis.tier | quote }}
{{- end -}}

{{- define "immich.redis.serviceAccountName" -}}
{{- if .Values.redis.serviceAccount.create }}
{{- default (include "immich.redis.fullname" .) .Values.redis.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.redis.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* ——— Database ——— */}}

{{- define "immich.database.fullname" -}}
{{- if .Values.database.fullnameOverride }}
{{- .Values.database.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name "database" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "immich.database.labels" -}}
{{ include "immich.database.selectorLabels" . }}
{{- end -}}

{{- define "immich.database.selectorLabels" -}}
{{ include "immich.common.selectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "immich.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
component: {{ .Values.database.component | quote }}
helm.sh/chart: {{ include "immich.chart" . }}
tier: {{ .Values.database.tier | quote }}
{{- end -}}

{{- define "immich.database.serviceAccountName" -}}
{{- if .Values.database.serviceAccount.create }}
{{- default (include "immich.database.fullname" .) .Values.database.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.database.serviceAccount.name }}
{{- end }}
{{- end }}
