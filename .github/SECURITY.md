# Security

## Reporting a vulnerability

Do **not** open an issue for a security problem: everyone with access to the repository can read it.

Tell a maintainer of the repository, or an owner of the **yapindo-frontend** organization, directly and privately.
Include the affected page or endpoint, the steps to reproduce it, and the impact. Expect a reply within two working days.

Only the version running in production is supported; fixes ship there.

## Secrets

- Never commit a secret: tokens, passwords, keys, `.env` files, or user session tokens.
- CI uses GitHub's encrypted secrets and the workflow's own `GITHUB_TOKEN`, never a token in the repository.
- **If a secret leaks**, even for a moment, revoke it at once, then tell a maintainer. Deleting the commit doesn't help.

More in the handbook: [Security and licenses](https://yaplib-site.pages.dev/handbook/security-and-licenses/).
