{{/* Returns Host Users */}}
{{/* Call this template:
{{ include "common.lib.pod.hostPID" (dict "rootCtx" $ "objectData" $objectData) }}
rootCtx: The root context of the chart.
objectData: The object data to be used to render the Pod.
*/}}
{{- define "common.lib.pod.hostUsers" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- $hostUsers := false -}}

  {{- if $objectData.podSpec.calculatedHostUsers -}}
    {{- $hostUsers = true -}}
  {{- end -}}

  {{/* Override from the "global" option */}}
  {{- if (kindIs "bool" $rootCtx.Values.podOptions.hostUsers) -}}
    {{- $hostUsers = $rootCtx.Values.podOptions.hostUsers -}}
  {{- end -}}

  {{/* Override with pods option */}}
  {{- if (kindIs "bool" $objectData.podSpec.hostUsers) -}}
    {{- $hostUsers = $objectData.podSpec.hostUsers -}}
  {{- end -}}

  {{- $hostUsers -}}
{{- end -}}
