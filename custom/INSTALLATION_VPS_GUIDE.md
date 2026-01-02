# Guide d'Installation VPS OVH - ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

---

## 📋 Situation actuelle

✅ **Déjà fait** :
- Code cloné sur VPS : `/var/www/erp-mtib`
- Permissions configurées (www-data:www-data)
- PHP 8.4.16 installé
- Apache fonctionne
- Domaine mtibat.com pointe vers le VPS
- L'installateur Dolibarr est accessible sur www.mtibat.com

---

## 🚀 Étapes à suivre pour finaliser l'installation

### Étape 1 : Créer la configuration Apache VirtualHost

Sur le VPS, en tant que root :

```bash
# Créer le fichier VirtualHost
nano /etc/apache2/sites-available/erp-mtib.conf
```

Copier le contenu du fichier `custom/apache_vhost_mtibat.conf` (disponible dans ce dépôt).

```bash
# Activer le site
a2ensite erp-mtib.conf

# Activer les modules Apache nécessaires
a2enmod rewrite
a2enmod headers
a2enmod ssl

# Tester la configuration
apachectl configtest

# Recharger Apache
systemctl reload apache2
```

---

### Étape 2 : Créer la base de données MariaDB

```bash
# Se connecter à MariaDB
mysql -u root -p
```

Dans la console MySQL :

```sql
-- Créer la base de données
CREATE DATABASE erp_mtib CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Créer un utilisateur dédié
CREATE USER 'erp_mtib_user'@'localhost' IDENTIFIED BY 'MOT_DE_PASSE_SECURISE';

-- Donner tous les droits sur la base
GRANT ALL PRIVILEGES ON erp_mtib.* TO 'erp_mtib_user'@'localhost';

-- Appliquer les changements
FLUSH PRIVILEGES;

-- Vérifier
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User = 'erp_mtib_user';

-- Quitter
EXIT;
```

**⚠️ Important** : Remplacer `MOT_DE_PASSE_SECURISE` par un mot de passe fort.

**Générer un mot de passe sécurisé** :
```bash
openssl rand -base64 24
```

---

### Étape 3 : Créer le fichier de configuration conf.php

```bash
# Créer le fichier
touch /var/www/erp-mtib/htdocs/conf/conf.php

# Donner les permissions d'écriture temporairement (pour l'installateur)
chmod 666 /var/www/erp-mtib/htdocs/conf/conf.php
chown www-data:www-data /var/www/erp-mtib/htdocs/conf/conf.php
```

---

### Étape 4 : Créer le répertoire documents

```bash
# Créer le répertoire documents (hors de htdocs pour la sécurité)
mkdir -p /var/www/erp-mtib/documents

# Donner les permissions
chown -R www-data:www-data /var/www/erp-mtib/documents
chmod -R 755 /var/www/erp-mtib/documents
```

---

### Étape 5 : Vérifier les extensions PHP requises

```bash
# Vérifier que toutes les extensions sont installées
php -m | grep -E "mysql|mysqli|pdo_mysql|gd|curl|xml|zip|mbstring|intl|soap"
```

Si des extensions manquent, installer :

```bash
# Pour PHP 8.4 (Debian Trixie)
apt install -y \
    php8.4-mysql \
    php8.4-gd \
    php8.4-curl \
    php8.4-xml \
    php8.4-zip \
    php8.4-mbstring \
    php8.4-intl \
    php8.4-soap \
    php8.4-ldap \
    php8.4-imap

# Redémarrer Apache
systemctl restart apache2
```

---

### Étape 6 : Lancer l'installation web

1. **Ouvrir dans le navigateur** : `http://www.mtibat.com/install/`

2. **Étape 1 - Vérification** :
   - Vérifier que toutes les extensions PHP sont OK
   - Cliquer sur "Suivant"

3. **Étape 2 - Fichier de configuration** :
   - Le fichier `conf.php` doit être détecté comme inscriptible
   - Cliquer sur "Suivant"

