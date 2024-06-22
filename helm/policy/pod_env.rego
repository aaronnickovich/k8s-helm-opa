package podEnv

warn[msg] {
    some i
    input[i].contents.kind == "Deployment"
    deployment := input[i].contents
    env := deployment.spec.template.spec.containers[_].env[_]
    msg := sprintf("env property with name '%v' should not be empty", [env.name])
    "APP_VERSION" == env.name ; "" == env.value
}

warn[msg] {
    some i
    input[i].contents.kind == "Deployment"
    deployment := input[i].contents
    app_version_names := { envs | envs := deployment.spec.template.spec.containers[_].env[_]; envs.name == "APP_VERSION"}
    count(app_version_names) != 1
    msg := sprintf("'%v' env variable should be preset once", ["APP_VERSION"])
}
