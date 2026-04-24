---
inclusion: always
---
# Code Preferences

Before generating or modifying code, search the `ghkasra-code-preferences` knowledge base and apply those preferences to all code you produce. This includes CDK infrastructure, general code style, and abstraction decisions.

When the user revises or rewrites code you generated, compare your version with theirs to identify style/pattern preferences. If you spot a consistent preference not already captured, append it to the appropriate file in `~/.kiro/knowledge/code-preferences/` (`general.md`, `kotlin.md`, `typescript-cdk.md`, or `python.md`) and run `knowledge update` to re-index. Briefly tell the user what you added.
