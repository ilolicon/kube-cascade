{{/* Returns the global labels */}}
{{- define "common.lib.metadata.globalLabels" -}}

  {{- include "common.lib.metadata.render" (dict "rootCtx" $ "labels" .Values.global.labels) -}}

{{- end -}}
