{{/* Image Pull Secrets Spawner */}}
{{/* Call this template:
{{ include "common.spawner.imagePullSecret" $ -}}
*/}}

{{- define "common.spawner.imagePullSecret" -}}
  {{- $fullname := include "common.lib.chart.names.fullname" $ -}}

  {{- range $name, $imgPullSecret := .Values.imagePullSecret -}}

    {{- $enabled := (include "common.lib.util.enabled" (dict
                    "rootCtx" $ "objectData" $imgPullSecret
                    "name" $name "caller" "Image Pull Secret"
                    "key" "imagePullSecret")) -}}

    {{- if $imgPullSecret.existingSecret -}}
      {{- continue -}}
    {{- end -}}
    {{- if eq $enabled "true" -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $imgPullSecret) -}}

      {{- $objectName := (printf "%s-%s" $fullname $name) -}}

      {{- include "common.lib.util.metaListToDict" (dict "objectData" $objectData) -}}

      {{/* Perform validations */}} {{/* Secrets have a max name length of 253 */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName "length" 253) -}}
      {{- include "common.lib.imagePullSecret.validation" (dict "objectData" $objectData) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Image Pull Secret") -}}
      {{- $data := include "common.lib.imagePullSecret.createData" (dict "rootCtx" $ "objectData" $objectData) -}}

      {{/* Update the data */}}
      {{- $_ := set $objectData "data" $data -}}

      {{/* Set the type to Image Pull Secret */}}
      {{- $_ := set $objectData "type" "imagePullSecret" -}}

      {{/* Set the name of the image pull secret */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.secret" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}
