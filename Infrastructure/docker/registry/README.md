# Docker Registry

## Utilisation

### Accès au serveur 

Pour acceder au serveur :

```bash
ssh root@registry.jgo.sh
```

Accès de `test` :

    user: kube-hes 
    pass: jambonFromage

### Docker-compose

#### Crée un nouvel utilisateur 

Pour ajouté un nouvel utilisateur il faut se rendre sur le serveur de registry :

```bash
ssh root@registry.jgo.sh
cd /root/
```

Ensuite il suffit de créer un nouvel utilisateur :

```bash
htpasswd -Bbn testuser testpassword >> registry-auth/htpasswd
```

Puis redemarrer le registry :

```bash
docker-compose restart
```