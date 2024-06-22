package labels_test

import data.labels.deny

empty(value) {
	count(value) == 0
}

no_violations {
	empty(deny)
}

# Now the actual tests start
test_blank_input {
	no_violations with input as {}
}

test_not_deny_deployment_with_required_labels {
    input := [{"contents":{"kind":"Deployment","metadata":{"labels":{"app.kubernetes.io/name":"backend-service", "helm.sh/chart":"app-helm-1.0.0"},"name":"test"}}}]
	no_violations with input as input
}
