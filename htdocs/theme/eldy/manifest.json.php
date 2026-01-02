<?php
/* Copyright (C) 2026 EVE-MEDIA - All rights reserved
 *
 * This software is proprietary and confidential.
 * Unauthorized copying, distribution or modification is strictly prohibited.
 */

/**
 *		\file       htdocs/theme/eldy/manifest.json.php
 *		\brief      File for The Web App (PWA)
 */

if (!defined('NOREQUIREUSER')) {
	define('NOREQUIREUSER', '1');
}
if (!defined('NOREQUIRESOC')) {
	define('NOREQUIRESOC', '1');
}
if (!defined('NOREQUIRETRAN')) {
	define('NOREQUIRETRAN', '1');
}
if (!defined('NOTOKENRENEWAL')) {
	define('NOTOKENRENEWAL', '1');
}
if (!defined('NOLOGIN')) {
	define('NOLOGIN', '1');
}
if (!defined('NOREQUIREMENU')) {
	define('NOREQUIREMENU', '1');
}
if (!defined('NOREQUIREHTML')) {
	define('NOREQUIREHTML', '1');
}
if (!defined('NOREQUIREAJAX')) {
	define('NOREQUIREAJAX', '1');
}
if (!defined('NOSESSION')) {
	define('NOSESSION', '1');
}

require_once __DIR__.'/../../main.inc.php';

/**
 * @var Conf $conf
 */

top_httphead('text/json');
// Important: Following code is to avoid page request by browser and PHP CPU at each Dolibarr page access.
if (empty($dolibarr_nocache)) {
	header('Cache-Control: max-age=10800, public, must-revalidate');
	// For a text/json, we must set an Expires to avoid to have it forced to an expired value by the web server
	header('Expires: '.gmdate('D, d M Y H:i:s', dol_now('gmt') + 10800).' GMT');
} else {
	header('Cache-Control: no-cache');
}


$manifest = new stdClass();

$manifest->manifest_version = 3;

$manifest->name = constant('DOL_APPLICATION_TITLE');
if (getDolGlobalString('MAIN_APPLICATION_TITLE')) {
	$manifest->name = getDolGlobalString('MAIN_APPLICATION_TITLE');
}
$manifest->short_name = $manifest->name;


$manifest->theme_color = getDolGlobalString('MAIN_MANIFEST_APPLI_THEME_COLOR', getDolGlobalString('THEME_ELDY_TOPMENU_BACK1', '#F05F40'));
if (!preg_match('/#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$/', $manifest->theme_color)) {
	include_once DOL_DOCUMENT_ROOT.'/core/lib/functions2.lib.php';
	$manifest->theme_color = '#'.colorArrayToHex(colorStringToArray($manifest->theme_color));
}
$manifest->background_color = getDolGlobalString('MAIN_MANIFEST_APPLI_BG_COLOR', "#ffffff");
if (!preg_match('/#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$/', $manifest->background_color)) {
	include_once DOL_DOCUMENT_ROOT.'/core/lib/functions2.lib.php';
	$manifest->background_color = '#'.colorArrayToHex(colorStringToArray($manifest->background_color));
}
$manifest->display = getDolGlobalString('MAIN_MANIFEST_DISPLAY', "minimal-ui");
$manifest->splash_pages = null;
$manifest->icons = array();
$manifest->start_url = constant('DOL_MAIN_URL_ROOT');
$manifest->id = constant('DOL_MAIN_URL_ROOT');

if (getDolGlobalString('MAIN_MANIFEST_APPLI_LOGO_URL')) {
	$icon = new stdClass();
	$icon->src = getDolGlobalString('MAIN_MANIFEST_APPLI_LOGO_URL');
	if ($conf->global->MAIN_MANIFEST_APPLI_LOGO_URL_SIZE) {
		$icon->sizes = getDolGlobalString('MAIN_MANIFEST_APPLI_LOGO_URL_SIZE') . "x" . getDolGlobalString('MAIN_MANIFEST_APPLI_LOGO_URL_SIZE');
	} else {
		$icon->sizes = "512x512";
	}
	$icon->type = "image/png";
	$manifest->icons[] = $icon;
} elseif (getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED')) {
	if (getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED_MINI')) {
		$iconRelativePath = 'logos/thumbs/' . getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED_MINI');
		$iconPath = $conf->mycompany->dir_output.'/'.$iconRelativePath;
		if (is_readable($iconPath)) {
			$imgSize = getimagesize($iconPath);
			if (!empty($imgSize)) {
				$icon = new stdClass();
				$icon->src = DOL_URL_ROOT.'/viewimage.php?cache=1&modulepart=mycompany&file='.urlencode($iconRelativePath);
				$icon->sizes = $imgSize[0]."x".$imgSize[1];
				$icon->type = "image/png";
				$manifest->icons[] = $icon;
			}
		}
	}

	if (getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED_SMALL')) {
		$iconRelativePath = 'logos/thumbs/' . getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED_SMALL');
		$iconPath = $conf->mycompany->dir_output.'/'.$iconRelativePath;
		if (is_readable($iconPath)) {
			$imgSize = getimagesize($iconPath);
			if ($imgSize) {
				$icon = new stdClass();
				$icon->src = DOL_URL_ROOT.'/viewimage.php?cache=1&modulepart=mycompany&file='.urlencode($iconRelativePath);
				$icon->sizes = $imgSize[0]."x".$imgSize[1];
				$icon->type = "image/png";
				$manifest->icons[] = $icon;
			}
		}
	}

	if (getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED')) {
		$iconRelativePath = 'logos/' . getDolGlobalString('MAIN_INFO_SOCIETE_LOGO_SQUARRED');
		$iconPath = $conf->mycompany->dir_output.'/'.$iconRelativePath;
		if (is_readable($iconPath)) {
			$imgSize = getimagesize($iconPath);
			if ($imgSize) {
				$icon = new stdClass();
				$icon->src = DOL_URL_ROOT.'/viewimage.php?cache=1&modulepart=mycompany&file='.urlencode($iconRelativePath);
				$icon->sizes = $imgSize[0]."x".$imgSize[1];
				$icon->type = "image/png";
				$manifest->icons[] = $icon;
			}
		}
	}
}

// Add Dolibarr std icon
if (empty($manifest->icons)) {
	$icon = new stdClass();
	$icon->src = DOL_URL_ROOT.'/theme/dolibarr_256x256_color.png';
	$icon->sizes = "256x256";
	$icon->type = "image/png";
	$manifest->icons[] = $icon;
}


print json_encode($manifest);
