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

deny_no_matching_service[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  not service_selects_app(deployment.spec.selector.matchLabels.app)

  msg := sprintf("Deployment %v with selector %v does not match any Services", [deployment.metadata.name, deployment.spec.selector.matchLabels])
}


deny_root_or_escalated_privileges[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  not security_context(deployment.spec.securityContext, deployment)

  msg := "Containers must not run as root or with escalated privileges"
}

service_selects_app(app) {
  input[service].contents.kind == "Service"
  input[service].contents.spec.selector.app == app
}

security_context(context, deployment) {
  context.runAsNonRoot == true
  security_context := [contexts | contexts := deployment.spec.template.spec.containers[_].securityContext; contexts.allowPrivilegeEscalation == true]
  count(security_context) < 1
}
