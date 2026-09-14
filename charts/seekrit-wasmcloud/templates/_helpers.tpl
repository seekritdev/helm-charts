{{/* Chart name (overridable). */}}
{{- define "seekrit-wasmcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Fully qualified app name. */}}
{{- define "seekrit-wasmcloud.fullname" -}}
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

{{- define "seekrit-wasmcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "seekrit-wasmcloud.labels" -}}
helm.sh/chart: {{ include "seekrit-wasmcloud.chart" . }}
{{ include "seekrit-wasmcloud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "seekrit-wasmcloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "seekrit-wasmcloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "seekrit-wasmcloud.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "seekrit-wasmcloud.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Name of the Secret holding the profile file. */}}
{{- define "seekrit-wasmcloud.profileSecretName" -}}
{{- if .Values.existingSecret -}}
{{- .Values.existingSecret -}}
{{- else -}}
{{- include "seekrit-wasmcloud.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "seekrit-wasmcloud.profileSecretKey" -}}
{{- if .Values.existingSecret -}}
{{- .Values.existingSecretKey -}}
{{- else -}}
{{- "wasmcloud.json" -}}
{{- end -}}
{{- end -}}

{{/*
Fail early on the two configurations that would otherwise break at runtime in a
way that points nowhere near this chart.
*/}}
{{- define "seekrit-wasmcloud.validate" -}}
{{- if and (not .Values.existingSecret) (not .Values.profiles) -}}
{{- fail "seekrit-wasmcloud: set `profiles` (or `existingSecret`) — a backend with no profiles would refuse every request." -}}
{{- end -}}
{{- range $name, $profile := .Values.profiles }}
{{- if not $profile.token -}}
{{- fail (printf "seekrit-wasmcloud: profile `%s` has no `token`." $name) -}}
{{- end -}}
{{- if not (hasPrefix "skt_" $profile.token) -}}
{{- fail (printf "seekrit-wasmcloud: profile `%s`: `token` must be a service token (skt_…). A login session or an M2M client secret cannot resolve." $name) -}}
{{- end -}}
{{- if and (not $profile.issuers) (not $profile.entities) -}}
{{- fail (printf "seekrit-wasmcloud: profile `%s` declares no `issuers` or `entities`, so nothing signed selects it. An application name is unsigned metadata and cannot be the only matcher." $name) -}}
{{- end -}}
{{- end -}}
{{- $seed := or .Values.backend.xkeySeed .Values.backend.xkeySeedExistingSecret -}}
{{- if and (gt (int .Values.replicaCount) 1) (not $seed) -}}
{{- fail "seekrit-wasmcloud: replicaCount > 1 needs `backend.xkeySeed` (or `backend.xkeySeedExistingSecret`). Replicas share a queue group, so `server_xkey` and `get` can land on different pods; without one shared seed each advertises its own key and requests fail to open. Generate a seed with `wash keys gen curve`." -}}
{{- end -}}
{{- end -}}
