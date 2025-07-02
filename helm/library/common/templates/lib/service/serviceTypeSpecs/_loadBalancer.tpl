{{/* Service - LoadBalancer Spec */}}
{{/* Call this template:
{{ include "common.lib.service.spec.loadBalancer" (dict "rootCtx" $rootCtx "objectData" $objectData) -}}
rootCtx: The root context of the chart.
objectData: The service object data
*/}}

{{- define "common.lib.service.spec.loadBalancer" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData }}

type: LoadBalancer
allocateLoadBalancerNodePorts: {{ $objectData.allocateLoadBalancerNodePorts | default false }}
publishNotReadyAddresses: {{ include "common.lib.service.publishNotReadyAddresses" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim }}
  {{- with (include "common.lib.service.externalIPs" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
externalIPs:
    {{- . | nindent 2 }}
  {{- end -}}
  {{- with $objectData.loadBalancerSourceRanges }}
loadBalancerSourceRanges:
    {{- range . }}
  - {{ tpl . $rootCtx }}
    {{- end -}}
  {{- end -}}
  {{- include "common.lib.service.clusterIP" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 0 }}
  {{- include "common.lib.service.ipFamily" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 0 }}
  {{- include "common.lib.service.externalTrafficPolicy" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 0 }}
  {{- include "common.lib.service.sessionAffinity" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 0 }}
{{- end -}}
