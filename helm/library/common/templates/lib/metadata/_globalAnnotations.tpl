{{/* Returns the global annotations */}}
{{- define "common.lib.metadata.globalAnnotations" -}}

  {{- include "common.lib.metadata.render" (dict "rootCtx" $ "annotations" .Values.global.annotations) -}}

{{- end -}}
