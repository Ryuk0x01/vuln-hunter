# VulnHunter: OWASP Juice Shop Web Vulnerability Exploration

## Executive Summary
This repository documents a comprehensive penetration testing and security evaluation conducted on the OWASP Juice Shop web application. OWASP Juice Shop is an intentionally vulnerable web application designed for security training, awareness, and technical skill development. The primary objective of this project is to systematically identify, exploit, and document security flaws aligned with the OWASP Top 10 web application security risks in a controlled, local environment. 

Through hands-on vulnerability exploration, this project demonstrates technical exploit mechanisms, assesses business impact, and details actionable remediation strategies required to build secure web applications.

---

## Infrastructure & Local Setup

The target environment is fully containerized using Docker to ensure isolation, reproducibility, and safety during testing.

- **Target URL:** `http://localhost:3000`
- **Deployment Platform:** Docker Container (`bkimminich/juice-shop`)
- **Automated Deployment:** Run `./setup/setup.sh` to pull, configure, and launch the containerized application automatically.

---

## Vulnerability Findings Summary

The table below outlines the five primary vulnerabilities discovered and successfully exploited during the security assessment:

| ID | Vulnerability Type | Vulnerable Vector / Endpoint | Exploitation Status | Comprehensive Report |
| :--- | :--- | :--- | :--- | :--- |
| **01** | SQL Injection (SQLi) | User Authentication (`/rest/user/login`) | Exploited | [View Exploit Report](exploits/01-sql-injection-login/report.md) |
| **02** | DOM-based XSS | Global Search Field (`/#/search`) | Exploited | [View Exploit Report](exploits/02-xss-dom/report.md) |
| **03** | Broken Authentication | Admin Security Question Reset (`/rest/user/reset-password`) | Exploited | [View Exploit Report](exploits/03-broken-auth-admin/report.md) |
| **04** | Insecure Direct Object Reference (IDOR) | User Basket Management (`/rest/basket/{id}`) | Exploited | [View Exploit Report](exploits/04-idor-basket/report.md) |
| **05** | Security Misconfiguration | Unprotected API Documentation (`/api-docs`) | Exploited | [View Exploit Report](exploits/05-security-misconfig/report.md) |

---

## Detailed Vulnerability Breakdown

### 1. SQL Injection (SQLi)
- **Description:** Flaw in input handling on the authentication endpoint allows structural modification of backend SQL queries.
- **Exploit Vector:** Injecting SQL control characters (`' OR 1=1--`) into the email input field bypasses password verification entirely.
- **Impact:** Complete account takeover of administrative accounts, unauthorized access to private data, and potential compromise of database integrity.

### 2. DOM-based Cross-Site Scripting (XSS)
- **Description:** Client-side scripts execute untrusted input injected directly into the Document Object Model (DOM) without proper sanitization or context-aware encoding.
- **Exploit Vector:** Injecting an HTML payload containing inline JavaScript (`<iframe src="javascript:alert('XSS')">`) via search parameter.
- **Impact:** Arbitrary JavaScript execution in the victim's browser, session hijacking, cookie theft, and client-side UI redressing.

### 3. Broken Authentication (Security Question Bypass)
- **Description:** Flawed password recovery logic relying on weak, publicly discoverable security questions without rate limiting or multi-factor verification.
- **Exploit Vector:** Bypassing authentication by answering the administrative account's security question (`Mr. Noodles`) to forcibly reset the password via `/rest/user/reset-password`.
- **Impact:** Administrative account takeover, privilege escalation, and bypass of standard login mechanisms.

### 4. Insecure Direct Object Reference (IDOR)
- **Description:** Broken object-level access control where user-supplied input directly references database objects without checking ownership or authorization.
- **Exploit Vector:** Modifying the `{id}` path parameter in HTTP requests (`/rest/basket/{id}`) to view, add, or tamper with shopping baskets belonging to other users.
- **Impact:** Unauthorized access to private customer data, data leakage, and unauthorized modification of user orders.

### 5. Security Misconfiguration (Exposed API Docs)
- **Description:** Development tools, internal documentation, or debug endpoints left publicly accessible in production builds.
- **Exploit Vector:** Navigating directly to the `/api-docs` endpoint to access hidden REST API schematics and unlinked service endpoints.
- **Impact:** System information disclosure, mapping of attack surface for further exploitation, and exposure of internal backend structures.

---

## Ethical Hacking & Responsible Disclosure

### 1. Importance of Authorization
Penetration testing without prior, explicit, and formal authorization is strictly illegal under international computer crime laws (such as the CFAA and equivalent cybercrime legislation). Security testing must always be governed by formal Rules of Engagement (RoE) signed by authorized system owners before any scanning or exploitation begins.

### 2. Legal and Operational Boundaries
All security assessments and exploits detailed in this repository were strictly executed within an isolated local host environment (`localhost:3000`). No unauthorized external targets, public networks, or third-party web assets were evaluated or targeted. Testing boundaries were maintained exclusively within the local Docker container instance.

### 3. Responsible Disclosure Guidelines
When vulnerabilities are identified in real-world systems, ethical hackers must follow strict Responsible Disclosure principles:
- **Private Notification:** Privately alert the vendor or organization's security team with a detailed security report before public disclosure.
- **Remediation Window:** Allow a reasonable timeframe (typically 60 to 90 days) for the organization to issue a patch or mitigation.
- **Do No Harm:** Avoid extracting sensitive customer data, modifying production databases, or degrading service availability (DoS) during proof-of-concept creation.