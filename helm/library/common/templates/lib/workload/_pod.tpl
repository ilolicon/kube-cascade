{{/* Pod Spec */}}
{{/* Call this template:
{{ include "common.lib.workload.pod" (dict "rootCtx" $ "objectData" $objectData) }}
rootCtx: The root context of the chart.
objectData: The object data to be used to render the Pod.
*/}}
{{- define "common.lib.workload.pod" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData }}
serviceAccountName: {{ include "common.lib.pod.serviceAccountName" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
automountServiceAccountToken: {{ include "common.lib.pod.automountServiceAccountToken" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
  {{- with (include "common.lib.pod.runtimeClassName" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
runtimeClassName: {{ . }}
  {{- end }}
  {{- with (include "common.lib.pod.imagePullSecret" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
imagePullSecrets:
    {{-  . | nindent 2 }}
  {{- end }}
hostNetwork: {{ include "common.lib.pod.hostNetwork" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
hostPID: {{ include "common.lib.pod.hostPID" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
hostIPC: {{ include "common.lib.pod.hostIPC" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
shareProcessNamespace: {{ include "common.lib.pod.shareProcessNamespace" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
enableServiceLinks: {{ include "common.lib.pod.enableServiceLinks" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
restartPolicy: {{ include "common.lib.pod.restartPolicy" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
  {{- with (include "common.lib.pod.schedulerName" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
schedulerName: {{ . }}
  {{- end -}}
  {{- with (include "common.lib.pod.priorityClassName" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
priorityClassName: {{ . }}
  {{- end -}}
  {{- with (include "common.lib.pod.nodeSelector" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
nodeSelector:
    {{- . | nindent 2 }}
  {{- end -}}
  {{- with (include "common.lib.pod.topologySpreadConstraints" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
topologySpreadConstraints:
    {{- . | nindent 2 }}
  {{- end -}}
  {{- with (include "common.lib.pod.hostAliases" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
hostAliases:
    {{- . | nindent 2 }}
  {{- end -}}
  {{- with (include "common.lib.pod.hostname" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
hostname: {{ . }}
  {{- end -}}
  {{- include "common.lib.pod.dns" (dict "rootCtx" $rootCtx "objectData" $objectData) -}}
  {{- with (include "common.lib.pod.terminationGracePeriodSeconds" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
terminationGracePeriodSeconds: {{ . }}
  {{- end -}}
  {{- with (include "common.lib.pod.tolerations" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
tolerations:
    {{- . | nindent 2 }}
  {{- end }}
securityContext:
  {{- include "common.lib.pod.securityContext" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 }}
hostUsers: {{ include "common.lib.pod.hostUsers" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
  {{- if $objectData.podSpec.containers }}
containers:
    {{- include "common.lib.pod.containerSpawner" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- end -}}
  {{- if $objectData.podSpec.initContainers }}
initContainers:
    {{- include "common.lib.pod.initContainerSpawner" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- end -}}
  {{- with (include "common.lib.pod.volumes" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
volumes:
  {{- . | nindent 2 }}
{{- end -}}
{{- end -}}