4. **Étape 3 - Base de données** :
   - Type de base : **MySQL/MariaDB**
   - Serveur : `localhost`
   - Port : `3306` (laisser vide pour valeur par défaut)
   - Nom de la base : `erp_mtib`
   - Utilisateur : `erp_mtib_user`
   - Mot de passe : `[le mot de passe créé à l'étape 2]`
   - Cliquer sur "Suivant"

5. **Étape 4 - Compte administrateur** :
   - Login : `admin`
   - Mot de passe : `[choisir un mot de passe fort]`
   - Confirmer le mot de passe
   - Cliquer sur "Suivant"

6. **Étape 5 - Installation** :
   - L'installation va créer les tables
   - Appliquer le script SQL de configuration MTIB (voir étape suivante)

---

### Étape 7 : Appliquer la configuration MTIB

Après l'installation de base, appliquer les personnalisations MTIB :

```bash
# Appliquer le script de configuration MTIB
mysql -u erp_mtib_user -p erp_mtib < /var/www/erp-mtib/custom/mtib_config.sql
```

Contenu du script `mtib_config.sql` :
```sql
-- Configuration SQL pour ERP MTIB
-- Copyright (C) 2026 EVE-MEDIA - All rights reserved

DELETE FROM llx_const WHERE name = 'MAIN_APPLICATION_TITLE';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_APPLICATION_TITLE', 'ERP MTIB', 'chaine', 0, 0);

DELETE FROM llx_const WHERE name = 'MAIN_INFO_SOCIETE_NOM';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_INFO_SOCIETE_NOM', 'MTIB', 'chaine', 0, 0);

DELETE FROM llx_const WHERE name = 'MAIN_HIDE_POWERED_BY';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_HIDE_POWERED_BY', '1', 'yesno', 0, 0);

-- Configuration additionnelle
DELETE FROM llx_const WHERE name = 'MAIN_INFO_SOCIETE_MAIL';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_INFO_SOCIETE_MAIL', 'contact@mtibat.com', 'chaine', 0, 0);
```

---

### Étape 8 : Sécuriser l'installation

Après installation réussie :

```bash
# 1. Rendre conf.php en lecture seule
chmod 444 /var/www/erp-mtib/htdocs/conf/conf.php

# 2. SUPPRIMER le répertoire install (TRÈS IMPORTANT)
rm -rf /var/www/erp-mtib/htdocs/install

# 3. Créer le fichier install.lock
touch /var/www/erp-mtib/documents/install.lock
chown www-data:www-data /var/www/erp-mtib/documents/install.lock

# 4. Vérifier les permissions
ls -la /var/www/erp-mtib/htdocs/conf/conf.php
ls -la /var/www/erp-mtib/documents/install.lock
```

---

### Étape 9 : Installer le certificat SSL (Let's Encrypt)

```bash
# Installer certbot
apt install -y certbot python3-certbot-apache

# Obtenir le certificat SSL pour mtibat.com
certbot --apache -d mtibat.com -d www.mtibat.com

# Répondre aux questions :
# - Email : hachem@eve-media.com
# - Accepter les ToS : Yes
# - Redirection HTTPS : Yes (recommandé)

# Vérifier le renouvellement automatique
certbot renew --dry-run

# Le certificat sera automatiquement renouvelé par un cron job
```

---

### Étape 10 : Mettre à jour le VirtualHost Apache

Après installation SSL, décommenter la section HTTPS dans le fichier VirtualHost :

```bash
nano /etc/apache2/sites-available/erp-mtib.conf
```

Décommenter les lignes de redirection HTTPS dans la section `<VirtualHost *:80>` :
```apache
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

Recharger Apache :
```bash
systemctl reload apache2
```

---

### Étape 11 : Configuration PHP recommandée

Créer/éditer le fichier de configuration PHP :

```bash
nano /etc/php/8.4/apache2/conf.d/99-erp-mtib.ini
```

Contenu :
```ini
; Configuration PHP pour ERP MTIB
; Copyright (C) 2026 EVE-MEDIA

; Uploads
upload_max_filesize = 32M
post_max_size = 32M
max_file_uploads = 20

