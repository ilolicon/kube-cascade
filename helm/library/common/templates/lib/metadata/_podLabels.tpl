{{/* Labels that are added to podSpec */}}
{{/* Call this template:
{{ include "common.lib.metadata.podLabels" $ }}
*/}}
{{- define "common.lib.metadata.podLabels" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- $type := $objectData.type -}}

  {{- $label := "" -}}
  {{- $fleeting := (list "CronJob" "Job") -}}
  {{- if (mustHas $type $fleeting) -}}
    {{- $label = "fleeting" -}}
  {{- end -}}

  {{- $permanent := (list "Deployment" "StatefulSet" "DaemonSet") -}}
  {{- if (mustHas $type $permanent) -}}
    {{- $label = "permanent" -}}
  {{- end -}}

  {{- if not (kindIs "string" $label) -}}
    {{- fail (printf "PodLabels - Expected [label] to be a string, but got [%s]" $label) -}}
  {{- end -}}

  {{- if not $label -}}
    {{- fail "PodLabels - Template used in a place that is not designed to be used" -}}
  {{- end }}
pod.lifecycle: {{ $label }}
{{- end -}}
