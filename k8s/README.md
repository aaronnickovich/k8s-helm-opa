# Kubernetes Setup
In your cluster, you will need to have the basic ingress nginx controller installed.
For this, you will need to run the following command in this folder:

```
kubectl apply -f ingress-nginx.yaml
```

Some simple example k8s manifests can be found in the `examples` folder to run and deploy a basic OPA application.
For a more production deployment, we can use the helm chart in the `helm` folder.
