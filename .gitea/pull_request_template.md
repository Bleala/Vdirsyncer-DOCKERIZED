# 📝 PR Title Convention

**Please provide a Pull Request title in the format of [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).**
This helps automate versioning and changelog generation.

* `feat:` Adds a new user-facing feature (triggers a `minor` release)
* `fix:` Patches a user-facing bug (triggers a `patch` release)
* `perf:` A code change that improves performance (triggers a `patch` release)
* `docs:` Changes to documentation only (no release)
* `style:` Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc.) (no release)
* `refactor:` A code change that neither fixes a bug nor adds a feature (e.g., code restructuring, renaming variables) (no release)
* `test:` Adding missing tests or correcting existing tests; does not alter production code (no release)
* `build:` Changes that affect the build system or external dependencies (e.g., `Dockerfile` updates, changes to npm packages, updates to build scripts) (no release)
* `ci:` Changes to our CI configuration files and scripts (e.g., GitHub Actions workflows) (no release)
* `chore:` Other changes that don't modify `src` or `test` files (e.g., updating `.gitignore`, project configuration changes) (no release)

* For a **Breaking Change**, add a `!` after the type (e.g., `feat!: ...`) OR add a `BREAKING CHANGE:` footer in the PR description. This will **always** trigger a `major` release, regardless of the type.

---

## 🔗 Related Issue

Closes: #

## 🎯 Description

### ✅ How Has This Been Tested?

**Testing Checklist:**

* [ ] The Docker image builds successfully locally (`docker build .`).
* [ ] The container starts without errors with the new configuration.
* [ ] I have manually verified the changed functionality (e.g., successfully ran vdirsyncer commands).
* [ ] My changes were tested on the following system: `[Please enter your OS and Docker version here]`

### ☑️ Final Checklist

* [ ] My code follows the style guidelines of this project.
* [ ] I have performed a self-review of my own code.
* [ ] My commits have clear and conventional messages.
* [ ] My change requires a change to the documentation, and I have updated the documentation accordingly.
* [ ] My change adds new configuration variables, and I have updated the `.env.example` and/or `dcker-compose.yml` file accordingly.

---

Thank you for your time and effort in helping to improve this project!
