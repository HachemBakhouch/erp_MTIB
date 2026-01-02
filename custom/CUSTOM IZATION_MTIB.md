# Customisation Dolibarr pour MTIB - EVE-MEDIA

**Copyright (C) 2026 EVE-MEDIA - Tous droits réservés**

Ce document liste toutes les modifications apportées au code source de Dolibarr pour le client **MTIB**.

## 📋 Résumé des modifications

- **Nom de l'application** : ERP MTIB
- **Nom du client** : MTIB
- **Copyright** : EVE-MEDIA 2026
- **Date de customisation** : Janvier 2026

---

## 🔧 Fichiers modifiés

### 1. Templates - Interface utilisateur

#### `htdocs/core/tpl/login.tpl.php`
**Modifications** :
- ✅ Suppression du lien hypertexte vers dolibarr.org (ligne 272)
- ✅ Remplacement du copyright par "Copyright (C) 2026 EVE-MEDIA"
- ✅ Ajout d'une notice propriétaire

**Avant** :
```php
/* Copyright (C) 2009-2025 Multiple authors... */
```

**Après** :
```php
/* Copyright (C) 2026 EVE-MEDIA - All rights reserved
 * This software is proprietary and confidential.
 */
```

---

### 2. Fichiers de langue

#### `htdocs/langs/fr_FR/main.lang`
**Modifications** :
- ✅ Ligne 1 : "# ERP MTIB language file" au lieu de "# Dolibarr language file"
- ✅ Suppression des mentions "Dolibarr" dans les messages d'erreur
- ✅ Remplacement par "Le système" ou "L'application"
- ✅ Suppression du lien vers Transifex (ligne 978)

**Exemples de modifications** :
| Ligne | Avant | Après |
|-------|-------|-------|
| 73 | `...Dolibarr <b>conf.php</b>` | `...configuration <b>conf.php</b>` |
| 74 | `...base Dolibarr` | `...base de données` |
| 128 | `Dolibarr a détecté une erreur` | `Le système a détecté une erreur` |
| 137 | `Dolibarr a été configuré` | `Le système a été configuré` |
| 787-788 | `Limite Dolibarr` | `Limite système` |

---

### 3. Manifeste PWA

#### `htdocs/theme/eldy/manifest.json.php`
**Modifications** :
- ✅ Remplacement du copyright par "Copyright (C) 2026 EVE-MEDIA"
- ✅ Ajout notice propriétaire

---

### 4. Configuration SQL

#### `custom/mtib_config.sql`
**Nouveau fichier créé** :
```sql
-- Configure les constantes suivantes :
MAIN_APPLICATION_TITLE = 'ERP MTIB'
MAIN_INFO_SOCIETE_NOM = 'MTIB'
MAIN_HIDE_POWERED_BY = '1'
MAIN_INFO_SOCIETE_NOTE = 'Copyright (C) 2026 EVE-MEDIA'
MAIN_THEME = 'eldy'
```

**Utilisation** :
```bash
mysql -u root -p nom_base < custom/mtib_config.sql
```

---

## 🚀 Installation et déploiement

### Prérequis
- Serveur VPS OVH
- PHP 7.4+ / 8.x
- MySQL 5.7+ / MariaDB 10.3+
- Apache ou Nginx

### Étapes d'installation

#### 1. **Cloner le repository**
```bash
git clone https://github.com/votre-compte/dolibarr-mtib.git
cd dolibarr-mtib
```

#### 2. **Configuration de la base de données**
```bash
# Créer la base de données
mysql -u root -p -e "CREATE DATABASE erp_mtib CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Créer l'utilisateur
mysql -u root -p -e "CREATE USER 'mtib_user'@'localhost' IDENTIFIED BY 'MOT_DE_PASSE_SECURISE';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON erp_mtib.* TO 'mtib_user'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
```

#### 3. **Installation de Dolibarr**
- Accéder à : `http://votre-domaine.com/install/`
- Suivre l'assistant d'installation
- Utiliser les informations de connexion BDD créées à l'étape 2

#### 4. **Appliquer la configuration MTIB**
```bash
mysql -u mtib_user -p erp_mtib < custom/mtib_config.sql
```

#### 5. **Remplacer les logos** (à faire)
```bash
# Uploader le logo EVE-MEDIA dans :
# htdocs/theme/dolibarr_logo.png
# htdocs/theme/dolibarr_logo.svg
# documents/mycompany/logos/
```

