{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Release.Name .Values.appName | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Expand the namespace of the chart.
*/}}
{{- define "chart.namespace" -}}
{{- default .Release.Namespace .Values.namespace | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chart.labels" -}}
helm.sh/chart: {{ include "chart.chart" . }}
{{ include "chart.selectorLabels" . }}
{{- if .Values.appVersion }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/namespace: {{ .Release.Namespace }}
app.kubernetes.io/app: {{ .Values.appName | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "chart.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "chart.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Calculate the checksum of a given data
*/}}
{{- define "common.checksum" -}}
{{- $data := . | toJson -}}
{{- $checksum := sha256sum $data -}}
{{- $checksum | trunc 63 | trimSuffix "-" -}}
{{- end }}


{{/*
Create the checksum label for the .Values.secrets.data
*/}}
{{- define "secret.checksumLabels" -}}
{{- if and .Values.secrets .Values.secrets.data }}
  {{- $checksum := include "common.checksum" .Values.secrets.data -}}
  checksum.secret/{{ include "chart.name" . }}: {{ $checksum }}
{{- end }}
{{- end }}

{{/*
Create the checksum label for the .Values.configs.data
*/}}
{{- define "config.checksumLabels" -}}
{{- if and .Values.configs .Values.configs.data }}
  {{- $checksum := include "common.checksum" .Values.configs.data -}}
  checksum.config/{{ include "chart.name" . }}: {{ $checksum }}
{{- end }}
{{- end }}
