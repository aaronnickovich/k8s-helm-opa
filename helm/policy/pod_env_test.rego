package podEnv_test

import data.podEnv.warn

empty(value) {
	count(value) == 0
}

no_violations {
	empty(warn)
}

# Now the actual tests start
test_blank_input {
	no_violations with input as {}
}

test_not_warn_pod_env {
    input := [{"contents":{"kind":"Deployment","spec":{"template":{"spec":{"containers":[{"env":[{"name":"APP_VERSION","value": ""}]}]}}}}}]
	no_violations with input as input
}

test_warn_pod_env_empty {
    input := [{"contents":{"kind":"Deployment","spec":{"template": {"spec":{"containers":[{"env":[{"name": "APP_VERSION", "value": ""}]}]}}}}}]
    warn["env property with name 'APP_VERSION' should not be empty"] with input as input
}

test_warn_no_pod_env {
    input := [{"contents":{"kind":"Deployment","spec":{"template": {"spec":{"containers":[{"env":[]}]}}}}}]
    warn["'APP_VERSION' env variable should be preset once"] with input as input
}

test_warn_no_pod_env {
    input := [{"contents":{"kind":"Deployment","spec":{"template":{"spec":{"containers":[{"env":[{"name":"APP_VERSION","value":"1.0.0"},{"name":"APP_VERSION","value":"1.0.1"}]}]}}}}}]
    warn["'APP_VERSION' env variable should be preset once"] with input as input
}