#### 6. **Permissions fichiers**
```bash
chown -R www-data:www-data /var/www/dolibarr-mtib
chmod -R 755 /var/www/dolibarr-mtib
chmod -R 775 /var/www/dolibarr-mtib/documents
```

---

## 📦 Structure du projet

```
dolibarr-mtib/
├── htdocs/
│   ├── core/
│   │   └── tpl/
│   │       └── login.tpl.php          ✏️ MODIFIÉ
│   ├── langs/
│   │   ├── fr_FR/
│   │   │   └── main.lang             ✏️ MODIFIÉ
│   │   └── en_US/
│   │       └── main.lang             ⏳ À MODIFIER
│   ├── theme/
│   │   ├── eldy/
│   │   │   └── manifest.json.php     ✏️ MODIFIÉ
│   │   ├── md/
│   │   │   └── manifest.json.php     ⏳ À MODIFIER
│   │   ├── dolibarr_logo.png         ⏳ À REMPLACER
│   │   └── dolibarr_logo.svg         ⏳ À REMPLACER
│   └── custom/
│       ├── mtib_config.sql           ✅ NOUVEAU
│       └── CUSTOMIZATION_MTIB.md     ✅ CE FICHIER
└── documents/
    └── mycompany/
        └── logos/                     ⏳ À AJOUTER
```

---

## 🎨 Changements UI restants

### Logos à remplacer
- [ ] `htdocs/theme/dolibarr_logo.png`
- [ ] `htdocs/theme/dolibarr_logo.svg`
- [ ] `htdocs/theme/dolibarr_logo.jpg`
- [ ] `htdocs/favicon.ico`
- [ ] Logo dans `documents/mycompany/logos/`

### Fichiers de langue à modifier
- [x] `htdocs/langs/fr_FR/main.lang`
- [ ] `htdocs/langs/en_US/main.lang`
- [ ] Autres fichiers .lang si nécessaire

### Autres thèmes
- [x] `htdocs/theme/eldy/manifest.json.php`
- [ ] `htdocs/theme/md/manifest.json.php`

---

## 🔐 Sécurité

⚠️ **IMPORTANT** : Ce code est propriétaire EVE-MEDIA.

- Ne **PAS** publier sur un repository public
- Utiliser un repository **privé** sur GitHub
- Ajouter les collaborateurs autorisés uniquement
- Protéger la branche `main` / `develop`

### Fichier `.gitignore` recommandé
```gitignore
# Configuration
htdocs/conf/conf.php
htdocs/custom/*/conf.php

# Documents et données
documents/
# Logs
*.log

# Cache
htdocs/core/tpl/cache/

# Environnement local
.env
.env.local
```

---

## 🚢 Déploiement GitHub Actions

### Workflow recommandé : `.github/workflows/deploy-ovh.yml`

```yaml
name: Deploy to OVH VPS

on:
  push:
    branches: [ main, develop ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Deploy to OVH via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.OVH_HOST }}
          username: ${{ secrets.OVH_USERNAME }}
          key: ${{ secrets.OVH_SSH_KEY }}
          script: |
            cd /var/www/erp-mtib
            git pull origin main
            chmod -R 775 documents/
            systemctl reload apache2
```

### Secrets GitHub à configurer
- `OVH_HOST` : IP ou domaine du serveur
- `OVH_USERNAME` : utilisateur SSH
- `OVH_SSH_KEY` : clé privée SSH

---

## 📝 Notes importantes

1. **Base de données** : La configuration se fait principalement via SQL (`mtib_config.sql`)
2. **Mises à jour Dolibarr** : Attention lors des mises à jour, les fichiers modifiés peuvent être écrasés
3. **Custom directory** : Privilégier `htdocs/custom/` pour les modules personnalisés
4. **Backup** : Toujours sauvegarder avant de déployer en production

---

## 📞 Support

**Développeur** : EVE-MEDIA
**Client** : MTIB
**Date** : Janvier 2026
**Version Dolibarr** : 23.0+

---

## ✅ Checklist de déploiement

- [x] Modification login.tpl.php
- [x] Modification main.lang (fr_FR)
- [x] Modification manifest.json.php (eldy)
- [x] Création mtib_config.sql
- [ ] Modification main.lang (en_US)
- [ ] Modification manifest.json.php (md)
- [ ] Remplacement des logos
- [ ] Test en local
- [ ] Création repo GitHub privé
- [ ] Configuration GitHub Actions
- [ ] Déploiement sur VPS OVH
- [ ] Test en production
- [ ] Formation client

---

**FIN DU DOCUMENT**
