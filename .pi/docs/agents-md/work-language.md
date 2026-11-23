# Language of work and operator discussion

The operator gives tasks in Russian and has sometimes received work in Russian without asking for it. Discussing a task in Russian should not require adding “write it in English” to every request. The [language rules in the shared `AGENTS.md`](../../agent/AGENTS.md#working-style) distinguish the discussion from the work.

## Why the distinction is about purpose

“Work products” can suggest only finished project files. A working plan or report is still work when it is saved outside the repository. A plan delivered in a chat reply is also work: the plan can be in English and the surrounding explanation in Russian. Listing artifact types or writing separate rules for project files and task materials would make the always-loaded instructions longer each time a new case appeared.

## What establishes another language

An explicit language request takes priority for the work it names. “Discuss the plan in Russian” does not specify the plan’s language; “write the plan in Russian” does. Requiring an explicit request for every exception, however, would put English text in existing translations. Conversely, referring to an “established language” without saying what establishes it leaves room to mistake the operator’s Russian for a project convention.

The evidence must apply to the particular work. The text being edited can establish the language on its own: a new paragraph in a German README belongs in German even without a comparable file or locale marker. A project rule can set the language even for a new document. Comparable guides in the same documentation set can show that convention; an unrelated translation cannot. In an English-language project, `locales/ru.json` calls for Russian strings, not Russian code comments.

A useful check is to translate the request into English without changing its meaning. Would the reason to use Russian remain? A request for a Russian plan or a `ru` locale marker survives that check. For a new project or a standalone plan with no such evidence, the default is English.

Agent-to-agent communication stays separate because it has no language exceptions: even when the requested result is a Russian translation, the assignment to a subagent is in English.
