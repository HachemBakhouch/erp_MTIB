# ERP MTIB

![Minimum PHP Version](https://img.shields.io/badge/php-%3E%3D%208.1-8892BF.svg?style=flat-square)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)
![Copyright](https://img.shields.io/badge/copyright-EVE--MEDIA%202026-blue.svg)

**ERP MTIB** est une solution de gestion d'entreprise complète développée par **EVE-MEDIA** pour le client **MTIB**.

Cette solution permet de gérer l'ensemble des activités de votre organisation : contacts, devis, factures, commandes, stocks, agenda, ressources humaines, gestion documentaire, fabrication, et bien plus encore.

---

## 📋 À propos

**ERP MTIB** est un logiciel propriétaire développé en PHP avec des améliorations JavaScript, conçu pour répondre aux besoins spécifiques de MTIB.

- **Développeur** : EVE-MEDIA
- **Client** : MTIB
- **Année** : 2026
- **Stack technique** : PHP 8.1/8.2, MariaDB 10.5+, Apache 2.4

---

## 🔒 LICENSE

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

Ce logiciel est propriétaire et confidentiel. Toute copie, distribution ou modification non autorisée est strictement interdite.

Voir le fichier [LICENSE.txt](LICENSE.txt) pour plus de détails.

---

## 📦 INSTALLATION

### Prérequis système

- **PHP** : 8.1 ou 8.2 (recommandé)
- **Base de données** : MariaDB 10.5+ ou MySQL 5.7+
- **Serveur web** : Apache 2.4 avec mod_rewrite
- **Extensions PHP requises** :
  - mysql, gd, curl, xml, zip, mbstring, intl, soap, ldap, imap

### Installation sur VPS OVH

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/HachemBakhouch/erp_MTIB.git
   cd erp_MTIB
   ```

2. **Configurer le serveur web** :
   - Pointer le DocumentRoot vers `htdocs/`
   - Activer mod_rewrite

3. **Créer le fichier de configuration** :
   ```bash
   touch htdocs/conf/conf.php
   chmod 666 htdocs/conf/conf.php
   ```

4. **Lancer l'installateur** :
   - Ouvrir dans le navigateur : `http://votre-domaine/install/`
   - Suivre les étapes de l'assistant d'installation

5. **Configuration de la base de données** :
   ```bash
   mysql -u root -p < custom/mtib_config.sql
   ```

6. **Sécuriser l'installation** :
   ```bash
   chmod 444 htdocs/conf/conf.php
   rm -rf htdocs/install/
   ```

### Installation locale (développement)

Pour le développement local, vous pouvez utiliser :
- **XAMPP** (Windows/Linux/macOS)
- **Docker** avec PHP 8.2 + MariaDB
- **WAMP** (Windows)

Voir la documentation complète dans [custom/CUSTOMIZATION_MTIB.md](custom/CUSTOMIZATION_MTIB.md).

---

## 🚀 DÉPLOIEMENT

### GitHub Actions (CI/CD)

Le projet utilise GitHub Actions pour le déploiement automatique vers le VPS OVH.

Voir [custom/README_GITHUB.md](custom/README_GITHUB.md) pour configurer le pipeline de déploiement.

### Déploiement manuel

```bash
# Sur le VPS OVH
cd /var/www/html/erp_mtib
git pull origin main
sudo systemctl restart apache2
```

---

## 🔧 CONFIGURATION

### Paramètres de l'application

Les paramètres suivants ont été préconfigurés :

- **Application Title** : ERP MTIB
- **Company Name** : MTIB
- **Copyright** : EVE-MEDIA 2026

### Personnalisations MTIB

Toutes les personnalisations EVE-MEDIA sont documentées dans :
- [custom/CUSTOMIZATION_MTIB.md](custom/CUSTOMIZATION_MTIB.md) - Guide complet des modifications
- [custom/CHANGEMENTS_EFFECTUES.md](custom/CHANGEMENTS_EFFECTUES.md) - Liste détaillée des changements
- [custom/INFO_TECHNIQUE.md](custom/INFO_TECHNIQUE.md) - Stack technique et prérequis

---

## ✨ FONCTIONNALITÉS

### Modules principaux

#### Gestion Commerciale
- Gestion des clients, prospects et contacts
- Devis et propositions commerciales
- Commandes clients
- Facturation et paiements
- Point de vente (POS)

#### Gestion des Achats
- Gestion des fournisseurs
- Commandes fournisseurs
- Réception et livraison
- Factures fournisseurs

#### Gestion des Stocks
- Catalogue produits et services
- Gestion des stocks multi-entrepôts
- Codes-barres
- Inventaires
- Lots et numéros de série

#### Finance et Comptabilité
- Comptes bancaires
- Prélèvements et virements SEPA
- Comptabilité analytique
- Rapports financiers
- Marges

#### Gestion de Projets
- Projets et tâches
- Planning et agenda partagé
- Feuilles de temps
- Système de tickets

#### Ressources Humaines
- Gestion des employés
- Congés et absences
- Notes de frais
- Recrutement

#### Production
- Nomenclatures (BOM)
- Ordres de fabrication
- Postes de travail

### Autres fonctionnalités

- Gestion documentaire (EDM)
- Multi-utilisateurs avec gestion fine des droits
- Multi-devises
- Multi-langues
- Tableaux de bord personnalisables
- API REST
- Export/Import de données
- Génération de PDF personnalisés

---

## 📚 DOCUMENTATION

### Documentation technique

- [INFO_TECHNIQUE.md](custom/INFO_TECHNIQUE.md) - Stack technique et prérequis
- [VERSION_PHP_CLARIFICATION.md](custom/VERSION_PHP_CLARIFICATION.md) - Informations sur les versions PHP
- [CUSTOMIZATION_MTIB.md](custom/CUSTOMIZATION_MTIB.md) - Guide de personnalisation
- [README_GITHUB.md](custom/README_GITHUB.md) - Configuration GitHub et déploiement

### Documentation utilisateur

La documentation utilisateur sera fournie séparément pour les utilisateurs finaux de MTIB.

---

## 🔐 SÉCURITÉ

Pour signaler une vulnérabilité de sécurité, veuillez contacter :

**EVE-MEDIA**
- Email : security@eve-media.com
- Contact : hachem@eve-media.com

Voir [SECURITY.md](SECURITY.md) pour la politique complète de sécurité.

---

## 🛠️ DÉVELOPPEMENT

### Prérequis développeur

- PHP 8.1 ou 8.2
- Composer
- Git
- IDE recommandé : VS Code, PhpStorm

### Installation environnement de développement

```bash
# Cloner le projet
git clone https://github.com/HachemBakhouch/erp_MTIB.git
cd erp_MTIB

# Installer pre-commit hooks (optionnel)
pip install pre-commit
pre-commit install

# Configurer la base de données locale
mysql -u root -p -e "CREATE DATABASE erp_mtib CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p erp_mtib < custom/mtib_config.sql
```

### Standards de code

- **PHP** : PSR-12
- **Encodage** : UTF-8
- **Line endings** : LF (Unix)
- **Indentation** : Tabs

### Tests

```bash
# Vérification syntaxe PHP
find htdocs -name "*.php" -exec php -l {} \;

# PHPStan (analyse statique)
vendor/bin/phpstan analyse
```

---

## 🤝 CONTRIBUTION

Ce projet est **propriétaire** et développé exclusivement par **EVE-MEDIA** pour **MTIB**.

Les contributions sont limitées aux membres autorisés de l'équipe EVE-MEDIA.

Voir [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md) pour les directives de contribution.

---

## 👥 ÉQUIPE

**EVE-MEDIA**
- **Lead Developer** : Hachem Bakhouch
- **Client** : MTIB
- **Contact** : contact@eve-media.com

### Code Ownership

Voir [.github/CODEOWNERS](.github/CODEOWNERS) pour la gestion des responsabilités.

---

## 📞 SUPPORT

Pour toute question ou assistance :

**EVE-MEDIA**
- Email : contact@eve-media.com
- Téléphone : [Numéro à compléter]
- Site web : [URL à compléter]

---

## 📝 CHANGELOG

Voir les commits Git pour l'historique complet des modifications :

```bash
git log --oneline --graph --all
```

---

## 🏗️ ARCHITECTURE

```
erp_MTIB/
├── htdocs/              # Code source principal
│   ├── core/            # Bibliothèques core
│   ├── langs/           # Fichiers de traduction
│   ├── theme/           # Thèmes visuels
│   ├── conf/            # Configuration
│   └── custom/          # Personnalisations MTIB
├── custom/              # Documentation et scripts personnalisés
├── .github/             # Configuration GitHub
└── LICENSE.txt          # Licence propriétaire
```

---

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

*Développé avec expertise par EVE-MEDIA pour MTIB*
