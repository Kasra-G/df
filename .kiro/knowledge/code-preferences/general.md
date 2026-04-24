# General Code Preferences

- Minimal code — don't generate anything that isn't immediately needed
- Defer abstraction until you have 3 duplications (rule of three) — don't extract prematurely
- Validate inputs at system boundaries (API handlers, CLI entry points), trust data internally
- Use domain-specific types over primitives for IDs, amounts, timestamps (e.g., `OrderId` over `String`)
- Use structured logging (key-value pairs) over unstructured string messages
- Include correlation/request IDs in log entries for traceability
- Separate refactoring from behavioral changes into different CRs
- Write doc comments on public APIs — skip them on private/internal methods unless the logic is non-obvious
- Use `TODO(username)` with a ticket link for intentional shortcuts — never bare `TODO`
- Pin dependency versions explicitly — avoid floating ranges in production code
- When adding a new dependency, check if an existing dependency already provides the functionality
