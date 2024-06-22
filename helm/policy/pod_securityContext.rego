package secContext

deny[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  security_context := [contexts | contexts := deployment.spec.template.spec.containers[_]; contexts.securityContext.allowPrivilegeEscalation == true]
  count(security_context) > 0

  msg := "Containers must not run with escalated privileges"
}

deny[msg] {
  input[i].contents.kind == "Deployment"

  deployment := input[i].contents

  deployment.spec.securityContext.runAsNonRoot == false

  msg := "Containers must not run as root"
}
