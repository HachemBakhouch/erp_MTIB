# Installation du Thème Personnalisé ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

---

## 🎨 Charte Graphique

### Couleurs Principales
- **Bleu Marine Foncé**: `#002B5B`
- **Bleu Marine Moyen**: `#1A5490`
- **Bleu Clair**: `#2E8BC0`
- **Orange Accent**: `#FF6B35`

### Caractéristiques
- ✅ Page de connexion moderne avec dégradé bleu marine
- ✅ Animations fluides et transitions
- ✅ Interface principale redessinée
- ✅ Boutons avec effets hover
- ✅ Formulaires modernes avec focus effects
- ✅ Tableaux et cartes avec ombres
- ✅ Scrollbar personnalisée
- ✅ Responsive design

---

## 📦 Installation sur le VPS

### Méthode 1: Upload via Git (Recommandée)

**Sur votre PC**:
```bash
cd C:\Users\hache\Projects\dolibarrerp\dolibarr
git add htdocs/theme/mtib_custom.css custom/THEME_MTIB_INSTALLATION.md
git commit -m "feat: Add custom MTIB theme with blue marine color scheme"
git push origin main
```

**Sur le VPS**:
```bash
cd /var/www/erp-mtib
git pull origin main
chown www-data:www-data htdocs/theme/mtib_custom.css
chmod 644 htdocs/theme/mtib_custom.css
```

### Méthode 2: Upload direct via SCP

**Sur votre PC** (PowerShell):
```powershell
scp "C:\Users\hache\Projects\dolibarrerp\dolibarr\htdocs\theme\mtib_custom.css" debian@37.59.120.70:/tmp/mtib_custom.css
```

**Sur le VPS**:
```bash
mv /tmp/mtib_custom.css /var/www/erp-mtib/htdocs/theme/mtib_custom.css
chown www-data:www-data /var/www/erp-mtib/htdocs/theme/mtib_custom.css
chmod 644 /var/www/erp-mtib/htdocs/theme/mtib_custom.css
```

---

## 🔧 Activation du Thème

### Option 1: Via la base de données (Automatique)

```bash
mysql -u erp_mtib_user -p erp_mtib << 'EOF'
-- Activer le CSS personnalisé MTIB
DELETE FROM llx_const WHERE name = 'MAIN_OVERWRITE_THEME_RES';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_OVERWRITE_THEME_RES', '/theme/mtib_custom.css', 'chaine', 0, 0);

-- Vérification
SELECT name, value FROM llx_const WHERE name = 'MAIN_OVERWRITE_THEME_RES';
EOF
```

### Option 2: Via l'interface admin

1. Se connecter en tant qu'`admin`
2. Aller dans **Accueil** → **Configuration** → **Affichage**
3. Dans l'onglet **Autre**
4. Chercher "CSS personnalisé additionnel"
5. Entrer: `/theme/mtib_custom.css`
6. Cliquer sur **Modifier**

---

## 🎯 Activation via SQL (Méthode rapide)

Créez un fichier SQL pour activer le thème:

```bash
cat > /var/www/erp-mtib/custom/activate_mtib_theme.sql << 'EOF'
-- Activation du thème MTIB personnalisé
-- Copyright (C) 2026 EVE-MEDIA - All rights reserved

-- Activer le CSS personnalisé
DELETE FROM llx_const WHERE name = 'MAIN_OVERWRITE_THEME_RES';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_OVERWRITE_THEME_RES', '/theme/mtib_custom.css', 'chaine', 0, 0);

-- Forcer le thème Eldy (compatible avec notre CSS)
DELETE FROM llx_const WHERE name = 'MAIN_THEME';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_THEME', 'eldy', 'chaine', 0, 0);

-- Message de confirmation
SELECT
    'Thème MTIB activé avec succès!' as Message,
    name as 'Configuration',
    value as 'Valeur'
FROM llx_const
WHERE name IN ('MAIN_OVERWRITE_THEME_RES', 'MAIN_THEME');
EOF

# Appliquer
mysql -u erp_mtib_user -p erp_mtib < /var/www/erp-mtib/custom/activate_mtib_theme.sql
```

