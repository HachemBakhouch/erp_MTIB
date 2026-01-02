# Guide de Déploiement - ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

---

## 📋 Méthodes de déploiement disponibles

Actuellement, le projet **n'a pas de pipeline GitHub Actions** configuré.
Vous devez déployer manuellement les modifications vers le VPS OVH.

---

## 🚀 Méthode 1: Déploiement manuel via SSH (Recommandé)

### Étapes complètes

1. **Pousser vos modifications vers GitHub** (depuis votre machine locale):
   ```bash
   git add .
   git commit -m "Description des changements"
   git push origin main
   ```

2. **Se connecter au VPS**:
   ```bash
   ssh debian@37.59.120.70
   ```

3. **Passer en mode root**:
   ```bash
   sudo su
   ```

4. **Aller dans le répertoire de l'application**:
   ```bash
   cd /var/www/erp-mtib
   ```

5. **Récupérer les dernières modifications**:
   ```bash
   git pull origin main
   ```

6. **Vérifier et corriger les permissions**:
   ```bash
   # Propriétaire www-data (utilisateur Apache)
   chown -R www-data:www-data /var/www/erp-mtib

   # Permissions des répertoires (755)
   find /var/www/erp-mtib -type d -exec chmod 755 {} \;

   # Permissions des fichiers (644)
   find /var/www/erp-mtib -type f -exec chmod 644 {} \;

   # Protéger le fichier de configuration (lecture seule)
   chmod 444 /var/www/erp-mtib/htdocs/conf/conf.php
   ```

7. **Redémarrer Apache** (si modifications de configuration):
   ```bash
   systemctl reload apache2
   ```

8. **Vérifier le déploiement**:
   - Ouvrir https://www.mtibat.com
   - Tester les fonctionnalités modifiées

---

## ⚡ Méthode 2: Script de déploiement Windows (Plus rapide)

### Utilisation du script `deploy-to-vps.bat`

1. **Double-cliquer sur le fichier**:
   ```
   custom/deploy-to-vps.bat
   ```

2. Le script va:
   - ✅ Pousser automatiquement vers GitHub
   - ✅ Ouvrir une connexion SSH vers le VPS
   - ℹ️ Vous afficher les commandes à exécuter sur le VPS

3. **Une fois connecté au VPS, exécuter**:
   ```bash
   sudo su
   cd /var/www/erp-mtib
   git pull origin main
   chown -R www-data:www-data /var/www/erp-mtib
   systemctl reload apache2
   ```

### Avantages
- ✅ Push automatique vers GitHub
- ✅ Connexion SSH automatique
- ✅ Commandes prêtes à copier-coller

---

## 🐧 Méthode 3: Script de déploiement Linux/Mac

### Utilisation du script `deploy-to-vps.sh`

1. **Rendre le script exécutable** (une seule fois):
   ```bash
   chmod +x custom/deploy-to-vps.sh
   ```

2. **Exécuter le script**:
   ```bash
   ./custom/deploy-to-vps.sh
   ```

3. Le script va automatiquement:
   - ✅ Pousser vers GitHub
   - ✅ Se connecter au VPS via SSH
   - ✅ Exécuter `git pull`
   - ✅ Corriger les permissions
   - ✅ Redémarrer Apache

### Prérequis
- Clé SSH configurée pour debian@37.59.120.70
- Accès sudo sur le VPS

---

## 🔐 Configuration SSH pour déploiement automatique

### Générer une clé SSH (si pas déjà fait)

**Sur Windows** (PowerShell):
```powershell
ssh-keygen -t ed25519 -C "hachem@eve-media.com"
```

**Sur Linux/Mac**:
```bash
ssh-keygen -t ed25519 -C "hachem@eve-media.com"
```

### Copier la clé publique sur le VPS

