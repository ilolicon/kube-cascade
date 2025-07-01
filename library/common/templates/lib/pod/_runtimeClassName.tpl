{{/* Returns Runtime Class Name */}}
{{/* Call this template:
{{ include "common.lib.pod.runtimeClassName" (dict "rootCtx" $ "objectData" $objectData) }}
rootCtx: The root context of the chart.
objectData: The object data to be used to render the Pod.
*/}}
{{- define "common.lib.pod.runtimeClassName" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- $runtime := "" -}}

  {{/* Initialize from the "defaults" */}}
  {{- with $rootCtx.Values.podOptions.runtimeClassName -}}
    {{- $runtime = tpl . $rootCtx -}}
  {{- end -}}

  {{/* Override from the pod values, if defined */}}
  {{- with $objectData.podSpec.runtimeClassName -}}
    {{- $runtime = tpl . $rootCtx -}}
  {{- end -}}

  {{- $runtime -}}
{{- end -}}
