package main

warn_app_version_must_be_present[msg] {
    some i
    input[i].contents.kind == "Deployment"
    deployment := input[i].contents
    env := deployment.spec.template.spec.containers[_].env[_]
    msg := sprintf("env property with name '%v' must not be empty", [env.name])
    "APP_VERSION" == env.name ; "" == env.value
}

warn_app_version_env_variable_must_be_present[msg] {
    some i
    input[i].contents.kind == "Deployment"
    deployment := input[i].contents
    app_version_names := { envs | envs := deployment.spec.template.spec.containers[_].env[_]; envs.name == "APP_VERSION"}
    count(app_version_names) != 1
    msg := sprintf("'%v' env variable must be preset once", ["APP_VERSION"])
}

deny[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  not service_selects_app(deployment.spec.selector.matchLabels.app)

  msg := sprintf("Deployment %v with selector %v does not match any Services", [deployment.metadata.name, deployment.spec.selector.matchLabels])
}


deny[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  not security_context(deployment.spec.securityContext)

  msg := "Containers must not run as root or with escalated privileges"
}

service_selects_app(app) {
  input[service].contents.kind == "Service"
  input[service].contents.spec.selector.app == app
}

security_context(context) {
  context.runAsNonRoot
  context.allowPrivilegeEscalation
}
