{{/* Service Account Class */}}
{{/* Call this template:
{{ include "common.class.serviceAccount" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData:
  name: The name of the serviceAccount.
  labels: The labels of the serviceAccount.
  annotations: The annotations of the serviceAccount.
  autoMountToken: Whether to mount the ServiceAccount token or not.
*/}}

{{- define "common.class.serviceAccount" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ $objectData.name }}
  namespace: {{ include "common.lib.metadata.namespace" (dict "rootCtx" $rootCtx "objectData" $objectData "caller" "Service Account") }}
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
automountServiceAccountToken: {{ $objectData.automountServiceAccountToken | default false }}
{{- end -}}
