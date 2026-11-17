# Audit or update literal references

## Identify what must resolve

Identify the source documents/files, literal target and applicable renderer or import syntax. For a move, rename or deletion, preserve the old path/name and inspect reverse references while it still resolves. Use AFT directly for already-bounded occurrences and for comparing the meaning of prose claims.

## Find the references needing attention

1. To find documents naming an existing file, request targeted `get_context` with `doc_drift`. Inspect the returned documents: a basename/stem mention is a lead, not a resolved dependency or proof that the document explains that file.
2. For a Markdown link/anchor/reference audit, request the `get_health` `doc_drift` view in the relevant scope. It can identify unresolved local paths, GitHub-style anchors and recognized command/symbol references. Use the reported source location to inspect the actual text and target.
3. For imports/exports or literal resource wiring, apply `references/source-analysis.md`. Use the supported file/import relations and inspect the concrete use sites. Dedicated Ansible, HTML script/link and Godot-resource extraction does not provide general configuration, DOM or runtime semantics.
4. If the analyzer cannot cover the reference, use current-text/source inspection or the appropriate renderer/link check. External URLs, unsupported markup and semantic agreement between paragraphs are not answered by Repowise's program graph or Markdown reference analysis.

## Verify, repair and recheck

1. Check each relevant finding against current content and the actual renderer/import rules. Separate stale references from deliberate examples and historical text before changing them.
2. Preserve the reported coverage limits. MkDocs, Docusaurus and Jekyll anchor semantics are unsupported in their governed subtrees; external URLs, reStructuredText/AsciiDoc and excluded historical/vendor/test documents are not a clean-reference result. Missing stored `doc_drift` data is an unavailable analysis, not permission to recompute everything.
3. Update the assigned references. After a move/rename/deletion, inspect both old and new literals in the current tree; empty reverse results for a deleted target cannot prove that no references remain.
4. Check that the changed references resolve and that any affected prose still states the intended meaning. Reuse or rerun only the analysis whose evidence the edits invalidated; apply `references/index-lifecycle.md` only for a genuine index dependency.

Finish with the requested references resolved or their remaining failures explained, and name material uncovered scope separately from verified results.
