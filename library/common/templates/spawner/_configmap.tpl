{{/* Configmap Spawwner */}}
{{/* Call this template:
{{ include "common.spawner.configmap" $ -}}
*/}}

{{- define "common.spawner.configmap" -}}
  {{- $fullname := include "common.lib.chart.names.fullname" $ -}}

  {{- range $name, $configmap := .Values.configmap -}}

    {{- $enabled := (include "common.lib.util.enabled" (dict
                    "rootCtx" $ "objectData" $configmap
                    "name" $name "caller" "ConfigMap"
                    "key" "configmap")) -}}

    {{- if eq $enabled "true" -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $configmap) -}}

      {{- $objectName := $name -}}

      {{- $expandName := (include "common.lib.util.expandName" (dict
                "rootCtx" $ "objectData" $objectData
                "name" $name "caller" "ConfigMap"
                "key" "configmap")) -}}

      {{- if eq $expandName "true" -}}
        {{- $objectName = (printf "%s-%s" $fullname $name) -}}
      {{- end -}}

      {{- include "common.lib.util.metaListToDict" (dict "objectData" $objectData) -}}

      {{/* Perform validations */}} {{/* Configmaps have a max name length of 253 */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName "length" 253) -}}
      {{- include "common.lib.configmap.validation" (dict "objectData" $objectData) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "ConfigMap") -}}

      {{/* Set the name of the configmap */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.configmap" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}
