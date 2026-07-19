{{/* Chart name (overridable). */}}
{{- define "seekrit-eso.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Fully qualified app name. */}}
{{- define "seekrit-eso.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "seekrit-eso.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "seekrit-eso.labels" -}}
helm.sh/chart: {{ include "seekrit-eso.chart" . }}
{{ include "seekrit-eso.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "seekrit-eso.selectorLabels" -}}
app.kubernetes.io/name: {{ include "seekrit-eso.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "seekrit-eso.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "seekrit-eso.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Name of the Secret holding the seekrit token. */}}
{{- define "seekrit-eso.tokenSecretName" -}}
{{- if .Values.seekrit.existingSecret -}}
{{- .Values.seekrit.existingSecret -}}
{{- else -}}
{{- include "seekrit-eso.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "seekrit-eso.tokenSecretKey" -}}
{{- if .Values.seekrit.existingSecret -}}
{{- .Values.seekrit.existingSecretTokenKey -}}
{{- else -}}
{{- "token" -}}
{{- end -}}
{{- end -}}

{{/*
Resolve the sidecar API key: explicit value wins, else reuse the key from a
prior install (so `helm upgrade` doesn't rotate it and break the SecretStore),
else generate a fresh one.
*/}}
{{- define "seekrit-eso.apiKey" -}}
{{- if .Values.sidecar.apiKey -}}
{{- .Values.sidecar.apiKey -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "seekrit-eso.fullname" .) -}}
{{- if and $existing $existing.data (hasKey $existing.data "sidecarApiKey") -}}
{{- index $existing.data "sidecarApiKey" | b64dec -}}
{{- else -}}
{{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}
{{- end -}}
