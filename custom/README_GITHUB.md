# 🚀 Guide de déploiement GitHub pour ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

Ce guide vous accompagne pas à pas pour mettre votre ERP MTIB sur GitHub et configurer le déploiement automatique vers votre serveur OVH.

---

## 📋 Prérequis

- [x] Compte GitHub (créer sur [github.com](https://github.com))
- [x] Git installé localement (`git --version` pour vérifier)
- [x] Accès SSH au serveur VPS OVH
- [x] Modifications de customisation déjà effectuées

---

## 🔐 Étape 1 : Créer le repository GitHub (PRIVÉ)

### 1.1 Sur GitHub.com

1. Connectez-vous à [github.com](https://github.com)
2. Cliquez sur le bouton **"+"** en haut à droite > **"New repository"**
3. Configurez le repository :
   - **Repository name** : `erp-mtib` ou `dolibarr-mtib`
   - **Description** : "ERP personnalisé pour MTIB - EVE-MEDIA 2026"
   - **Visibility** : ⚠️ **PRIVATE** (très important !)
   - **Initialize** : Ne cochez RIEN (pas de README, pas de .gitignore, pas de licence)
4. Cliquez sur **"Create repository"**

### 1.2 Copier l'URL du repository

Vous verrez une URL comme :
```
https://github.com/votre-nom-utilisateur/erp-mtib.git
```

Copiez-la, vous en aurez besoin.

---

## 💻 Étape 2 : Initialiser Git localement

Ouvrez un terminal dans le dossier du projet :

```bash
cd c:\Users\hache\Projects\dolibarrerp\dolibarr
```

### 2.1 Initialiser le repository Git

```bash
git init
```

### 2.2 Configurer votre identité Git (si pas déjà fait)

```bash
git config user.name "Votre Nom"
git config user.email "votre.email@example.com"
```

### 2.3 Ajouter tous les fichiers

```bash
git add .
```

### 2.4 Créer le premier commit

```bash
git commit -m "Initial commit - ERP MTIB customization by EVE-MEDIA

Modifications effectuées:
- Suppression mentions Dolibarr de l'UI
- Copyright EVE-MEDIA 2026
- Configuration MTIB (Application Title, Company Name)
- Script SQL de configuration
- Documentation complète"
```

### 2.5 Lier au repository GitHub

Remplacez `votre-nom-utilisateur` par votre nom d'utilisateur GitHub :

```bash
git remote add origin https://github.com/votre-nom-utilisateur/erp-mtib.git
```

### 2.6 Créer la branche main et pousser

```bash
git branch -M main
git push -u origin main
```

**Vous devrez entrer vos identifiants GitHub.**

⚠️ **Note** : GitHub a arrêté le support des mots de passe. Vous devez utiliser un **Personal Access Token** :

1. Allez sur GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic)
2. **Generate new token**
3. Donnez un nom : "ERP MTIB - Deployment"
4. Cochez : `repo` (toutes les permissions)
5. **Generate token**
6. **COPIEZ LE TOKEN** (vous ne le reverrez plus !)
7. Utilisez ce token comme mot de passe lors du `git push`

---

## 🔧 Étape 3 : Configuration GitHub Actions

### 3.1 Créer la structure de workflows

```bash
mkdir -p .github\workflows
```

### 3.2 Créer le fichier de workflow

Créez le fichier `.github\workflows\deploy-ovh.yml` :

```yaml
name: Deploy to OVH VPS

on:
  push:
    branches: [ main ]
  workflow_dispatch: # Permet de lancer manuellement

jobs:
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🚀 Deploy via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.OVH_HOST }}
          username: ${{ secrets.OVH_USERNAME }}
          key: ${{ secrets.OVH_SSH_KEY }}
          port: ${{ secrets.OVH_PORT || 22 }}
          script: |
            echo "🔄 Début du déploiement..."
            cd /var/www/erp-mtib

            echo "📥 Git pull..."
            git pull origin main

            echo "🔐 Configuration des permissions..."
            chmod -R 775 documents/
            chmod -R 755 htdocs/

            echo "🔄 Redémarrage du serveur web..."
            sudo systemctl reload apache2 || sudo systemctl reload nginx

            echo "✅ Déploiement terminé !"

      - name: ✅ Deployment Success
        run: echo "Deployment completed successfully!"
```

### 3.3 Commit et push le workflow

```bash
git add .github/workflows/deploy-ovh.yml
git commit -m "feat: Add GitHub Actions deployment workflow"
git push origin main
```

---

## 🔑 Étape 4 : Configurer les secrets GitHub

### 4.1 Génération de la clé SSH (sur votre machine locale)

```bash
# Générer une paire de clés SSH
ssh-keygen -t ed25519 -C "github-deploy-mtib" -f github_deploy_mtib

# Cela crée 2 fichiers :
# - github_deploy_mtib (clé PRIVÉE)
# - github_deploy_mtib.pub (clé PUBLIQUE)
```

### 4.2 Copier la clé publique sur le serveur OVH

```bash
# Afficher la clé publique
cat github_deploy_mtib.pub

# Connectez-vous au serveur OVH via SSH et ajoutez la clé
ssh votre-user@votre-serveur-ovh.com
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Collez la clé publique, sauvegardez (Ctrl+O, Enter, Ctrl+X)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
exit
```

### 4.3 Ajouter les secrets sur GitHub

1. Allez sur votre repository GitHub
2. **Settings** > **Secrets and variables** > **Actions**
3. Cliquez sur **"New repository secret"**

Ajoutez ces 3 secrets :

| Nom | Valeur | Exemple |
|-----|--------|---------|
| `OVH_HOST` | IP ou domaine du serveur | `51.68.123.45` ou `mtib.votre-domaine.com` |
| `OVH_USERNAME` | Nom d'utilisateur SSH | `ubuntu` ou `root` |
| `OVH_SSH_KEY` | Clé privée SSH (contenu du fichier `github_deploy_mtib`) | `-----BEGIN OPENSSH PRIVATE KEY-----...` |

**Pour OVH_SSH_KEY** :
```bash
# Sur Windows
type github_deploy_mtib
# Copiez TOUT le contenu (de BEGIN à END inclus)

# Sur Linux/Mac
cat github_deploy_mtib
```

4. Optionnel : `OVH_PORT` (par défaut 22)

---

## 📦 Étape 5 : Préparer le serveur OVH

### 5.1 Connexion au serveur

```bash
ssh votre-user@votre-serveur-ovh.com
```

### 5.2 Installation de Git (si pas installé)

```bash
sudo apt update
sudo apt install git -y
```

### 5.3 Cloner le repository sur le serveur

```bash
cd /var/www
sudo git clone https://github.com/votre-nom-utilisateur/erp-mtib.git
cd erp-mtib
```

**Vous devrez entrer votre Personal Access Token comme mot de passe.**

### 5.4 Configuration Git sur le serveur

```bash
cd /var/www/erp-mtib
git config user.email "deploy@eve-media.com"
git config user.name "EVE-MEDIA Deploy Bot"
```

### 5.5 Permissions

```bash
sudo chown -R www-data:www-data /var/www/erp-mtib
sudo chmod -R 755 /var/www/erp-mtib
sudo chmod -R 775 /var/www/erp-mtib/documents
sudo chmod -R 775 /var/www/erp-mtib/htdocs/conf
```

### 5.6 Configuration base de données

```bash
cd /var/www/erp-mtib
mysql -u root -p erp_mtib < custom/mtib_config.sql
```

---

## ✅ Étape 6 : Tester le déploiement

### 6.1 Test manuel du workflow

1. Allez sur GitHub > votre repository
2. **Actions** tab
3. Cliquez sur **"Deploy to OVH VPS"**
4. Cliquez sur **"Run workflow"** > **"Run workflow"** (bouton vert)
5. Attendez que le workflow se termine (indicateur vert ✅)

### 6.2 Vérifier les logs

Cliquez sur le workflow en cours pour voir les logs en temps réel.

### 6.3 Test automatique

Faites une modification mineure :

```bash
# Sur votre machine locale
echo "Test déploiement automatique" >> custom/README.md
git add custom/README.md
git commit -m "test: Test automatic deployment"
git push origin main
```

Retournez sur GitHub > Actions pour voir le déploiement automatique se lancer !

---

## 🎯 Workflow complet après configuration

### Développement en local

```bash
# 1. Faire vos modifications
# ...

# 2. Tester localement
# Ouvrir dans XAMPP/MAMP/Docker

# 3. Commit et push
git add .
git commit -m "feat: Description de la modification"
git push origin main

# 4. GitHub Actions déploie automatiquement sur OVH ! 🚀
```

---

## 🔒 Sécurité

### Checklist de sécurité

- [ ] Repository GitHub configuré en **PRIVATE**
- [ ] Fichier `htdocs/conf/conf.php` dans `.gitignore` (déjà fait)
- [ ] Dossier `documents/` dans `.gitignore` (déjà fait)
- [ ] Clés SSH sécurisées (jamais commitées)
- [ ] Secrets GitHub configurés
- [ ] Permissions serveur correctes (775/755)
- [ ] Firewall OVH activé
- [ ] SSL/HTTPS activé sur le serveur

### En cas de problème

**Si le déploiement échoue** :
1. Vérifiez les logs dans Actions
2. Vérifiez que les secrets sont bien configurés
3. Testez la connexion SSH manuellement : `ssh -i github_deploy_mtib votre-user@serveur`
4. Vérifiez les permissions sur le serveur

**Si Git ne se met pas à jour sur le serveur** :
```bash
ssh votre-user@serveur
cd /var/www/erp-mtib
git status
git pull origin main
```

---

## 📚 Ressources utiles

- [Documentation Git](https://git-scm.com/doc)
- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [Documentation SSH](https://www.ssh.com/academy/ssh)
- [OVH VPS Guides](https://docs.ovh.com/fr/vps/)

---

## 🆘 Support

**Développé par** : EVE-MEDIA
**Email** : support@eve-media.com (à remplacer)
**Année** : 2026

---

**Bon déploiement ! 🚀**
