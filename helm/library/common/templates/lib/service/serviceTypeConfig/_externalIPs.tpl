{{/* Service - externalIPs */}}
{{/* Call this template:
{{ include "common.lib.service.externalIPs" (dict "rootCtx" $rootCtx "objectData" $objectData) -}}
rootCtx: The root context of the chart.
objectData: The service object data
*/}}

{{- define "common.lib.service.externalIPs" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- with $objectData.externalIPs -}}
    {{- range . }}
- {{ tpl . $rootCtx }}
    {{- end -}}
  {{- end -}}
{{- end -}}
