{{/* Main entrypoint for the library */}}
{{- define "common.loader.all" -}}

  {{- include "common.loader.init" . -}}
  
  {{- include "common.loader.apply" . -}}

{{- end -}}
