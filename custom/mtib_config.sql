-- ================================================================
-- Configuration SQL pour ERP MTIB
-- Copyright (C) 2026 EVE-MEDIA - All rights reserved
-- ================================================================
--
-- Ce script configure les paramètres de base pour le client MTIB
-- Exécuter ce script après l'installation de Dolibarr
--
-- Usage: mysql -u root -p nom_base_de_donnees < mtib_config.sql
-- ================================================================

-- Configuration du nom de l'application
DELETE FROM llx_const WHERE name = 'MAIN_APPLICATION_TITLE';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_APPLICATION_TITLE', 'ERP MTIB', 'chaine', 0, 0);

-- Configuration du nom de la société
DELETE FROM llx_const WHERE name = 'MAIN_INFO_SOCIETE_NOM';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_INFO_SOCIETE_NOM', 'MTIB', 'chaine', 0, 0);

-- Désactiver les mentions open source dans le footer (optionnel)
DELETE FROM llx_const WHERE name = 'MAIN_HIDE_POWERED_BY';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_HIDE_POWERED_BY', '1', 'yesno', 0, 0);

-- Configuration copyright EVE-MEDIA
DELETE FROM llx_const WHERE name = 'MAIN_INFO_SOCIETE_NOTE';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_INFO_SOCIETE_NOTE', 'Copyright (C) 2026 EVE-MEDIA - Tous droits réservés', 'texte', 0, 0);

-- Optionnel: Définir le thème par défaut
DELETE FROM llx_const WHERE name = 'MAIN_THEME';
INSERT INTO llx_const (name, value, type, visible, entity)
VALUES ('MAIN_THEME', 'eldy', 'chaine', 0, 0);

-- Afficher un message de succès
SELECT 'Configuration MTIB appliquée avec succès!' AS Message;
SELECT name, value FROM llx_const WHERE name IN (
    'MAIN_APPLICATION_TITLE',
    'MAIN_INFO_SOCIETE_NOM',
    'MAIN_HIDE_POWERED_BY',
    'MAIN_INFO_SOCIETE_NOTE',
    'MAIN_THEME'
) ORDER BY name;
