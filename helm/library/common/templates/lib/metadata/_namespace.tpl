{{- define "common.lib.metadata.namespace" -}}
  {{- $caller := .caller -}}
  {{- $objectData := .objectData -}}
  {{- $rootCtx := .rootCtx -}}

  {{/*- $namespace := $rootCtx.Release.Namespace -*/}}
  {{/* 不获取Helm默认的namespace 未显示指定默认置空 原因：不通过Helm部署 namespace由其余CD组件控制 */}}
  {{- $namespace := "" -}}

  {{- with $rootCtx.Values.namespace -}}
    {{- $namespace = tpl . $rootCtx -}}
  {{- end -}}

  {{- with $objectData.namespace -}}
    {{- $namespace = tpl . $rootCtx -}}
  {{- end -}}

  {{- if and $namespace (not (and (mustRegexMatch "^[a-z0-9]((-?[a-z0-9]-?)*[a-z0-9])?$" $namespace) (le (len $namespace) 63))) -}}
    {{- fail (printf "%s - Namespace [%s] is not valid. Must start and end with an alphanumeric lowercase character. It can contain '-'. And must be at most 63 characters." $caller $namespace) -}}
  {{- end -}}

  {{- $namespace -}}

{{- end -}}
