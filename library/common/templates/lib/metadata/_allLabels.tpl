{{/* Labels that are added to all objects */}}
{{/* Call this template:
{{ include "common.lib.metadata.allLabels" $ }}
*/}}
{{- define "common.lib.metadata.allLabels" -}}
helm.sh/chart: {{ include "common.lib.chart.names.chart" . }}
helm-revision: {{ .Release.Revision | quote }}
app.kubernetes.io/name: {{ include "common.lib.chart.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ include "common.lib.chart.names.chart" . }}
release: {{ .Release.Name }}
{{- include "common.lib.metadata.globalLabels" . }}
{{- end -}}
