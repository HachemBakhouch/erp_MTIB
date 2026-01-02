#!/bin/bash
# Script de déploiement ERP MTIB vers VPS OVH
# Copyright (C) 2026 EVE-MEDIA - All rights reserved
#
# Usage: ./deploy-to-vps.sh

set -e

# Configuration
VPS_HOST="37.59.120.70"
VPS_USER="debian"
APP_PATH="/var/www/erp-mtib"

echo "🚀 Déploiement ERP MTIB vers VPS OVH"
echo "======================================"
echo ""

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "README.md" ]; then
    echo "❌ Erreur: Ce script doit être exécuté depuis la racine du projet"
    exit 1
fi

# Pousser les changements vers GitHub
echo "📤 Push vers GitHub..."
git push origin main

# Se connecter au VPS et déployer
echo ""
echo "📥 Déploiement sur le VPS..."
ssh ${VPS_USER}@${VPS_HOST} << 'ENDSSH'
    echo "🔧 Connexion au VPS établie"

    # Passer en root
    sudo su - << 'ENDROOT'
        cd /var/www/erp-mtib

        echo "📦 Récupération des dernières modifications..."
        git pull origin main

        echo "🔐 Vérification des permissions..."
        chown -R www-data:www-data /var/www/erp-mtib
        find /var/www/erp-mtib -type d -exec chmod 755 {} \;
        find /var/www/erp-mtib -type f -exec chmod 644 {} \;

        # Protéger le fichier de configuration
        if [ -f htdocs/conf/conf.php ]; then
            chmod 444 htdocs/conf/conf.php
        fi

        echo "🔄 Redémarrage Apache..."
        systemctl reload apache2

        echo "✅ Déploiement terminé avec succès!"
ENDROOT
ENDSSH

echo ""
echo "✨ Déploiement complet!"
echo "🌐 URL: https://www.mtibat.com"
echo ""
