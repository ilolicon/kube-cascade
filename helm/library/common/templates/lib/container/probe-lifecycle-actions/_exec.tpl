{{/* Returns exec action */}}
{{/* Call this template:
{{ include "common.lib.container.actions.exec" (dict "rootCtx" $ "objectData" $objectData "caller" $caller) }}
rootCtx: The root context of the chart.
objectData: The object data to be used to render the container.
*/}}
{{- define "common.lib.container.actions.exec" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}
  {{- $caller := .caller -}}

  {{- if not $objectData.command -}}
    {{- fail (printf "Container - Expected non-empty [%s] [command] on [exec] type" $caller) -}}
  {{- end }}
exec:
  command:
    {{- include "common.lib.container.command" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 4}}
{{- end -}}
