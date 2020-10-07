# Git 

## Introduction

tbd...

### Utiilisation

#### Principe

Voici le principe de base :

Notre projet sera basé sur deux branches : `master` et `develop`. Ces deux branches sont strictement interdites en écriture aux développeurs.

La branche `master` est le miroir de notre `production`. Il est donc logique que l'on ne puisse y pousser nos modifications directement.

La branche `develop` centralise toutes les nouvelles fonctionnalités qui seront livrées dans la prochaine version. 
Ici il va falloir se forcer à ne pas y faire de modifications directement.

Trois autres types de branches vont ensuite nous permettre de travailler :

* `feature`
* `release`
* `hotfix`

Exemple en image:

![GitWorkflow](https://blog.xebia.fr/wp-content/uploads/2018/03/Gitflow.png)

##### Création de nouvelles features

Vu que nous allons créer un nouvelle `feature` il faudra créer une nouvelle branche feature. 
Si je développe une nouvelle fonctionnalitée, elle sera logiquement appliqué à la prochaine version : je crée donc ma branche à partir de la branche develop :

```bash
git checkout -b feature/<super_nom_de_feature> develop
```

Ensuite, je commence à travailler à partir du code mis à jour pour la nouvelle version.

Lorsque j'ai fini mon travail, je rapatrie celui-ci sur la branche de développement et je supprime la branche `feature` qui est devenue obsolète

```bash
git checkout develop
git pull
git merge feature/<nom> --no-ff
git branch -d feature/<nom>
git push
```
Ici le nom de la feature devrait correspondre a l'`ID` de l'issue Jira.

On peut également merger directement sur gitlab le résultat sera le même.

##### Création d'une release

Je commence par crée la branche de `release`:

Je crée la branche à partir de la branche `develop`, ainsi je pourrais lancer mes tests et appliquer mes corrections pendant que mes collègues commencent déjà le développement de nouvelles fonctionnalités pour la version suivante :

```bash
git checkout -b release/<version> develop
```

Lorsque tous mes tests sont passés avec succès et que ma nouvelle version est prête à être mise en production, je pousse tout sur la branche master et je n'oublie pas d'appliquer mes corrections à la branche de développement.

Je crée aussi un `tag` sur le dernier commit de la branche de production avec mon numéro de version afin de m'y retrouver plus tard.

Et enfin je supprime la branche release car maintenant elle ne sert plus à grand chose.

```bash
git checkout develop
git merge release/<version> --no-ff

git checkout master
git merge release/<version> --no-ff
git tag <version>

git branch -d release/<version>
git push
```

##### Correction de bugs

Je commence par créer une branche de type `hotfix`.

Pour ce cas particulier je crée ma branche à partir du miroir de production car je ne veux pas que toutes les fonctionnalités de ma branche de développement se retrouve en production lors d'une simple correction de bug :

```bash
git checkout -b hotfix/<name> master
```

Mon bug étant corrigé, je dois l'appliquer sur le dev et la prod. Une fois encore je versionne avec un tag sur la branche master et je supprime la branche hotfix:

```bash
git checkout develop
git merge hotfix/<name> --no-ff

git checkout master
git merge hotfix/<name> --no-ff
git tag <version>

git branch -d hotfix/<name>
gut push
```
