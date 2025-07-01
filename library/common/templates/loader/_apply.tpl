{{/* Loads all spawners */}}
{{- define "common.loader.apply" -}}

  {{/* Make sure there are not any YAML errors */}}
  {{- include "common.values.validate" .Values -}}

  {{/* Render Image Pull Secrets(s) */}}
  {{- include "common.spawner.imagePullSecret" . | nindent 0 -}}

  {{/* Render Service Accounts(s) */}}
  {{- include "common.spawner.serviceAccount" . | nindent 0 -}}

  {{/* Render Workload(s) */}}
  {{- include "common.spawner.workload" . | nindent 0 -}}

  {{/* Render Services(s) */}}
  {{- include "common.spawner.service" . | nindent 0 -}}

{{- end -}}