---

## 🧪 Vérification

1. **Vider le cache du navigateur**: `Ctrl + F5`
2. **Ouvrir**: https://www.mtibat.com
3. **Vérifier**:
   - Page de connexion avec fond bleu marine dégradé
   - Boutons avec effet hover
   - Animations fluides

---

## 🔄 Forcer le rechargement du CSS

Si le thème ne s'applique pas immédiatement:

```bash
# Vider le cache de l'application
cd /var/www/erp-mtib
rm -rf documents/install.lock
touch documents/install.lock

# Redémarrer Apache
systemctl restart apache2

# Ajouter un timestamp au CSS pour forcer le rechargement
echo "/* Updated: $(date) */" >> htdocs/theme/mtib_custom.css
```

---

## 🎨 Personnalisations Supplémentaires

### Modifier les couleurs

Éditez le fichier `/var/www/erp-mtib/htdocs/theme/mtib_custom.css`:

```css
:root {
    --mtib-primary-dark: #002B5B;    /* Votre bleu marine foncé */
    --mtib-primary: #1A5490;         /* Votre bleu marine moyen */
    --mtib-accent: #FF6B35;          /* Couleur d'accent */
}
```

### Ajouter votre logo dans la page de connexion

Le logo est déjà configuré. Pour changer sa couleur/style:

```css
.login_center img {
    filter: brightness(0) invert(1); /* Logo blanc */
    /* OU */
    filter: none; /* Logo couleur originale */
}
```

---

## 📱 Test Responsive

Le thème est responsive. Testez sur:
- Desktop: https://www.mtibat.com
- Mobile: Redimensionnez la fenêtre ou utilisez F12 → Mode mobile

---

## 🐛 Dépannage

### Le CSS ne se charge pas

```bash
# Vérifier que le fichier existe
ls -la /var/www/erp-mtib/htdocs/theme/mtib_custom.css

# Vérifier les permissions
chmod 644 /var/www/erp-mtib/htdocs/theme/mtib_custom.css
chown www-data:www-data /var/www/erp-mtib/htdocs/theme/mtib_custom.css

# Vérifier dans la base de données
mysql -u erp_mtib_user -p erp_mtib -e "SELECT * FROM llx_const WHERE name='MAIN_OVERWRITE_THEME_RES';"
```

### Le thème s'applique partiellement

```bash
# Vérifier les erreurs dans le fichier CSS
cd /var/www/erp-mtib/htdocs/theme
grep -n "}" mtib_custom.css | wc -l  # Compter les accolades fermantes
grep -n "{" mtib_custom.css | wc -l  # Compter les accolades ouvrantes
# Les deux nombres doivent être égaux
```

### Revenir au thème par défaut

```bash
mysql -u erp_mtib_user -p erp_mtib << 'EOF'
DELETE FROM llx_const WHERE name = 'MAIN_OVERWRITE_THEME_RES';
EOF
```

---

## 📸 Captures d'écran attendues

### Page de connexion
- Fond: Dégradé bleu marine (#002B5B → #1A5490 → #2E8BC0)
- Carte: Blanche avec ombres
- En-tête carte: Bleu marine foncé
- Bouton: Dégradé bleu avec effet hover
- Inputs: Bordure bleue au focus

### Interface principale
- Menu gauche: Fond gris clair (#F5F7FA)
- Barre supérieure: Bleu marine avec bordure orange
- Boutons: Bleu marine avec effets
- Tableaux: En-têtes bleu marine

---

## 🔗 Ressources

- **Documentation Dolibarr Themes**: https://wiki.dolibarr.org/index.php/Themes
- **Fichier CSS**: `/var/www/erp-mtib/htdocs/theme/mtib_custom.css`
- **Configuration**: Base de données `erp_mtib`, table `llx_const`

---

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

*Thème personnalisé développé pour ERP MTIB*
