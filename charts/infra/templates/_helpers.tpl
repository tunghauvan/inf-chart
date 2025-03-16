{{- define "infra.argocdApp" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .app.namespace }}-{{ .appName | replace "_" "-" }}
  namespace: {{ .app.namespace }}
spec:
  destination:
    namespace: '{{ .app.namespace }}'
    server: https://kubernetes.default.svc
  project: {{ .global.project }}
  source:
    path: charts/generic
    repoURL: '{{ default .global.repoURL .app.repoURL }}'
    targetRevision: '{{ default .global.targetRevision .app.targetRevision }}'
  sources:
    - helm:
        valueFiles:
          - $service_value/{{ .global.name }}/{{ .appName }}-accesstrade.yaml
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
      repoURL: '{{ default .global.repoURL .app.repoURL }}'
      targetRevision: '{{ default .global.targetRevision .app.targetRevision }}'
    - ref: service_value
      repoURL: '{{ default .global.repoURL .app.repoURL }}'
      targetRevision: '{{ default .global.targetRevision .app.targetRevision }}'
{{- end -}}
