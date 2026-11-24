# Language of work and operator discussion

The operator gives tasks in Russian and has sometimes received work in Russian without asking for it. Discussing a task in Russian should not require adding “write it in English” to every request. The [language rules in the shared `AGENTS.md`](../../agent/AGENTS.md#working-style) distinguish the discussion from the work.

## Why the distinction is about purpose

“Work products” can suggest only finished project files. Naming files the agent creates or edits covers a draft plan outside the repository as well as a maintained project document, without listing every kind of artifact. A plan supplied in full in a chat reply still defaults to English. The surrounding explanation and a `todowrite` list used to show progress may be in Russian.

## Where the previous wording failed

During a Repowise AUR update on 2026-11-24, the session included the instruction “all work except discussion with the operator.” The operator’s requests were written in Russian; neither specified a language for the report. The agent created a Markdown review report outside the repository, wrote it in Russian from the first line, and added its validation results in Russian. It later linked the report from a Russian completion message. The file was new, and there was no evidence of a project rule, comparable report, or locale marker calling for Russian. The written artifact in this case was a report; the execution plan was a `todowrite` list.

The agent later suggested it may have treated the report as part of its message to the operator. It recorded no reason for the choice at the time. Writing a document **for** the operator does not make the document part of the conversation: the message linking to the report could be in Russian, but the report itself should have been in English.

## What establishes another language

An explicit language request takes priority for the work it names. “Discuss the plan in Russian” does not specify the plan’s language; “write the plan in Russian” does. Requiring an explicit request for every exception, however, would put English text in existing translations. Conversely, referring to an “established language” without saying what establishes it leaves room to mistake the operator’s Russian for a project convention.

The evidence must apply to the particular work. The text being edited can establish the language on its own: a new paragraph in a German README belongs in German even without a comparable file or locale marker. A project rule can set the language even for a new document. Comparable guides in the same documentation set can show that convention; an unrelated translation cannot. In an English-language project, `locales/ru.json` calls for Russian strings, not Russian code comments.

A useful check is to translate the request into English without changing its meaning. Would the reason to use Russian remain? A request for a Russian plan or a `ru` locale marker survives that check. For a new project or a standalone plan with neither an explicit language request nor such evidence, English is required.

Agent-to-agent communication stays separate because it has no language exceptions: even when the requested result is a Russian translation, the assignment to a subagent is in English.
