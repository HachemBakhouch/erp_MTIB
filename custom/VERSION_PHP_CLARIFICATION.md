# 🐘 Clarification Version PHP - ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

---

## ❓ Question posée

> Tu me dis que la version du php est 7.2 alors que dans le fichier phpstan.neon.dist je trouve ceci: `phpVersion: 80200 # PHP 8.2`

---

## ✅ Réponse : Les deux informations sont correctes !

Voici pourquoi :

### 📌 PHP 7.2 = **Version MINIMALE** supportée

**Source** : `README.md`
```
[![Minimum PHP Version](https://img.shields.io/badge/php-%3E%3D%207.2-8892BF.svg?style=flat-square)]
```

Cela signifie que Dolibarr **peut fonctionner** à partir de PHP 7.2, mais ce n'est pas la version recommandée.

---

### 📌 PHP 8.2 = **Version TESTÉE** par PHPStan

**Source** : `phpstan.neon.dist`
```yaml
parameters:
    phpVersion: 80200 # PHP 8.2
```

Cela signifie que le code Dolibarr est **analysé et validé** pour fonctionner avec PHP 8.2 par l'outil d'analyse statique **PHPStan**.

---

## 🎯 Conclusion : Quelle version utiliser pour MTIB ?

### ✅ **Recommandation officielle EVE-MEDIA pour production**

| Version PHP | Support | Performances | Sécurité | Recommandation |
|-------------|---------|--------------|----------|----------------|
| PHP 7.2 | ⚠️ Fin de vie (EOL depuis 30 nov 2020) | ⭐⭐ | ❌ Plus de mises à jour de sécurité | ❌ **À ÉVITER** |
| PHP 7.3 | ⚠️ Fin de vie (EOL depuis 6 déc 2021) | ⭐⭐ | ❌ Plus de mises à jour de sécurité | ❌ **À ÉVITER** |
| PHP 7.4 | ⚠️ Fin de vie (EOL depuis 28 nov 2022) | ⭐⭐⭐ | ❌ Plus de mises à jour de sécurité | ❌ **À ÉVITER** |
| PHP 8.0 | ⚠️ Fin de vie (EOL depuis 26 nov 2023) | ⭐⭐⭐⭐ | ❌ Plus de mises à jour de sécurité | ⚠️ **Non recommandé** |
| **PHP 8.1** | ✅ Support actif jusqu'au 25 nov 2024, puis sécurité jusqu'au 25 nov 2025 | ⭐⭐⭐⭐⭐ | ✅ Mises à jour de sécurité actives | ✅ **RECOMMANDÉ** |
| **PHP 8.2** | ✅ Support actif jusqu'au 8 déc 2025, puis sécurité jusqu'au 8 déc 2026 | ⭐⭐⭐⭐⭐ | ✅ Mises à jour de sécurité actives | ✅ **TRÈS RECOMMANDÉ** |
| PHP 8.3 | ✅ Version la plus récente (nov 2023) | ⭐⭐⭐⭐⭐ | ✅ Support à long terme | ⚠️ **Tester avant** |

