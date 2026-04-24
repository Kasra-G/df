---
inclusion: always
---
# Implementation Discipline

- Before writing code, read relevant existing files to understand codebase patterns and conventions.
- When modifying a file, read it in full first — never assume structure from snippets or memory.
- Don't generate boilerplate, placeholder code, or scaffolding that isn't immediately needed.
- After making changes, verify consistency with surrounding code style (naming, error handling, patterns).
- If you're unsure about something, say so explicitly rather than guessing.
- After completing a task, verify the change works — build the package and run relevant tests before claiming done.
- When a command produces large output, extract the relevant portion with `tail`, `head`, or `grep` rather than dumping everything into context.
