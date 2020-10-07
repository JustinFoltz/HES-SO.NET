# Helm

## Installation

Tout d'abord il faut installer le client sur notre machine:

https://v2.helm.sh/docs/install/#installing-the-helm-client

Puis effectuer un :

```bash
helm init
```

Puis créer les RBAC associé :

```bash
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}
```

Helm est pret à être utilisé.