# Follow effects across repositories or services

Use this procedure when code behavior, dependencies or contracts cross those boundaries.

1. Establish the participating repositories/services and their roots from the task and existing configuration. In workspace mode, use `list_repos` only when membership or the repository selector is unknown. Bind each query to the intended member; for a single-repository server, use its supported member-local analysis and inspect external contracts separately.
2. Follow the relevant component/package relationships and cross-repository evidence from `get_context` or `get_risk` with `graph`. Inspect actual imports, API/schema contracts, event producers/consumers or generated clients behind the reported edges. Keep structural dependencies separate from historical co-change.
3. When core evidence is insufficient and the specialist operation is exposed **in an existing configured workspace**, use the one matching the task:
   - For downstream effects of a change, use `get_blast_radius`; inspect which consumer contract is affected rather than calling every reachable service broken.
   - For compliance with declared dependency rules, use `get_conformance`; verify the governing rules and investigate the reported edge/cycle. No rules or no executed analysis is not a demonstrated pass.
   - For a whole-workspace coupling/core/cycle assessment, use `get_architecture`. It is not a target-scoped map of modules within one repository.
4. Check the member coverage and stored-analysis provenance before drawing system-wide conclusions. Verify consequential edges and findings in current member source. If an operation or report is unavailable, finish the supported member checks and identify the cross-boundary gap.

Finish with the relevant producers/consumers and compatibility obligations accounted for, or the missing member/contract evidence named. These specialist tools are opt-in. Their absence does not authorize enabling tools, creating a workspace or rebuilding workspace analysis under the single-repository index-preparation grant.
