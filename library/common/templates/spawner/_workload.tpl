{{/* Workload Spawner */}}
{{/* Call this template:
{{ include "common.spawner.workload" $ -}}
*/}}

{{- define "common.spawner.workload" -}}
  {{- $fullname := include "common.lib.chart.names.fullname" $ -}}

  {{/* Primary validation for enabled workload. */}}
  {{- include "common.lib.workload.primaryValidation" $ -}}

  {{- range $name, $workload := .Values.workload -}}

    {{- $enabled := (include "common.lib.util.enabled" (dict
                    "rootCtx" $ "objectData" $workload
                    "name" $name "caller" "Workload"
                    "key" "workload")) -}}

    {{- if eq $enabled "true" -}}

      {{/* Create a copy of the workload */}}
      {{- $objectData := (mustDeepCopy $workload) -}}

      {{/* Generate the name of the workload */}}
      {{- $objectName := $fullname -}}
      {{- if not $objectData.primary -}}
        {{- $objectName = printf "%s-%s" $fullname $name -}}
      {{- end -}}

      {{- include "common.lib.util.metaListToDict" (dict "objectData" $objectData) -}}

      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Workload") -}}

      {{/* Set the name of the workload */}}
      {{- $_ := set $objectData "name" $objectName -}}

      {{/* Short name is the one that defined on the chart, used on selectors */}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Set the podSpec so it doesn't fail on nil pointer */}}
      {{- if not (hasKey $objectData "podSpec") -}}
        {{- fail "Workload - Expected [podSpec] key to exist" -}}
      {{- end -}}

      {{/* Call class to create the object */}}
      {{- if eq $objectData.type "Deployment" -}}
        {{- include "common.class.deployment" (dict "rootCtx" $ "objectData" $objectData) -}}
      {{- end -}}

    {{- end -}}

  {{- end -}}

{{- end -}}
