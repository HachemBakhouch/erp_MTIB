@echo off
REM Script de déploiement ERP MTIB vers VPS OVH (Windows)
REM Copyright (C) 2026 EVE-MEDIA - All rights reserved
REM
REM Usage: deploy-to-vps.bat

echo.
echo ========================================
echo    Deploiement ERP MTIB vers VPS OVH
echo ========================================
echo.

REM Vérifier que Git est installé
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERREUR] Git n'est pas installe ou n'est pas dans le PATH
    pause
    exit /b 1
)

REM Vérifier que nous sommes dans le bon répertoire
if not exist "README.md" (
    echo [ERREUR] Ce script doit etre execute depuis la racine du projet
    pause
    exit /b 1
)

echo [1/4] Push vers GitHub...
git push origin main
if %ERRORLEVEL% neq 0 (
    echo [ERREUR] Echec du push vers GitHub
    pause
    exit /b 1
)

echo.
echo [2/4] Connexion au VPS...
echo.
echo Commandes a executer sur le VPS:
echo ----------------------------------
echo sudo su
echo cd /var/www/erp-mtib
echo git pull origin main
echo chown -R www-data:www-data /var/www/erp-mtib
echo systemctl reload apache2
echo ----------------------------------
echo.
echo Appuyez sur une touche pour vous connecter au VPS...
pause >nul

ssh debian@37.59.120.70

echo.
echo ========================================
echo    Deploiement termine!
echo ========================================
echo.
echo URL: https://www.mtibat.com
echo.
pause
