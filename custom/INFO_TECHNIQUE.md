# 📊 Informations Techniques - ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

---

## 🔧 Stack Technique

### Version PHP

**Minimum requis** : **PHP 7.2+**
**Recommandé pour MTIB** : **PHP 8.1** ou **PHP 8.2**

D'après l'analyse du code source de Dolibarr :
- Badge GitHub (README.md) : `php >= 7.2` (minimum supporté)
- Fichier `phpstan.neon.dist` : `phpVersion: 80200` (PHP 8.2)
- Code source vérifie : `PHP_VERSION_ID < 70300` dans certains fichiers
- **Compatible** : PHP 7.2, 7.3, 7.4, 8.0, 8.1, 8.2

**Recommandation pour production MTIB** :
- ✅ **PHP 8.1** ou **PHP 8.2** (meilleures performances, sécurité, et support à long terme)
- ⚠️ Éviter PHP 7.x qui est en fin de vie (plus de support de sécurité)

---

### Base de données

**Supportées** :
- ✅ **MySQL 5.7+** (recommandé)
- ✅ **MariaDB 10.3+** (recommandé pour OVH)
- ✅ PostgreSQL 9.6+

**Recommandation pour VPS OVH** : MariaDB 10.5 ou 10.6

---

### Serveur Web

**Supportés** :
- ✅ Apache 2.4+ (avec mod_rewrite)
- ✅ Nginx 1.18+
- ✅ Lighttpd

**Recommandation pour VPS OVH** : Apache 2.4 avec PHP-FPM

---

## 📦 Version Dolibarr

**Version actuelle du code** : **23.0** (branche develop)

D'après les fichiers analysés :
- Git log montre : `3a09c7cfd9c Merge branch '23.0'`
- Code en développement actif (derniers commits 2025)

---

## 🗃️ Structure de la base de données

**Préfixe des tables** : `llx_`

**Tables principales modifiées par notre config** :
```sql
llx_const  -- Table des constantes de configuration
```

**Constantes ajoutées/modifiées** :
| Constante | Valeur | Description |
|-----------|--------|-------------|
| `MAIN_APPLICATION_TITLE` | `ERP MTIB` | Titre de l'application |
| `MAIN_INFO_SOCIETE_NOM` | `MTIB` | Nom de la société |
| `MAIN_HIDE_POWERED_BY` | `1` | Masquer "Powered by" |
| `MAIN_INFO_SOCIETE_NOTE` | `Copyright © 2026 EVE-MEDIA` | Note copyright |
| `MAIN_THEME` | `eldy` | Thème par défaut |

---

## 📁 Arborescence importante

```
dolibarr/
├── htdocs/                      # Racine web
│   ├── conf/
│   │   └── conf.php            # ⚙️ Configuration principale (à créer)
│   ├── core/
│   │   └── tpl/
│   │       └── login.tpl.php   # ✏️ MODIFIÉ (page de connexion)
│   ├── langs/
│   │   └── fr_FR/
│   │       └── main.lang       # ✏️ MODIFIÉ (traductions FR)
│   ├── theme/
│   │   ├── eldy/
│   │   │   └── manifest.json.php  # ✏️ MODIFIÉ
│   │   └── md/
│   │       └── manifest.json.php  # ✏️ MODIFIÉ
│   └── custom/                 # 📂 Modules personnalisés
│       ├── mtib_config.sql     # ✨ NOUVEAU
│       ├── CUSTOMIZATION_MTIB.md
│       └── INFO_TECHNIQUE.md   # 📄 Ce fichier
├── documents/                   # 📂 Documents générés (non versionné)
└── LICENSE.txt                 # ✨ NOUVEAU (copyright EVE-MEDIA)
```

---

## 🔐 Configuration Apache (VPS OVH)

### VirtualHost recommandé

```apache
<VirtualHost *:80>
    ServerName erp-mtib.votre-domaine.com
    ServerAdmin admin@eve-media.com

    DocumentRoot /var/www/erp-mtib/htdocs

    <Directory /var/www/erp-mtib/htdocs>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted

        # Sécurité PHP
        php_flag display_errors off
        php_flag log_errors on
        php_value memory_limit 256M
        php_value upload_max_filesize 50M
        php_value post_max_size 50M
        php_value max_execution_time 300
    </Directory>

    # Bloquer l'accès aux fichiers sensibles
    <FilesMatch "^\.">
        Require all denied
    </FilesMatch>

    <Directory /var/www/erp-mtib/htdocs/conf>
        Require all denied
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/erp-mtib-error.log
    CustomLog ${APACHE_LOG_DIR}/erp-mtib-access.log combined
</VirtualHost>

# SSL (après avoir installé Let's Encrypt)
<VirtualHost *:443>
    ServerName erp-mtib.votre-domaine.com

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/erp-mtib.votre-domaine.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/erp-mtib.votre-domaine.com/privkey.pem

    # ... (même config que port 80)
</VirtualHost>
```

---

## 🐘 Configuration PHP recommandée

**Fichier** : `/etc/php/8.2/apache2/php.ini` (ou `/etc/php/8.1/apache2/php.ini` selon version installée)