; Execution
max_execution_time = 300
max_input_time = 300
memory_limit = 256M

; Security
expose_php = Off
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = /var/log/php/erp-mtib-error.log

; Sessions
session.cookie_httponly = 1
session.cookie_secure = 1
session.use_strict_mode = 1

; Timezone
date.timezone = Europe/Paris
```

Créer le répertoire de logs :
```bash
mkdir -p /var/log/php
chown www-data:www-data /var/log/php
```

Redémarrer Apache :
```bash
systemctl restart apache2
```

---

### Étape 12 : Configurer les backups automatiques

```bash
# Créer le script de backup
nano /root/backup-erp-mtib.sh
```

Contenu du script :
```bash
#!/bin/bash
# Backup automatique ERP MTIB
# Copyright (C) 2026 EVE-MEDIA

BACKUP_DIR="/var/backups/erp-mtib"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="erp_mtib"
DB_USER="erp_mtib_user"
DB_PASS="MOT_DE_PASSE_BDD"

# Créer le répertoire de backup
mkdir -p $BACKUP_DIR

# Backup de la base de données
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/db_$DATE.sql.gz

# Backup des fichiers (documents, conf)
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/erp-mtib/documents /var/www/erp-mtib/htdocs/conf

# Supprimer les backups de plus de 30 jours
find $BACKUP_DIR -name "*.gz" -mtime +30 -delete

echo "Backup ERP MTIB terminé : $DATE"
```

Rendre exécutable et configurer le cron :
```bash
chmod +x /root/backup-erp-mtib.sh

# Ajouter au crontab (backup quotidien à 2h du matin)
crontab -e

# Ajouter cette ligne :
0 2 * * * /root/backup-erp-mtib.sh >> /var/log/erp-mtib-backup.log 2>&1
```

---

## ✅ Checklist finale

- [ ] VirtualHost Apache configuré et activé
- [ ] Base de données `erp_mtib` créée
- [ ] Utilisateur MySQL `erp_mtib_user` créé
- [ ] Fichier `conf.php` créé avec bonnes permissions
- [ ] Répertoire `documents/` créé
- [ ] Extensions PHP installées et vérifiées
- [ ] Installation web complétée via navigateur
- [ ] Script `mtib_config.sql` appliqué
- [ ] Fichier `conf.php` mis en lecture seule (444)
- [ ] Répertoire `install/` supprimé
- [ ] Fichier `install.lock` créé
- [ ] Certificat SSL Let's Encrypt installé
- [ ] Redirection HTTPS activée
- [ ] Configuration PHP personnalisée
- [ ] Script de backup configuré
- [ ] Test de connexion à l'ERP réussi

---

## 🔐 Informations de connexion

**URL de production** : https://www.mtibat.com

**Compte administrateur** :
- Login : `admin`
- Mot de passe : `[défini lors de l'installation]`

**Base de données** :
- Nom : `erp_mtib`
- Utilisateur : `erp_mtib_user`
- Mot de passe : `[défini lors de la création]`

---

## 🐛 Dépannage

### L'installateur ne s'affiche pas
```bash
# Vérifier les permissions
ls -la /var/www/erp-mtib/htdocs/

# Vérifier les logs Apache
tail -f /var/log/apache2/erp-mtib-error.log
```

### Erreur de connexion à la base de données
```bash
# Tester la connexion
mysql -u erp_mtib_user -p erp_mtib

# Vérifier les droits
mysql -u root -p -e "SHOW GRANTS FOR 'erp_mtib_user'@'localhost';"
```

### Erreur "conf.php not writable"
```bash
# Donner temporairement les permissions
chmod 666 /var/www/erp-mtib/htdocs/conf/conf.php
```

### Page blanche après installation
```bash
# Vérifier les logs PHP
tail -f /var/log/php/erp-mtib-error.log

# Vérifier la configuration PHP
php -i | grep -E "memory_limit|max_execution"
```

---

## 📞 Support

**EVE-MEDIA**
- Email : contact@eve-media.com
- Développeur : Hachem Bakhouch (hachem@eve-media.com)

---

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**
