# Subagent Orchestration Guide

## Core Principles

1. **Start with a single agent.** Before orchestrating, ask: could one agent with the right tools handle this in one conversation? Orchestration is only worthwhile when agents have performance differentials across task regions.
2. **Deterministic orchestration > LLM-driven orchestration** for known workflows. Use fixed pipelines with predefined stages, not an LLM deciding on-the-fly what to delegate.
3. **Concurrency cap: 5 parallel subagents max** due to Bedrock rate limits. Design fan-out patterns around this constraint.

---

## Decision Framework

Three questions, in order:

1. **Are there 2+ independent work streams?** → Yes: parallelize with fan-out
2. **Is my context window getting full?** → Yes: delegate to a subagent to isolate context
3. **Can I do this directly in a few tool calls?** → Yes: just do it, no subagents

**Break-even rule:** Orchestration is worth it when the single-agent alternative would add >3-4 inference cycles to an already-long conversation. For short conversations (<20 turns), the overhead of spawning subagents usually exceeds the savings.

**Cost model clarification:** Attention is O(n²) in compute/latency, but API billing is O(n) in tokens. Orchestration saves latency on long conversations, not necessarily cost.

---

## Pipeline Patterns

### Research

**When:** 6+ independent searches across 3+ source types.
**When NOT:** 1-2 sources, <5 searches → single agent is faster.

| Stage | Parallelism | Agent |
|-------|-------------|-------|
| Investigate | Parallel (up to 5) | One per source type (code, docs, wiki, etc.) |
| Synthesize | Sequential | Single agent merges findings |
| Challenge (optional) | Sequential | Devil's advocate — only when output seen by >10 people or affects production |

**Iterative refinement:** After synthesis, check for gaps. If the first pass reveals you asked the wrong questions, run targeted follow-up searches — don't just accept incomplete results.

### Implementation

**Default:** Delegate to `gpu-coder` with a well-specified prompt. It handles the full SDLC (explore → plan → implement → test → CR).

**Use manual orchestration only when:**
- Task spans 3+ packages
- Parent context >50% full
- Implementation requires research the parent can't do inline

**Hard rule:** Never parallelize implementations that touch the same files.

### Code Review

**Default:** Single agent reviewing the full diff with a structured prompt covering security, patterns, and test coverage.

**Split by concern only when:** Diff exceeds 1000 lines or touches 10+ files.

**Contradiction resolution:** When split reviewers disagree, the aggregator must: (1) state both positions, (2) identify which is higher priority (security > style), (3) recommend a resolution. Don't silently drop one reviewer's feedback.

### Writing

**Default:** 2 stages max:
1. Parallel research (if needed)
2. Single `gpu-writing` agent does outline + draft + self-review

**4-stage pipeline only when:** Document exceeds 5000 words and context window limits force stage isolation.

### Operational Debugging

**This is the strongest use case for orchestration.** Logs, metrics, and recent changes are genuinely independent data sources.

| Stage | Parallelism | Agent |
|-------|-------------|-------|
| Investigate | Parallel (up to 5) | One per data source (logs, metrics, changes, config, alarms) |
| Diagnose | Sequential | Single agent synthesizes findings |

**Stop here.** Do NOT include "fix" in the pipeline. Present diagnosis to the user and get approval before any remediation.

---

## Role Selection

| Role | What it does | Use when |
|------|-------------|----------|
| `gpu-coder` | Full SDLC: explore, plan, implement, test, CR, iterate with reviewer | Scoped implementation with clear requirements |
| `gpu-research` | Deep search across multiple internal sources, synthesizes findings | Questions requiring 6+ searches across 3+ source types |
| `gpu-writing` | Long-form writing with Amazon narrative conventions | Documents, six-pagers, PR/FAQs, design docs |
| `gpu-multiagent-explorer` | Reads and maps codebase structure, finds patterns | "How does X work?" or "Where is Y implemented?" |
| `gpu-multiagent-librarian` | Searches docs, wikis, internal knowledge bases | "What does the team wiki say about X?" |

**Compound tasks:** Break into stages using the appropriate role per stage:
- "Research codebase + write design doc" → explorer (research) → gpu-writing (draft)
- "Investigate outage + fix" → parallel investigators (diagnose) → user approval → gpu-coder (fix)

---

## Prompt Engineering

### Template

Every subagent prompt should have these sections:

```
**Task:** What to do (1-2 sentences)
**Context:** File paths, constraints, conventions, user's original request, decisions already made, what was tried and failed
**Scope:** What's in/out of scope
**Output format:** Structure of expected response (markdown headers, JSON, etc.)
**Constraints:** What NOT to do, hard limits, negative examples
```

### Rules

- **200-400 words per subagent prompt.** Under-specifying → garbage. Over-specifying → ignored instructions or contradictions.
- **Constraints beat instructions.** Telling a subagent what NOT to do is more reliable than telling it what to do. Frame boundaries as constraints.
- **Request structured output.** JSON or markdown with headers. Limit each subagent to 500 words max output.

---

## Anti-Patterns

### 1. Context Loss
Subagents don't share the parent's conversation. Every subagent prompt must include:
- [ ] Relevant file paths
- [ ] Constraints and conventions (from AGENTS.md, steering docs)
- [ ] User's original request (verbatim)
- [ ] Decisions already made in this conversation
- [ ] What was tried and failed

### 2. Over-Orchestration
Don't use subagents when the task has a single logical thread of execution. If there's only one work stream, a subagent adds overhead with no benefit.

### 3. Prompt Size Mismatch
Under-specifying causes garbage. Over-specifying (>500 words) causes the subagent to ignore parts or get confused by contradictions. Target 200-400 words.

### 4. Output Explosion
When 3 subagents each return 2000 tokens, the parent has 6000+ tokens to process. Mitigations:
- Limit each subagent to 500 words max
- Request structured output with headers
- If aggregated output exceeds 3000 tokens, add a synthesis subagent to compress before returning to parent
- If aggregated output would exceed 30% of remaining context, compress first

### 5. Valueless Devil's Advocate
Only add a devil's advocate stage when:
- Output will be seen by >10 people
- Output affects production systems
- The decision is expensive to reverse

If criteria for "good" aren't explicit and measurable, the reviewer has nothing to review against.

---

## When Things Go Wrong

Subagents fail. MAS correctness can be as low as 25% on complex tasks. Plan for it.

### Common Failure Modes

| Failure | Symptom | Response |
|---------|---------|----------|
| Premature termination | Subagent returns partial results, claims done | Retry with explicit "you must cover X, Y, Z" |
| Information withholding | Subagent found relevant info but didn't return it | Retry with "include all findings, even uncertain ones" |
| Incorrect verification | Subagent claims success but output is wrong | Verify output yourself before using it |
| Contradictory results | Two subagents disagree on facts | Present both to user with evidence, let them decide |

### Recovery Protocol

1. **Retry with refined prompt** — more specific scope, explicit output requirements. Max 2 retries.
2. **Try a different role** — if gpu-multiagent-explorer failed, try gpu-research, or vice versa.
3. **Do it yourself** — fall back to the parent agent handling it directly.
4. **Escalate to user** — when subagents return contradictory results, the task is ambiguous, or you've exhausted retries.

**Hard rule:** Never retry more than twice. After 2 failures, switch strategy.

### When to Pause and Ask the User

- Before executing any fix in production
- When subagents return contradictory results
- When the task is ambiguous and subagents are guessing
- When you're about to spawn >3 parallel subagents for a task the user described casually
