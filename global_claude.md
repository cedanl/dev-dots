# Global Agent Instructions (devcontainer-wide)

This file holds agent behavior that applies across **all** repositories in this
devcontainer. It is loaded globally by Claude Code (`~/.claude/CLAUDE.md`) and
OpenCode (`~/.config/opencode/AGENTS.md`).

Project-level instructions (a repo's `CLAUDE.md` / `AGENTS.md`) take precedence
where this file and a project file conflict. Treat this as the shared baseline:
the working agreement that every project in this container inherits unless a
repo explicitly overrides it.

## Tone & communication

- Be concise and direct. Prefer short answers over long explanations; give
  detail only when the task warrants it or the user asks for it.
- Write in the language of the conversation. In Dutch repositories, default to
  Dutch; in English repositories, default to English. Match surrounding code
  and docs.
- Ask before making destructive, irreversible, or high-impact changes (deleting
  data, force-pushing, rewriting history, rotating credentials).
- When unsure whether a change is wanted, state the trade-off and ask rather
  than guessing. When the best option is clear, recommend it explicitly.

## Working with the codebase

- Before editing, explore: find the relevant files, understand the conventions
  (style, framework, naming, testing), then make the smallest change that fits.
- Follow each repo's existing patterns. Reuse libraries already in use; do not
  introduce a dependency or framework that the project does not already use.
- Run the repo's own lint, typecheck, and test commands before finishing, and
  fix anything you introduced.
- Only change what the task requires. Avoid unrelated reformatting or
  refactors that clutter the diff.
- Verify your work. Prefer running tests over reasoning from memory.

## Git hygiene

- Commit and push only when the user asks, or completes an interrupted action
  they requested.
- Keep each commit focused and its message consistent with the project's style.
- Staging: include only the files relevant to the change; never stage secrets,
  keys, `.env`, or unrelated local state.
- Never force-push, rewrite shared history, or modify git config without being
  asked.

## Security

- Never log, print, or commit secrets, tokens, or credentials.
- Do not read `.env` files or store private keys.
- Treat personal/sensitive data carefully; default to not exposing it.

## Sparring & brainstorming

These are non-code activities (thinking through an approach before building).

- **Sparren** (thinking partner): give one recommendation per turn, no code or
  files, and help the user weigh trade-offs before anything is built.
- **Brainstorm**: go from idea to a tested decision before implementation;
  end with a decision summary and recommendations rather than code.
- When the user describes a direction, help them explore options and risks
  before jumping in, but do not stall work they have clearly asked to do.

## Skills

- This container ships with CEDA skills and auto-installs skills from
  `cedanl/.github`. Load the relevant skill for a task when one matches (e.g.
  building a Streamlit app, authoring CI, containerizing an app). Follow the
  skill's workflow.
