# Pi theme: Gruvbox dark hard

The selected theme is [`gruvbox-dark-hard.json`](gruvbox-dark-hard.json), enabled by `theme: "gruvbox-dark-hard"` in the [shared settings](../../docs/settings.md#interface-and-terminal). This file owns the palette's motivation and renderer boundaries; it does not redefine layout, model settings or tool permissions.

## Motivation

Use one fixed, warm dark palette for extended code/tool conversations. Subdued surfaces separate messages and execution states without making every panel bright; readable light foregrounds carry content, secondary information recedes, and saturated colors mark useful structure and status. Choosing a named palette keeps those relationships stable instead of deriving a different palette from each terminal's ANSI colors.

The `hard` base is `#1d2021`, not a requirement that every panel use the same background. Nearby Gruvbox grays distinguish surfaces. The configuration below describes the existing color design; selecting this theme does not itself change what any component renders.

## Color design

| Group | Selected roles and motivation |
| --- | --- |
| Base and surfaces | `export.pageBg` uses the hard base. `userMessageBg`/`toolSuccessBg` use `dark0`; `customMessageBg`/`toolPendingBg` use `dark0_soft`; selection uses `dark1`. Small lightness differences separate content/state without large colored fills. |
| Main and secondary text | `text`, message text and `toolOutput` use warm `light1`; `muted` uses `light4`, while `dim` and `thinkingText` use `gray`. Keep primary content legible and reduce the visual weight of metadata and visible thinking. |
| Focus and borders | Orange `accent` draws attention to interaction; light `borderAccent` distinguishes focused borders, while darker `border`/`borderMuted` keep passive framing quiet. |
| Status and differences | Green success/added lines and red errors/removed lines follow familiar status conventions. Orange warnings remain distinct. `toolErrorBg` is a subdued red-gray (`#322929`), not a solid bright-red panel. |
| Tool hierarchy | Aqua `toolTitle` makes operations easy to locate; light `toolOutput` carries their content. Secondary paths/parameters use the renderer's `muted`/`dim` roles. A renderer may reuse a role in more than one context. |
| Markdown | Blue headings/list bullets, green links, aqua URLs and yellow inline code separate structure from prose. Quotes, rules and block borders use quieter grays. |
| Syntax | Red keywords, green functions, blue variables, yellow strings, purple numbers, aqua types and orange operators make code categories distinguishable within the same palette; comments stay gray. |
| Thinking/editor modes | `thinkingOff` through `thinkingMax` distinguish the selected effort level; `bashMode` is blue. These are editor-mode cues, not a universal ranking of reasoning quality. |
| Search and scrollbar | Yellow search matches pair with hard-dark text; a light scrollbar thumb on a darker track remains visible without competing with messages. |
| HTML export | Dark `pageBg`, `cardBg` and `infoBg` preserve the surface hierarchy outside the terminal. These roles are export backgrounds, not a native Pi command to repaint the terminal. |

`vars` retains reusable Gruvbox colors; `colors` assigns semantic roles and `export` assigns HTML surfaces. `appearance: "dark"` declares the intended background family. `$schema` supplies editor validation/completion. Palette values live only in the JSON; this guide explains their relationships rather than copying every value into a second configuration.

## Effective rendering boundaries

- Native Pi 1.3.0 ordinary assistant prose and editor input use the terminal's default foreground; ordinary assistant messages also keep the terminal background. The theme's `text` role does **not** automatically recolor all prose. Native visible thinking explicitly uses `thinkingText`; native user and tool components apply their own theme roles.
- The selected local `pi-toolview` package can apply `colors.text` as the terminal default foreground and `export.pageBg` as its default background when its **Set terminal colors from Pi theme** preference is enabled for a fixed theme. This is extension behavior, separate from native HTML export and theme selection. If it is disabled or unsupported, the terminal's own defaults still matter.
- Compact toolview summaries use `toolTitle` for the operation, `muted` for the main object/path and `dim` for secondary arguments. They need not draw the native filled tool box. Full cards can use `toolPendingBg` and independent diff/syntax projections. Theme role names alone therefore do not establish which pixels or glyphs will change.
- Terminal color support and syntax-highlighting preferences can change the effective rendering. This design does not claim a measured contrast/accessibility result or that every renderer consumes every role.

When changing a color, inspect its current rendering sites and neighboring foreground/background roles first. Keep the palette, terminal-default application and renderer-specific styling separate; a theme change should not be used to conceal a renderer defect.

## References

- Pi 1.3.0 `docs/themes.md` and `dist/modes/interactive/theme/{theme.js,theme-tokens.js}` under `~/.pi/agent/install/releases/1.3.0/node_modules/@earendil-works/pi-coding-agent/`.
- Native `dist/modes/interactive/components/{assistant-message,user-message,tool-execution}.js` in the same release.
- [Toolview behavior](../../../../../w/projects/pi-toolview/README.md), `src/{terminal-colors,index,card-theme,diff-palette}.ts` in that checkout. Recheck actual renderers when updating packages; old token mappings alone are not rendering evidence.
- [Documentation map](../../docs/CONTEXT.md).
