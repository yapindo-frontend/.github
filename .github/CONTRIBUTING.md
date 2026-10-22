# Contributing

This is the default for every repository in **yapindo-frontend** that has no CONTRIBUTING of its own.
How we work is written once, in the [frontend handbook](https://yaplib-site.pages.dev/handbook/) ([Bahasa Indonesia](https://yaplib-site.pages.dev/id/handbook/)); this page is the short version.
Setup and project-specific rules are in each repository's README.

## Workflow

1. **Every change starts from an issue or task.** Use one of the issue forms (Laporan Bug, Permintaan Fitur,
   Peningkatan, Tugas Teknis); each sets the issue's type.
2. **Triage**: whoever triages sets the **Priority** field (and **Effort** when it helps planning) and assigns an owner.
   An issue with no Priority hasn't been triaged yet.
3. **Branch** from the repository's integration branch (`dev` where it has one, otherwise `main` or `master`),
   named `<type>/<task-id>-<short-name>`:

   ```bash
   gh issue develop <number> --base <branch> --name feat/<number>-short-name --checkout
   ```

   Hotfixes branch from the production branch as `hotfix/<short-name>`.

4. **Commit** with [Conventional Commits](https://www.conventionalcommits.org/): `feat(orders): ...`, `fix(checkout): ...`,
   one change per commit. Release tools build the version and changelog from them. See [Commits](https://yaplib-site.pages.dev/handbook/how-we-work/#commits).
5. **Open a pull request** and fill in the template: every change, why, how you tested it, what you couldn't check.
   Write `Closes #<number>` to link the issue. See [Pull requests](https://yaplib-site.pages.dev/handbook/how-we-work/#pull-requests).
6. **Review**: go through the [Definition of done](https://yaplib-site.pages.dev/handbook/definition-of-done/) first. Code owners review as
   [Code review](https://yaplib-site.pages.dev/handbook/code-review/) describes. Never merge with red checks.

## Issue types

| Type      | Use for                                                                       | Form                          |
| --------- | ----------------------------------------------------------------------------- | ----------------------------- |
| `Bug`     | Something that is broken                                                      | Laporan Bug                   |
| `Feature` | A feature that does not exist yet, or making one better (UX, UI, performance) | Permintaan Fitur, Peningkatan |
| `Task`    | Technical work with no behavior change (deps, CI, tech debt)                  | Tugas Teknis                  |

## Priority

| Priority | Meaning                                                |
| -------- | ------------------------------------------------------ |
| Urgent   | Breaks production or blocks users: pick up immediately |
| High     | Planned for the current iteration                      |
| Medium   | Planned for the next iteration                         |
| Low      | Nice to have: picked up when there is room             |
