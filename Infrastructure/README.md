# HES - Projet de semestre - Cluster k8s

## Introduction

Dans le cadre du projet de semestre nous avions comme directive de mettre en place un solution se reposant sur une infrastructure agile. Par agile nous entendons par la "scalable" au maximum et non restrictive (Pas de cloud captif). 

Pour cela nous avons mis en place un cluster kubernetes chez un `fournisseur` Suisse. Cela garantit que nos données ne sont pas vehiculés hors de la juridiction Suisse. 

Ensuite nous avons utilisé `Terraform` qui est un `I.A.C` (`Infrastructure as Code`), c'est un langage `déclaratif`, basé sur l'approche `immutable`, en d'autres mots, cela veut dire que nous `déclarons` notre infrastructure et le provider fait le necessaire pour que notre infrastructure soit la même quelque soit le fournisseur. On ajoute à cela l'approche `immutable` qui elle va nous garantir de ne pas cummuler de changements sur une machine et la transformé en "flocon de neige", en deployant a chaque fois une nouvelle machine qui est ensuite configuré via `Ansible` ou tout autre outil de gestion de configuration. ("Chef", "Puppet", "Saltstack", ...)

L'approche à été la suivante :

* Choix du provider : `Exoscale`
* Choix de la technologie: `Kubernetes self hosted`
* Approche de deploiement: `Terraform + Ansible`
* Orchestrateur: `Terraform + Kubernetes`
* Scalabilité horizontal: `Kubernetes`
* Scalabilité verticale: `Exoscale + Kubernetes`

## Infrastructure 

  Image Infra (TODO)
  
| Nom | Fonction | DNS (A/CNAME) | Ports | 
| --- | -------- | ------------- | ----- |
| master-01 | k8s-master | k8s-master.jgo.sh | 22, 80, 443 |
| worker-01 | k8s-worker-01 | k8s-worker-01.jgo.sh | 22 |
| worker-02 | k8s-worker-01 | k8s-worker-02.jgo.sh | 22 |
| worker-03 | k8s-worker-03 | k8s-worker-03.jgo.sh | 22 | 


### Utilisation

#### Terraform

Comment deployer une nouvelle infrastructure : https://www.terraform.io/downloads.html 

On récupère le binaire Terraform ici : 



On commence par initialisé les dependances :

```bash
❯ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "exoscale" (terraform-providers/exoscale) 0.16.1...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```bash
# Terraform plan permet de prévisualisé ce qui va être deployé sur le cloud
❯ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.exoscale_compute_template.ubuntu: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # exoscale_compute.master-01 will be created
  + resource "exoscale_compute" "master-01" {
      + affinity_group_ids = (known after apply)
      + affinity_groups    = (known after apply)
      + disk_size          = 20
...
...
      + id                 = (known after apply)
      + ip4                = true
      + ip6                = false
      + ip6_address        = (known after apply)
      + ip6_cidr           = (known after apply)
      + ip_address         = (known after apply)
      + key_pair           = "jgo@work"
      + name               = (known after apply)
      + password           = (sensitive value)
      + security_group_ids = (known after apply)
      + security_groups    = [
          + "k8s-worker-sg",
        ]
      + size               = "Normal"
      + state              = "Running"
      + tags               = {
          + "environement" = "dev"
          + "role"         = "k8s Worker"
        }
      + template           = (known after apply)
      + template_id        = "287b6306-fdeb-4dc6-855d-90c4f68f572b"
      + user_data          = <<~EOT
            #cloud-config
            manage_etc_hosts: k8s-worker-02.jgo.sh
        EOT
      + user_data_base64   = (known after apply)
      + username           = (known after apply)
      + zone               = "ch-dk-2"

      + timeouts {
          + create = "60m"
          + delete = "2h"
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
Cela permettera de prévisualisé le deployment si on effectue une mauvaise opération on peut vite détruire tout le cluster.

Une fois validé on peut deployé, avec la commande `terraform apply`:

```bash
terraform apply
```

Si le deploiement est conforme entrez `yes`.

##### Docs

* Terraform: https://www.terraform.io/docs/cli-index.html

#### Ansible

#### Kubernetes

##### Installation de kubectl 

##### Création d'un utilisateur

Pour créer un utilisateur, inspirez-vous de l'exemple ici => Infrastructure/k8s-manifests/utils/00-user-access.yaml

```bash
kubectl apply -f 00-user-access.yaml
```
Pour récupérer le token :

```bash
❯ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep minouche-admin | awk '{print $1}')
Name:         minouche-admin-token-5s4sz
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: minouche-admin
              kubernetes.io/service-account.uid: a25a4d65-d64d-4068-9f13-47b8ab60986e

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      <redacted> 
```

##### Accès au dashboard

Pour acceder au dashboard il suffit de lancer la commande suivante :

```bash
kubectl --namespace=kube-system port-forward <kubernetes-dashboard-podname> 8443
```

Celle-ci aura pour effet de monter un tunnel entre votre machine et le cluster `kubernetes`.

Pour acceeder cluster tapper cette adresse sur le naviguateur: 

https://localhost:8443

Ensuite il faut récupéré le token :

```bash
kubectl -n kubernetes-dashboard get secret

NAME                               TYPE                                  DATA   AGE
default-token-2pjhm                kubernetes.io/service-account-token   3      81m
kubernetes-dashboard-certs         Opaque                                0      81m
kubernetes-dashboard-csrf          Opaque                                1      81m
kubernetes-dashboard-key-holder    Opaque                                2      81m
kubernetes-dashboard-token-x9nd8   kubernetes.io/service-account-token   3      81m

kubectl -n kubernetes-dashboard describe secrets kubernetes-dashboard-token-x9nd8

Name:         kubernetes-dashboard-token-x9nd8
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: kubernetes-dashboard
              kubernetes.io/service-account.uid: 2140a425-447f-437f-9966-24ab4e57217a

Type:  kubernetes.io/service-account-token

Data
====
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC10b2tlbi14OW5kOCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjIxNDBhNDI1LTQ0N2YtNDM3Zi05OTY2LTI0YWI0ZTU3MjE3YSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDprdWJlcm5ldGVzLWRhc2hib2FyZCJ9.oSOjJZpQq-yiAIQWM12gFpVA6jiJz8-zApC0Wbet9iwzflmCVFlT1lWjEEduKMnJOF-viJ4fwLixA3INfCxDgWIBmxEvoA-R6ExQNkmFi4ljGdBX98fI2B4WFuqWIPoEjqf1l3eXHKmXgqbiMYA-UH_Ih4m2-aKKO3dfkmc5HmPP1ZjotCQKGpcq60c1y-SASqbC_FC3LHvp0l5N9bfhAOraNC_34ZlL3zkQ6cAL6mZG8Ci1MuXMHTH9g04QaVZb14f6BAY-K2X-Z5yDpMr4Zs5h6DOc_18sysf4uOVyo0wMXfI9gLsda-e3zX_5W39piBj-PwfBwBGslC_JztTCSQ
ca.crt:     1066 bytes
namespace:  20 bytes
```

## Notes

