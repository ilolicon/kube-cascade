{{/* Service Account Spawner */}}
{{/* Call this template:
{{ include "common.spawner.serviceAccount" $ -}}
*/}}

{{- define "common.spawner.serviceAccount" -}}
  {{- $fullname := include "common.lib.chart.names.fullname" $ -}}

  {{/* Primary validation for enabled service accounts. */}}
  {{- include "common.lib.serviceAccount.primaryValidation" $ -}}

  {{- range $name, $serviceAccount := .Values.serviceAccount -}}
    {{- $enabled := (include "common.lib.util.enabled" (dict
                    "rootCtx" $ "objectData" $serviceAccount
                    "name" $name "caller" "Service Account"
                    "key" "serviceAccount")) -}}

    {{- if eq $enabled "true" -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $serviceAccount) -}}

      {{- $objectName := $fullname -}}
      {{- if not $objectData.primary -}}
        {{- $objectName = (printf "%s-%s" $fullname $name) -}}
      {{- end -}}

      {{- include "common.lib.util.metaListToDict" (dict "objectData" $objectData) -}}

      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Service Account") -}}

      {{/* Set the name of the service account */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.serviceAccount" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}