```bash
# Afficher la clé publique
cat ~/.ssh/id_ed25519.pub

# Se connecter au VPS
ssh debian@37.59.120.70

# Ajouter la clé dans authorized_keys
mkdir -p ~/.ssh
echo "VOTRE_CLE_PUBLIQUE" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Après cela, vous pourrez vous connecter sans mot de passe:
```bash
ssh debian@37.59.120.70
```

---

## 🤖 Méthode 4: GitHub Actions (Future implémentation)

### Avantages d'un pipeline CI/CD

- ✅ Déploiement automatique à chaque `git push`
- ✅ Tests automatiques avant déploiement
- ✅ Rollback facile en cas d'erreur
- ✅ Notifications de déploiement

### Configuration GitHub Actions (à venir)

Pour implémenter un pipeline GitHub Actions, il faudra:

1. **Créer un workflow** `.github/workflows/deploy.yml`
2. **Configurer les secrets GitHub**:
   - `VPS_HOST`: 37.59.120.70
   - `VPS_USER`: debian
   - `VPS_SSH_KEY`: Clé SSH privée
   - `VPS_PATH`: /var/www/erp-mtib

3. **Workflow exemple**:
```yaml
name: Deploy to VPS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to VPS
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /var/www/erp-mtib
            git pull origin main
            chown -R www-data:www-data /var/www/erp-mtib
            systemctl reload apache2
```

**📝 Note**: Cette configuration n'est pas encore implémentée. Voulez-vous que je la crée?

---

## 📊 Workflow de déploiement recommandé

### 1. Développement local
```bash
# Modifier le code
# Tester localement
git add .
git commit -m "feat: Nouvelle fonctionnalité X"
```

### 2. Push vers GitHub
```bash
git push origin main
```

### 3. Déploiement sur VPS

**Option A - Manuel**:
```bash
ssh debian@37.59.120.70
sudo su
cd /var/www/erp-mtib
git pull origin main
systemctl reload apache2
```

**Option B - Script Windows**:
```cmd
custom\deploy-to-vps.bat
```

**Option C - Script Linux/Mac**:
```bash
./custom/deploy-to-vps.sh
```

### 4. Vérification
- Ouvrir https://www.mtibat.com
- Tester les nouvelles fonctionnalités
- Vérifier les logs si nécessaire:
  ```bash
  tail -f /var/log/apache2/erp-mtib-error.log
  ```

---

## 🔍 Vérification après déploiement

### Commandes utiles sur le VPS

```bash
# Voir les derniers commits
cd /var/www/erp-mtib
git log --oneline -5

# Voir les différences avec GitHub
git fetch
git status

# Vérifier les permissions
ls -la htdocs/conf/conf.php
ls -la documents/

# Vérifier les logs Apache
tail -20 /var/log/apache2/erp-mtib-error.log

# Vérifier le statut Apache
systemctl status apache2

# Tester la syntaxe PHP
php -l htdocs/index.php
```

---

## 🐛 Dépannage

### Le `git pull` échoue

**Problème**: Modifications locales en conflit
```bash
# Voir les fichiers modifiés
git status

# Annuler les modifications locales (ATTENTION: perte de données)
git reset --hard HEAD

# Ou créer un backup avant
cp -r /var/www/erp-mtib /var/backups/erp-mtib-backup-$(date +%Y%m%d)
git reset --hard HEAD
git pull origin main
```

### Erreur de permissions après déploiement

```bash
# Réappliquer les permissions correctes
cd /var/www/erp-mtib
chown -R www-data:www-data .
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chmod 444 htdocs/conf/conf.php
```

### Apache ne redémarre pas

```bash
# Vérifier la syntaxe de configuration
apachectl configtest

# Voir les erreurs
systemctl status apache2
journalctl -xe

# Redémarrer en force
systemctl restart apache2
```

### Site inaccessible après déploiement

```bash
# Vérifier qu'Apache écoute
netstat -tlnp | grep :80
netstat -tlnp | grep :443

# Vérifier les logs
tail -50 /var/log/apache2/erp-mtib-error.log

# Vérifier le VirtualHost
apachectl -S | grep mtibat
```

---

## 📝 Checklist de déploiement

Avant chaque déploiement:

- [ ] Code testé localement
- [ ] Changements committés avec message clair
- [ ] Push vers GitHub réussi
- [ ] Backup de la base de données (si changements DB)
- [ ] Git pull sur VPS
- [ ] Permissions vérifiées
- [ ] Apache rechargé
- [ ] Site testé en production
- [ ] Logs vérifiés (pas d'erreurs)

---

## 🔗 Ressources

- **VPS OVH**: 37.59.120.70
- **Domaine**: https://www.mtibat.com
- **Dépôt GitHub**: https://github.com/HachemBakhouch/erp_MTIB
- **Documentation**: [custom/INSTALLATION_VPS_GUIDE.md](INSTALLATION_VPS_GUIDE.md)

---

## 📞 Support

**EVE-MEDIA**
- Email: contact@eve-media.com
- Développeur: Hachem Bakhouch (hachem@eve-media.com)

---

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**
