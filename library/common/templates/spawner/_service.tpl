{{/* Service Spawner */}}
{{/* Call this template:
{{ include "common.spawner.service" $ -}}
*/}}

{{- define "common.spawner.service" -}}
  {{- $fullname := include "common.lib.chart.names.fullname" $ -}}

  {{/* Primary validation for enabled service. */}}
  {{- include "common.lib.service.primaryValidation" $ -}}

  {{- range $name, $service := .Values.service -}}
    {{- $enabled := (include "common.lib.util.enabled" (dict
                    "rootCtx" $ "objectData" $service
                    "name" $name "caller" "Service"
                    "key" "service")) -}}

    {{- if ne $enabled "true" -}}{{- continue -}}{{- end -}}

    {{/* Create a copy of the configmap */}}
    {{- $objectData := (mustDeepCopy $service) -}}
    {{- $namespace := (include "common.lib.metadata.namespace" (dict "rootCtx" $ "objectData" $service "caller" "Service")) -}}

    {{/* Init object name */}}
    {{- $objectName := $name -}}

    {{- $expandName := (include "common.lib.util.expandName" (dict
                    "rootCtx" $ "objectData" $objectData
                    "name" $name "caller" "Service"
                    "key" "service")) -}}

    {{- if eq $expandName "true" -}}
      {{/* Expand the name of the service if expandName resolves to true */}}
      {{- $objectName = $fullname -}}
    {{- end -}}

    {{- if and (eq $expandName "true") (not $objectData.primary) -}}
      {{/* If the service is not primary append its name to fullname */}}
      {{- $objectName = (printf "%s-%s" $fullname $name) -}}
    {{- end -}}

    {{- include "common.lib.util.metaListToDict" (dict "objectData" $objectData) -}}

    {{/* Perform validations */}}
    {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
    {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Service") -}}
    {{- include "common.lib.service.validation" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{/* Set the name of the service */}}
    {{- $_ := set $objectData "name" $objectName -}}
    {{- $_ := set $objectData "shortName" $name -}}

    {{/* Now iterate over the ports in the service */}}
    {{- range $port := $service.ports -}}
      {{- $enabledP := (include "common.lib.util.enabled" (dict
                    "rootCtx" $ "objectData" $port
                    "name" $name "caller" "service"
                    "key" "port")) -}}
      {{- if ne $enabledP "true" -}}{{- continue -}}{{- end -}}
    {{- end -}}

    {{/* Call class to create the object */}}
    {{- include "common.class.service" (dict "rootCtx" $ "objectData" $objectData) -}}
  {{- end -}}

{{- end -}}
