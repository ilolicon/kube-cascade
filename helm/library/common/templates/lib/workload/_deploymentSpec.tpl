{{/* Deployment Spec */}}
{{/* Call this template:
{{ include "common.lib.workload.deploymentSpec" (dict "rootCtx" $rootCtx "objectData" $objectData) -}}
rootCtx: The root context of the chart.
objectData:
  replicas: The number of replicas.
  revisionHistoryLimit: The number of old ReplicaSets to retain to allow rollback.
  strategy: The deployment strategy to use to replace existing pods with new ones.
*/}}
{{- define "common.lib.workload.deploymentSpec" -}}
  {{- $objectData := .objectData -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $strategy := $objectData.strategy | default "RollingUpdate" -}}
  {{- $replicas := 1 -}}
  {{- if hasKey $objectData "replicas" -}}
    {{- $replicas = $objectData.replicas -}}
  {{- end }}
  {{- if (include "common.lib.util.stopAll" $rootCtx) -}}
    {{- $replicas = 0 -}}
  {{- end }}
replicas: {{ $replicas }}
revisionHistoryLimit: {{ $objectData.revisionHistoryLimit | default 5 }}
strategy:
  type: {{ $strategy }}
  {{- if and (eq $strategy "RollingUpdate") $objectData.rollingUpdate -}}
    {{ if (or (hasKey $objectData.rollingUpdate "maxUnavailable") (hasKey $objectData.rollingUpdate "maxSurge")) }}
  rollingUpdate:
      {{- if hasKey $objectData.rollingUpdate "maxUnavailable" }}
    maxUnavailable: {{ $objectData.rollingUpdate.maxUnavailable }}
      {{- end -}}
      {{- if hasKey $objectData.rollingUpdate "maxSurge" }}
    maxSurge: {{ $objectData.rollingUpdate.maxSurge }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
