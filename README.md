# VulnHunter: OWASP Juice Shop Web Vulnerability Exploration

## Executive Summary
This repository documents a comprehensive penetration testing and security evaluation conducted on the OWASP Juice Shop web application. OWASP Juice Shop is an intentionally vulnerable web application designed for security training, awareness, and technical skill development. The primary objective of this project is to systematically identify, exploit, and document security flaws aligned with the OWASP Top 10 web application security risks in a controlled, local environment. 

Through hands-on vulnerability exploration, this project demonstrates technical exploit mechanisms, assesses business impact, and details actionable remediation strategies required to build secure web applications.

---

## Infrastructure & Local Setup

The target environment is fully containerized using Docker to ensure isolation, reproducibility, and safety during testing.

- **Target URL:** `http://localhost:3000`
- **Deployment Platform:** Docker Container (`bkimminich/juice-shop`)
- **Automated Deployment:** Run `./setup.sh` to pull, configure, and launch the containerized application automatically.

---

## Vulnerability Findings Summary

The table below outlines the six primary vulnerabilities discovered and successfully exploited during the security assessment:

| ID | Vulnerability Type | Vulnerable Vector / Endpoint | Exploitation Status | Comprehensive Report |
| :--- | :--- | :--- | :--- | :--- |
| **01** | SQL Injection (SQLi) | User Authentication (`/rest/user/login`) | Exploited | [View Exploit Report](exploits/01-SQLI/report.md) |
| **02** | DOM-based XSS | Global Search Field (`/#/search`) | Exploited | [View Exploit Report](exploits/02-DOM-XSS/report.md) |
| **03** | Broken Access Control | User Registration API (`/api/Users/`) | Exploited | [View Exploit Report](exploits/03-BAC/report.md) |
| **04** | Insecure Direct Object Reference (IDOR) | User Basket Management (`/rest/basket/{id}`) | Exploited | [View Exploit Report](exploits/04-IDOR/report.md) |
| **05** | Sensitive Information Disclosure | Memories API (`/rest/memories`) | Exploited | [View Exploit Report](exploits/05-sensitive-information-disclosure/report.md) |
| **06** | Cross-Site Request Forgery (CSRF) | User Profile Update (`/profile`) | Exploited | [View Exploit Report](exploits/06-CSRF/report.md) |

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

### 3. Broken Access Control (Mass Assignment)
- **Description:** The application automatically binds client-provided HTTP request parameters directly to internal data models without maintaining a strict field authorization whitelist.
- **Exploit Vector:** Appending `"role": "admin"` to the JSON body of the `POST /api/Users/` registration request to create an account with full administrative privileges.
- **Impact:** Any unauthenticated visitor can provision fully-privileged administrative accounts, rendering the application's permission controls useless.

### 4. Insecure Direct Object Reference (IDOR)
- **Description:** Broken object-level access control where user-supplied input directly references database objects without checking ownership or authorization.
- **Exploit Vector:** Modifying the `{id}` path parameter in HTTP requests (`/rest/basket/{id}`) to view, add, or tamper with shopping baskets belonging to other users.
- **Impact:** Unauthorized access to private customer data, data leakage, and unauthorized modification of user orders.

### 5. Sensitive Information Disclosure (API Enumeration & Credential Leakage)
- **Description:** Undocumented API endpoints expose raw backend database objects containing sensitive user records without authentication or field-level filtering.
- **Exploit Vector:** Enumerating API paths using `ffuf` with `wordlist.txt` to uncover `/rest/memories`, which returns unredacted user models leaking plaintext emails, MD5 password hashes, deluxe tokens, and system metadata.
- **Impact:** Credential harvesting, offline password hash cracking, account takeover, and reconnaissance against privileged application users.

### 6. Cross-Site Request Forgery (CSRF)
- **Description:** The profile update endpoint processes state-changing requests without validating a CSRF token or verifying the request origin.
- **Exploit Vector:** Hosting a malicious HTML page with a hidden auto-submitting form targeting `POST /profile` to silently change the victim's username while they are authenticated.
- **Impact:** Unauthorized modification of victim account details, potential account takeover when chained with other vulnerabilities, and execution of arbitrary state-changing actions on behalf of the victim.

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