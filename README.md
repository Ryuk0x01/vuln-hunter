# VulnHunter: OWASP Juice Shop Web Vulnerability Exploration

## Executive Summary

This repository documents a penetration testing and security assessment conducted on the OWASP Juice Shop web application.

The objective is to identify, exploit, and document web vulnerabilities related to the OWASP Top 10 in a controlled local environment.

The assessment identified **6 vulnerabilities**, exceeding the minimum requirement of 5.

---

## Infrastructure & Local Setup

The target environment uses Docker to ensure isolation and reproducibility.

- **Target URL:** `http://localhost:3000`
- **Deployment:** Docker (`bkimminich/juice-shop`)
- **Setup Commands:**

```bash
docker pull bkimminich/juice-shop
docker run --rm -p 3000:3000 bkimminich/juice-shop
```

Press `Ctrl + C` to stop the application. The `--rm` option automatically removes the container when stopped.

---

## Vulnerability Findings Summary

| ID | Vulnerability Type | Vulnerable Endpoint | Status | Report |
|---|---|---|---|---|
| 01 | SQL Injection (SQLi) | `/rest/user/login` | Exploited | [Report](exploits/01-SQLI/report.md) |
| 02 | DOM-based XSS | `/#/search` | Exploited | [Report](exploits/02-DOM-XSS/report.md) |
| 03 | Broken Access Control | `/api/Users/` | Exploited | [Report](exploits/03-BAC/report.md) |
| 04 | IDOR | `/rest/basket/{id}` | Exploited | [Report](exploits/04-IDOR/report.md) |
| 05 | Sensitive Information Disclosure | `/rest/memories` | Exploited | [Report](exploits/05-sensitive-information-disclosure/report.md) |
| 06 | CSRF | `/profile` | Exploited | [Report](exploits/06-CSRF/report.md) |

---

## Detailed Vulnerability Breakdown

### 1. SQL Injection (SQLi)

- **Description:** Improper SQL query handling allows attackers to manipulate database queries.
- **Exploit:** `' OR 1=1--` through the login endpoint.
- **Impact:** Authentication bypass and unauthorized access.
- **Remediation:** Parameterized queries and input validation.

### 2. DOM-based Cross-Site Scripting (XSS)

- **Description:** Client-side scripts process untrusted input without proper sanitization.
- **Exploit:** HTML/JavaScript payload through the search functionality.
- **Impact:** Arbitrary JavaScript execution in the victim's browser.
- **Remediation:** Output encoding, input sanitization, and CSP.

### 3. Broken Access Control (Mass Assignment)

- **Description:** The application improperly accepts client-controlled privileged fields.
- **Exploit:** Testing the `"role": "admin"` field in the registration API.
- **Impact:** Unauthorized privilege escalation.
- **Remediation:** Server-side authorization and field whitelisting.

### 4. Insecure Direct Object Reference (IDOR)

- **Description:** Missing ownership verification when accessing user resources.
- **Exploit:** Modifying the `{id}` parameter in basket requests.
- **Impact:** Unauthorized access to other users' data.
- **Remediation:** Server-side ownership and authorization checks.

### 5. Sensitive Information Disclosure

- **Description:** An API endpoint exposes sensitive application information.
- **Exploit:** Endpoint discovery using ffuf and `wordlist.txt`.
- **Impact:** Exposure of sensitive information and potential credential compromise.
- **Remediation:** API access control and sensitive field filtering.

### 6. Cross-Site Request Forgery (CSRF)

- **Description:** State-changing requests may be processed without sufficient CSRF protection.
- **Exploit:** HTML proof-of-concept targeting the profile update functionality.
- **Impact:** Unauthorized actions using an authenticated user's session.
- **Remediation:** CSRF tokens, SameSite cookies, and origin validation.

---

## Evidence & Proof of Concept

The repository contains:

- Individual exploit reports.
- Reproducible PoC payloads and HTTP requests.
- curl and ffuf commands.
- **13 screenshots** documenting testing and exploitation.
- Impact analysis and remediation recommendations.

---

## Ethical Hacking & Responsible Disclosure

- **Authorization:** Testing must only be performed with explicit permission.
- **Testing Boundaries:** All testing was conducted locally at `localhost:3000` using Docker.
- **No Unauthorized Targets:** No external systems were targeted.
- **Responsible Disclosure:** Vulnerabilities should be privately reported to the responsible organization, allowing reasonable time for remediation.
- **Do No Harm:** Avoid destructive testing, unnecessary data access, and service disruption.

---

## Security Recommendations

1. Use parameterized queries to prevent SQL Injection.
2. Apply context-aware output encoding and CSP to prevent XSS.
3. Enforce server-side authorization and field whitelisting.
4. Verify resource ownership to prevent IDOR.
5. Restrict sensitive API responses and protect confidential information.
6. Implement CSRF tokens and secure cookie configurations.

