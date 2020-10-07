# Web App (Back + Front)

## Introduction

Application de réseau social géoloclisé.

**Réalisée par :** José Neto Gonçalves, Maxime Hutinet, Carina Inacio Oliviera, Guillaume Riondet, Justin Foltz

**Date :** 04.2020

## Utilisation

TBD...

### Containers

| Container | Nom (DNS) | Description | Ports |
| --------- | --------- | ----------- | ----- |
| postgres | django-db | Container utilisé pour la base donnée postgres | 5432 |
| python:3.7 | django-back | Container utilisé pour la partie backend de l'application | 8001:8000 |
| python:3.7 | django-front | Container utilisé pour la partie front-end de l'application | 8000:8000 |

### Environement de dev.

#### Mettre en place l'environement

Pour effectuer le demarrage du serveur il suffit de lancer :

```bash
docker-compose up -d
```

##### Création de l'utilisateur admin

```bash
docker exec -ti django-back bash
python manage.py createsuperuser
```

#### Détruire l'environement

Lancez :

```bash
docker-compose down
```


#### Rebuild l'environement

```bash
docker-compose up --build --force-recreate
```

## Problèmes connus

Problème de localisation : 

* Ouvrez firefox
* tapez `about:config`
* Puis modifiez la lignre `geo.wifi.uri` avec cette clé: 

```bash
https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%
```

## Sources

* https://docs.docker.com/compose/django/
* https://docs.docker.com/compose/compose-file/
* https://stackoverflow.com/questions/36884991/how-to-rebuild-docker-container-in-docker-compose-yml
