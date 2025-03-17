{{- define "infra.argocdApp" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .app.namespace }}-{{ .appName | replace "_" "-" }}
  namespace: argocd
spec:
  destination:
    namespace: '{{ .app.namespace }}'
    server: '{{ .global.server }}'
  project: {{ .global.project }}
  source:
    path: charts/generic
    repoURL: '{{ default .global.repoURL .app.chartRepoURL }}'
    targetRevision: '{{ default .global.targetRevision .app.chartTargetRevision }}'
  sources:
    - helm:
        {{- if .app.uniqueValue }}
        valueFiles:
          - $service_value/{{ .global.name }}/{{ .appName }}.yaml
        {{- end }}
        parameters:
          - name: replicaCount
            value: '{{ .app.replicaCount }}'
          {{- if and .app.image .app.image.tag }}
          - name: image.tag
            value: '{{ .app.image.tag }}'
          {{- end }}
          {{- range .app.override_values }}
          - name: {{ .name }}
            value: '{{ .value }}'
          {{- end }}
          {{- range $key, $value := .app.data }}
          - name: {{ $key }}
            value: '{{ $value }}'
          {{- end }}
      path: charts/generic
      repoURL: '{{ default .global.repoURL .app.chartRepoURL }}'
      targetRevision: '{{ default .global.targetRevision .app.chartTargetRevision }}'
    - ref: service_value
      repoURL: '{{ default .global.repoURL .app.repoURL }}'
      targetRevision: '{{ default .global.targetRevision .app.targetRevision }}'
{{- end -}}
