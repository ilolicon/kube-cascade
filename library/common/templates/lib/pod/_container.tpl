{{/* Returns Container */}}
{{/* Call this template:
{{ include "common.lib.pod.container" (dict "rootCtx" $ "objectData" $objectData) }}
rootCtx: The root context of the chart.
objectData: The object data to be used to render the Pod.
*/}}
{{- define "common.lib.pod.container" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- $imageObj := fromJson (include "common.lib.container.imageSelector" (dict "rootCtx" $rootCtx "objectData" $objectData)) -}}
  {{- $termination := fromJson (include "common.lib.container.termination" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
- name: {{ $objectData.name }}
  image: {{ printf "%s:%s" $imageObj.repository $imageObj.tag }}
  imagePullPolicy: {{ $imageObj.pullPolicy }}
  tty: {{ $objectData.tty | default false }}
  stdin: {{ $objectData.stdin | default false }}
  {{- with (include "common.lib.container.command" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  command:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- with (include "common.lib.container.args" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  args:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- with $termination.messagePath }}
  terminationMessagePath: {{ . }}
  {{- end -}}
  {{- with $termination.messagePolicy }}
  terminationMessagePolicy: {{ . }}
  {{- end -}}
  {{- with (include "common.lib.container.lifecycle" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  lifecycle:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- with (include "common.lib.container.ports" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  ports:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- with (include "common.lib.container.volumeMount" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  volumeMounts:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- include "common.lib.container.probes" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- with (include "common.lib.container.resources" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  resources:
    {{- . | nindent 4 }}
  {{- end }}
  securityContext:
  {{- include "common.lib.container.securityContext" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 4 }}
  {{- /* Create a dict for storing env's so it can be checked for dupes */ -}}
  {{- $_ := set $objectData "envDupe" dict -}}
  {{- with (include "common.lib.container.envFrom" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  envFrom:
    {{- . | nindent 4 }}
  {{- end }}
  env:
    {{- include "common.lib.container.fixedEnv" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 4 -}}
    {{- include "common.lib.container.env" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 4 -}}
    {{- include "common.lib.container.envList" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 4 -}}
  {{- $_ := unset $objectData "envDupe" -}}
{{- end -}}