```ini
; Sécurité
expose_php = Off
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = /var/log/php/error.log

; Performance
memory_limit = 256M
max_execution_time = 300
max_input_time = 300

; Upload
upload_max_filesize = 50M
post_max_size = 50M

; Sessions
session.cookie_httponly = 1
session.cookie_secure = 1
session.use_strict_mode = 1

; Timezone
date.timezone = Europe/Paris

; Extensions requises (vérifier qu'elles sont activées)
; extension=mysqli
; extension=gd
; extension=curl
; extension=zip
; extension=intl
; extension=mbstring
; extension=xml
```

---

## 🗄️ Configuration MariaDB recommandée

**Fichier** : `/etc/mysql/mariadb.conf.d/50-server.cnf`

```ini
[mysqld]
# Charset UTF8
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# Performance pour petit VPS (2GB RAM)
innodb_buffer_pool_size = 512M
innodb_log_file_size = 128M
max_connections = 50
query_cache_size = 32M
query_cache_limit = 2M

# Sécurité
sql_mode = STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION
bind-address = 127.0.0.1
```

---

## 🔒 Permissions fichiers recommandées

```bash
# Propriétaire
sudo chown -R www-data:www-data /var/www/erp-mtib

# Permissions de base
sudo find /var/www/erp-mtib -type d -exec chmod 755 {} \;
sudo find /var/www/erp-mtib -type f -exec chmod 644 {} \;

# Permissions spéciales
sudo chmod 775 /var/www/erp-mtib/htdocs/conf
sudo chmod 775 /var/www/erp-mtib/documents
sudo chmod 664 /var/www/erp-mtib/htdocs/conf/conf.php
```

---

## 📊 Ressources VPS OVH recommandées

### Configuration minimale
- **CPU** : 1 vCore
- **RAM** : 2 GB
- **Disque** : 20 GB SSD
- **Bande passante** : Illimitée

### Configuration recommandée
- **CPU** : 2 vCores
- **RAM** : 4 GB
- **Disque** : 40 GB SSD
- **Bande passante** : Illimitée

### Estimation d'utilisation
- **Base de données** : 100-500 MB (petite entreprise)
- **Documents** : 1-10 GB (selon volume)
- **Code source** : ~500 MB

---

## 🚀 Optimisations performance

### 1. Activer OPcache PHP

```ini
; php.ini
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=60
```

### 2. Activer la compression Apache

```apache
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>
```

### 3. Cache navigateur

```apache
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

---

## 🔧 Dépendances PHP requises

Installer sur VPS OVH (recommandation : **PHP 8.1** ou **PHP 8.2**) :

### Pour PHP 8.2 (recommandé)
```bash
sudo apt update
sudo apt install -y \
    php8.2 \
    php8.2-mysql \
    php8.2-gd \
    php8.2-curl \
    php8.2-xml \
    php8.2-zip \
    php8.2-mbstring \
    php8.2-intl \
    php8.2-soap \
    php8.2-ldap \
    php8.2-imap \
    php8.2-cli \
    php8.2-fpm
```

### Pour PHP 8.1 (également recommandé)
```bash
sudo apt update
sudo apt install -y \
    php8.1 \
    php8.1-mysql \
    php8.1-gd \
    php8.1-curl \
    php8.1-xml \
    php8.1-zip \
    php8.1-mbstring \
    php8.1-intl \
    php8.1-soap \
    php8.1-ldap \
    php8.1-imap \
    php8.1-cli \
    php8.1-fpm
```

---

## 📝 Checklist d'installation VPS

- [ ] Apache 2.4 installé et configuré
- [ ] PHP 8.0+ installé avec extensions
- [ ] MariaDB 10.5+ installé et sécurisé
- [ ] Base de données `erp_mtib` créée
- [ ] Utilisateur MySQL dédié créé
- [ ] Code source déployé dans `/var/www/erp-mtib`
- [ ] Permissions fichiers correctes (775/755/644)
- [ ] VirtualHost Apache configuré
- [ ] SSL/HTTPS activé (Let's Encrypt)
- [ ] Firewall configuré (ports 80, 443, 22)
- [ ] Script SQL `mtib_config.sql` exécuté
- [ ] Test de connexion réussi
- [ ] Backups automatiques configurés

---

## 🔍 Commandes de diagnostic

### Vérifier PHP
```bash
# Version PHP installée
php -v

# Vérifier que c'est bien PHP 8.1 ou 8.2
php -v | grep "PHP 8"

# Extensions PHP installées
php -m | grep -E "mysql|gd|curl|zip|mbstring|intl|soap"
```

### Vérifier MariaDB
```bash
mysql --version
sudo systemctl status mariadb
```

### Vérifier Apache
```bash
apache2 -v
sudo apache2ctl configtest
sudo systemctl status apache2
```

### Tester la base de données
```bash
mysql -u mtib_user -p erp_mtib -e "SHOW TABLES;"
```

---

**Document créé le** : 2 janvier 2026
**Développeur** : EVE-MEDIA
**Client** : MTIB
**Version Dolibarr** : 23.0
