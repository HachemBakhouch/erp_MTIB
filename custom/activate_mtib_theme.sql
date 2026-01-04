-- Activation du thème MTIB personnalisé
-- Copyright (C) 2026 EVE-MEDIA - All rights reserved
--
-- Usage: mysql -u erp_mtib_user -p erp_mtib < activate_mtib_theme.sql

-- Activer le CSS personnalisé MTIB
DELETE FROM llx_const WHERE name = 'MAIN_OVERWRITE_THEME_RES';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_OVERWRITE_THEME_RES', '/theme/mtib_custom.css', 'chaine', 0, 0);

-- Forcer le thème Eldy (compatible avec notre CSS)
DELETE FROM llx_const WHERE name = 'MAIN_THEME';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_THEME', 'eldy', 'chaine', 0, 0);

-- Désactiver le mode mobile (pour garder le design desktop responsive)
DELETE FROM llx_const WHERE name = 'MAIN_OPTIMIZEFORTEXTBROWSER';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_OPTIMIZEFORTEXTBROWSER', '0', 'yesno', 0, 0);

-- Message de confirmation
SELECT
    '✅ Thème MTIB activé avec succès!' as Message,
    name as 'Configuration',
    value as 'Valeur'
FROM llx_const
WHERE name IN ('MAIN_OVERWRITE_THEME_RES', 'MAIN_THEME', 'MAIN_OPTIMIZEFORTEXTBROWSER');
