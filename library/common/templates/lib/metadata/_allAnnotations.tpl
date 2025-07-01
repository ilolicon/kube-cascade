{{/* Annotations that are added to all objects */}}
{{/* Call this template:
{{ include "common.lib.metadata.allAnnotations" $ }}
*/}}
{{- define "common.lib.metadata.allAnnotations" -}}
  {{/* Currently empty but can add later, if needed */}}
{{- include "common.lib.metadata.globalAnnotations" . }}

{{- end -}}
