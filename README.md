# OPA policies for helm and example opa docker service

This project is a basic application setup in Kubernetes. This project will remain provider agnostic as much as possible. Although my setup is going to be Docker Desktop for local, and EKS from Amazon for deployments. I also have docker-compose for a simple setup without K8s.

## Setup
Please have the following tools installed:
- helm
- docker
- opa
- conftest

for optional K8s deployment, please install the following tools:
- Terraform
- kubectl
- kubernetes locally or from a cloud provider
- optionally, cloud provider CLI (az, aws, gcp, etc)

## Using and Testing OPA

### Running OPA unit tests with conftest
```
cd helm
conftest verify --trace
```

### Verifying helm chart with OPA:
```
cd helm
helm template 0.1.0 k3s-helm-templates --values values.yaml | conftest test - --combine --trace -n "labels","podEnv","secContext","service"
```


## Running this project from docker compose:

First, make sure to update the bundles/example.rego file with any API rules.
Then, use docker compose to start up the services.
```shell
cd bundles/
opa build .\example.rego
cd ../
docker compose up -d
```

Test the URL authorization as such:
```shell
curl --user alice:password localhost:5000/finance/salary/alice
```

For windows users, try this:
```powershell
curl http://localhost:5000/finance/salary/alice -Headers @{accept='*/*';Authorization='Basic YWxpY2U6cGFzc3dvcmQ='};
```


## TODO(Aaron): How to run this project from K8S locally?
## TODO(Aaron): How to run this project on AWS or other providers?