**Sources** : [PHP Supported Versions](https://www.php.net/supported-versions.php)

---

## 🚀 Installation recommandée pour VPS OVH

### Option 1 : PHP 8.2 (RECOMMANDÉ) ⭐

```bash
# Sur Ubuntu 22.04 / Debian 12
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# Installer PHP 8.2 et extensions
sudo apt install -y \
    php8.2 \
    php8.2-fpm \
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
    php8.2-cli

# Vérifier l'installation
php -v
# Devrait afficher : PHP 8.2.x
```

### Option 2 : PHP 8.1 (AUSSI RECOMMANDÉ)

```bash
# Sur Ubuntu 20.04 / Debian 11
sudo apt update
sudo apt install -y \
    php8.1 \
    php8.1-fpm \
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
    php8.1-cli

# Vérifier l'installation
php -v
# Devrait afficher : PHP 8.1.x
```

---

## 📊 Tableau de compatibilité Dolibarr 23.0

| Version PHP | Dolibarr 23.0 | Statut | Pour production |
|-------------|---------------|--------|-----------------|
| PHP 5.x | ❌ Non supporté | Obsolète | ❌ Non |
| PHP 7.0 | ❌ Non supporté | EOL | ❌ Non |
| PHP 7.1 | ❌ Non supporté | EOL | ❌ Non |
| PHP 7.2 | ✅ Minimum requis | EOL | ❌ Non |
| PHP 7.3 | ✅ Compatible | EOL | ❌ Non |
| PHP 7.4 | ✅ Compatible | EOL | ❌ Non |
| PHP 8.0 | ✅ Compatible | EOL | ⚠️ Non recommandé |
| **PHP 8.1** | ✅ Compatible testé | Support actif | ✅ **OUI** |
| **PHP 8.2** | ✅ Compatible testé (PHPStan) | Support actif | ✅ **OUI** ⭐ |
| PHP 8.3 | ⚠️ À tester | Support actif | ⚠️ Après tests |

---

## 🔧 Pourquoi éviter PHP 7.x en production ?

### Problèmes de sécurité
- ❌ **Plus de correctifs de sécurité** depuis 2022
- ❌ Vulnérabilités non corrigées (CVE)
- ❌ Non conforme aux standards de sécurité modernes

### Performances
- 📉 **40-50% plus lent** que PHP 8.x
- 📉 Consommation mémoire plus élevée
- 📉 Pas d'optimisations JIT (Just-In-Time)

### Support
- ⚠️ Bibliothèques tierces abandonnent PHP 7.x
- ⚠️ Difficultés de maintenance à long terme
- ⚠️ Incompatibilité croissante avec les outils modernes

---

## ✅ Pourquoi choisir PHP 8.1 ou 8.2 ?

### Sécurité ✅
- ✅ Mises à jour de sécurité actives
- ✅ Corrections de CVE rapides
- ✅ Support officiel PHP Foundation

### Performances ⚡
- ✅ **40-50% plus rapide** que PHP 7.4
- ✅ JIT Compiler activé
- ✅ Optimisations mémoire

### Fonctionnalités modernes 🚀
- ✅ Énumérations (Enums)
- ✅ Propriétés readonly
- ✅ Fibers (coroutines)
- ✅ Types union améliorés

### Compatibilité 🔧
- ✅ Testé par Dolibarr (PHPStan 8.2)
- ✅ Supporté par toutes les bibliothèques modernes
- ✅ Compatible avec Apache/Nginx/FPM

---

## 🎯 Recommandation finale pour ERP MTIB

### Pour VPS OVH en production

**Choix optimal** : **PHP 8.2** ⭐⭐⭐⭐⭐

**Pourquoi ?**
1. ✅ Support officiel jusqu'en 2026 (sécurité)
2. ✅ Performances maximales
3. ✅ Testé et validé par Dolibarr (PHPStan)
4. ✅ Pérennité à long terme
5. ✅ Disponible sur tous les VPS OVH

**Alternative acceptable** : **PHP 8.1**

**Pourquoi ?**
- ✅ Très stable
- ✅ Support jusqu'en 2025
- ✅ Compatible avec Dolibarr 23.0
- ✅ Bon compromis stabilité/performance

---

## 📝 Checklist d'installation PHP

- [ ] Désinstaller PHP 7.x (si présent)
- [ ] Installer PHP 8.2 (ou 8.1)
- [ ] Installer toutes les extensions requises
- [ ] Configurer `php.ini` (memory_limit, upload_max_filesize, etc.)
- [ ] Redémarrer Apache/Nginx
- [ ] Vérifier `php -v` → doit afficher 8.2.x
- [ ] Vérifier `php -m` → vérifier les extensions
- [ ] Tester l'installation Dolibarr
- [ ] Vérifier les logs d'erreur PHP

---

## 📚 Ressources utiles

- [PHP Supported Versions](https://www.php.net/supported-versions.php)
- [Dolibarr Wiki - PHP Requirements](https://wiki.dolibarr.org/index.php/Releases)
- [Benchmark PHP 7.4 vs 8.0 vs 8.1 vs 8.2](https://kinsta.com/blog/php-benchmarks/)

---

**Résumé** :
- ✅ **Minimum Dolibarr** : PHP 7.2 (mais obsolète !)
- ✅ **Testé Dolibarr** : PHP 8.2 (PHPStan)
- ✅ **Recommandé MTIB** : **PHP 8.2** ou PHP 8.1
- ❌ **À éviter** : Toutes les versions PHP 7.x (fin de vie)

---

**Mis à jour le** : 2 janvier 2026
**Par** : EVE-MEDIA
**Client** : MTIB
