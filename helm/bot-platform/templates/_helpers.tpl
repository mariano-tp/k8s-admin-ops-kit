{{- define "bot-platform.name" -}}bot-platform{{- end -}}
{{- define "bot-platform.fullname" -}}bot-platform{{- end -}}
{{- define "bot-platform.labels" -}}
app.kubernetes.io/name: {{ include "bot-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
