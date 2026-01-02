# Security Policy - ERP MTIB

**Copyright (C) 2026 EVE-MEDIA - All rights reserved**

---

## 🔒 Software Security

This software is proprietary and developed by **EVE-MEDIA** for **MTIB**.

---

## 📧 Reporting a Security Vulnerability

If you discover a security vulnerability in this application, please report it responsibly:

**Contact** : security@eve-media.com (à remplacer par votre email réel)

**Please include** :
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

---

## ⚠️ Responsible Disclosure

- Do **NOT** publicly disclose the vulnerability before it has been addressed
- Allow reasonable time for the issue to be fixed
- Do **NOT** exploit the vulnerability beyond what is necessary to demonstrate it

---

## 🛡️ Security Best Practices

For administrators of this ERP system:

### Recommended Configuration

1. **Production Mode**
   - Set `$dolibarr_main_prod = 1` in `conf.php`
   - Disable error display to end users

2. **HTTPS Only**
   - Set `$dolibarr_main_force_https = 1` or higher
   - Use valid SSL/TLS certificates

3. **CSRF Protection**
   - Set `MAIN_SECURITY_CSRF_WITH_TOKEN = 3`
   - Keep `$dolibarr_nocsrfcheck = 0`

4. **File Permissions**
   - `htdocs/` directory: Read-only (755)
   - `documents/` directory: Write-only for uploads (775)
   - `htdocs/conf/conf.php`: 640

5. **Database Security**
   - Use strong passwords
   - Limit database user privileges
   - Regular backups

6. **Updates**
   - Keep PHP version up to date (8.1 or 8.2 recommended)
   - Monitor security advisories
   - Apply patches promptly

---

## 🚫 Out of Scope

The following are **not** considered security vulnerabilities:

- Issues requiring physical access to the server
- Social engineering attacks
- Brute force attacks (use fail2ban)
- Issues in disabled or development modules
- Browser-specific vulnerabilities
- SSL/TLS configuration issues (server responsibility)

---

## 📞 Support

For general support or questions:

**EVE-MEDIA**
Email: support@eve-media.com (à remplacer)
Website: https://www.eve-media.com (à remplacer)

---

**Last updated**: January 2026
**Version**: 1.0
