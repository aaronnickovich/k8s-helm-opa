package service

deny[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  not service_selects_app(deployment.spec.selector.matchLabels["app.kubernetes.io/name"])

  msg := sprintf("Deployment %v with selector %v does not match any Services", [deployment.metadata.name, deployment.spec.selector.matchLabels])
}

service_selects_app(app) {
  input[service].contents.kind == "Service"
  input[service].contents.spec.selector["app.kubernetes.io/name"] == app
}
