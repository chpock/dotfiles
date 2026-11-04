---
name: ck-testing
description: Use when designing, writing, modifying, or reviewing tests and validation checks, including regression coverage added during implementation.
---

# ck-testing

## Test requirements, not implementation shape

- Base assertions on required behavior or independently established contracts. Derive expectations from the task, a consumer, a specification, or an agreed constraint—not merely from the code just written.
- Do not add implementation-mirroring checks: assertions that freeze the implementation's current text, syntax, structure, or chosen steps without an independent requirement. Using a parser, syntax tree, or snapshot instead of string matching does not justify them.
- Textual and structural assertions are appropriate for actual outputs, artifact formats, and agreed static constraints. Check only requirement-relevant properties; for source inspection, identify the independent static requirement being enforced.
- For behavioral coverage, exercise the relevant behavior and observe its results or required interactions. Meaningful white-box tests of required invariants or interactions are valid; merely asserting that their implementation exists is not. If behavior cannot be exercised, report the validation gap instead of substituting source-presence checks.

Before accepting a check, identify the requirement it protects and a violation it can detect. Changes that preserve that requirement should not invalidate the check.
