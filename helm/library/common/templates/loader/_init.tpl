
{{/* Initialiaze values of the chart */}}
{{- define "common.loader.init" -}}

  {{/* Merge chart values and the common chart defaults */}}
  {{- include "common.values.init" . -}}

{{- end -}}