{{/* Annotations that are added to podSpec */}}
{{/* Call this template:
{{ include "common.lib.metadata.podAnnotations" $ }}
*/}}
{{- define "common.lib.metadata.podAnnotations" -}}
checksum/persistence: {{ toJson $.Values.persistence | sha256sum }}
checksum/services: {{ toJson $.Values.service | sha256sum }}
checksum/configmaps: {{ toJson $.Values.configmap | sha256sum }}
checksum/secrets: {{ toJson $.Values.secret | sha256sum }}
{{- end -}}
