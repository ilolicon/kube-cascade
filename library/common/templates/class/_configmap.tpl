{{/* Configmap Class */}}
{{/* Call this template:
{{ include "common.class.configmap" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData:
  name: The name of the configmap.
  labels: The labels of the configmap.
  annotations: The annotations of the configmap.
  data: The data of the configmap.
  namespace: The namespace of the configmap. (Optional)
*/}}

{{- define "common.class.configmap" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $objectData.name }}
  {{- with (include "common.lib.metadata.namespace" (dict "rootCtx" $rootCtx "objectData" $objectData "caller" "Configmap")) | trim }}
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
data:
  {{- tpl (toYaml $objectData.data) $rootCtx | nindent 2 }}
  {{/* This comment is here to add a new line */}}
{{- end -}}
