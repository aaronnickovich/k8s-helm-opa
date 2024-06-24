package service_test

import data.service.deny

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

test_deny_with_no_matching_service {
    cfg := [{"contents":{"metadata": { "name": "backend"},"kind":"Deployment","spec":{"selector":{"matchLabels":{"app.kubernetes.io/name":"frontend"}}}}},{"contents":{"kind":"Service","spec":{"selector":{"app": "backend"}}}}]
    deny["Deployment backend with selector {\"app.kubernetes.io/name\": \"frontend\"} does not match any Services"] with input as cfg
}

test_not_deny_with_matching_service_labels {
    cfg := [{"contents":{"kind":"Deployment","spec":{"selector":{"matchLabels":{"app.kubernetes.io/name":"backend"}}}}},{"contents":{"kind":"Service","spec":{"selector":{"app.kubernetes.io/name": "backend"}}}}]
	no_violations with input as cfg
}
