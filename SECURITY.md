# Security Policy

Thank you for helping keep this project secure. This policy outlines the process for reporting vulnerabilities and the security measures in place for this project.

Please note, this policy applies to the **Docker packaging, configuration, and build process** of Vdirsyncer. Vulnerabilities found in the Vdirsyncer software itself should be reported directly to the upstream project, [pimutils/vdirsyncer](https://github.com/pimutils/vdirsyncer).

## Supported Versions

Security updates are provided for the latest minor release of each major version. You are encouraged to use the latest version to ensure you have the most recent security patches.

| Version           | Supported          |
| :---------------- | :----------------- |
| **Latest Release** | :white_check_mark: |
| Older Versions    | :x:                |

The base image (Alpine Linux) and the CI/CD actions are kept up-to-date with weekly scans by Dependabot.

## Reporting a Vulnerability

**Please do not disclose vulnerabilities in public GitHub issues.**

If you discover a security vulnerability, please report it privately through **GitHub's private vulnerability reporting feature**. This ensures that the issue can be addressed before being publicly disclosed.

**[➡️ Report a Security Vulnerability Here](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/security/advisories/new)**

I will do my best to:

* Acknowledge receipt of your report.
* Provide an initial assessment.
* Keep you updated on the progress of a fix.

## Security Practices

This project incorporates several security practices to ensure the integrity and security of the container images.

### Image Signing

All official images pushed to Docker Hub and the GitHub Container Registry are cryptographically signed using **Cosign**. You can and should verify the signature of any image before use to ensure it is authentic and has not been tampered with.

The public key and verification instructions are available in the project's [**README.md**](https://github.com/Bleala/Vdirsyncer-DOCKERIZED#image-signing--verification).

### CI/CD Security Scanning

The CI/CD pipeline for this project includes several automated security checks:

* **Secret Scanning**: The repository is scanned by **Gitleaks** to prevent accidental exposure of secrets.
* **Image Vulnerability Scanning**: Each container image is scanned for known vulnerabilities in its OS packages and libraries using **Trivy** before a release.
* **Workflow Linting**: All GitHub Actions workflows are linted for correctness and best practices using **Actionlint** and **Zizmor**.
