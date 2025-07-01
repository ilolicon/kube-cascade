{{/* Deployment Class */}}
{{/* Call this template:
{{ include "common.class.deployment" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData: The object data to be used to render the Deployment.
*/}}

{{- define "common.class.deployment" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}
  {{- include "common.lib.workload.deploymentValidation" (dict "objectData" $objectData) }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $objectData.name }}
  {{- with (include "common.lib.metadata.namespace" (dict "rootCtx" $rootCtx "objectData" $objectData "caller" "Deployment") | trim) }}
  namespace: {{ . }}
  {{- end }}
  {{- $labels := (mustMerge ($objectData.labels | default dict) (include "common.lib.metadata.allLabels" $rootCtx | fromYaml)) -}}
  {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
  labels:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- $annotations := (mustMerge ($objectData.annotations | default dict) (include "common.lib.metadata.allAnnotations" $rootCtx | fromYaml)) -}}
  {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
spec:
  {{- include "common.lib.workload.deploymentSpec" (dict "rootCtx" $rootCtx "objectData" $objectData) | indent 2 }}
  selector:
    matchLabels:
      {{- include "common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "pod" "objectName" $objectData.shortName) | trim | nindent 6 }}
  template:
    metadata:
        {{- $labels := (mustMerge ($objectData.podSpec.labels | default dict)
                                  (include "common.lib.metadata.allLabels" $rootCtx | fromYaml)
                                  (include "common.lib.metadata.podLabels" (dict "rootCtx" $rootCtx "objectData" $objectData) | fromYaml)
                                  (include "common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "pod" "objectName" $objectData.shortName) | fromYaml)) -}}
        {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
      labels:
        {{- . | nindent 8 }}
        {{- end -}}
        {{- $annotations := (mustMerge ($objectData.podSpec.annotations | default dict)
                                        (include "common.lib.metadata.allAnnotations" $rootCtx | fromYaml)
                                        (include "common.lib.metadata.podAnnotations" $rootCtx | fromYaml)) -}}
        {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
      annotations:
        {{- . | nindent 8 }}
        {{- end }}
    spec:
      {{- include "common.lib.workload.pod" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 6 }}
{{- end -}}
