package secContext_test

import data.secContext.deny

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

test_not_deny_correct_security_context {
    input := [{"contents":{"kind":"Deployment","spec":{"securityContext":{"runAsNonRoot": true},"template": {"spec":{"containers":[{"securityContext": {"allowPrivilegeEscalation": false}}]}}}}}]
	no_violations with input as input
}

test_deny_root_security_context {
    input := [{"contents":{"kind":"Deployment","spec":{"securityContext":{"runAsNonRoot": false},"template": {"spec":{"containers":[{"securityContext": {"allowPrivilegeEscalation": false}}]}}}}}]
    deny["Containers must not run as root"] with input as input
}

test_deny_privileged_escalation_security_context {
    input := [{"contents":{"kind":"Deployment","spec":{"securityContext":{"runAsNonRoot": true},"template": {"spec":{"containers":[{"securityContext": {"allowPrivilegeEscalation": true}}]}}}}}]
    deny["Containers must not run with escalated privileges"] with input as input
}
