{{/* Endpoint Class */}}
{{/* Call this template:
{{ include "common.class.endpoint" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData: The service data, that will be used to render the Service object.
*/}}

{{- define "common.class.endpoint" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData }}
---
apiVersion: v1
kind: Endpoints
metadata:
  name: {{ $objectData.name }}
  namespace: {{ include "common.lib.metadata.namespace" (dict "rootCtx" $rootCtx "objectData" $objectData "caller" "Endpoint") }}
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
subsets:
  - addresses:
      {{- include "common.lib.endpoint.addresses" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 6 }}
    ports:
      {{- include "common.lib.endpoint.ports" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 6 }}
{{- end -}}
