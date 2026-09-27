# CLAUDE.md

Guidance for Claude Code and other LLM agents working in this repo.

## What this repo is

A static site of one-page cheat sheets, guides and infographics for engineers: AI tools, backend engineering, and professional skills such as reading in English as a second language. It is hosted on **GitHub Pages from a public repo**. There is no build step, no framework, and no package manager. Every page is a single hand-written HTML file.

## Layout

```
index.html              Landing page. Renders cards from the SHEETS array in its <script>.
sheets/*.html           Published sheets, one self-contained file each.
private/                GITIGNORED. Employer-specific versions of sheets and denylist.txt.
scripts/check-public.sh Scans publishable files for terms in private/denylist.txt.
.nojekyll               Makes GitHub Pages serve files as they are. Do not delete it.
README.md               For humans. Keep its sheet table in sync with SHEETS.
```

## Hard rules

1. **The repo is public.** Never put employer-specific content in `index.html`, `sheets/`, `README.md` or this file. That includes internal tool, plugin or skill names, service names, ticket keys, internal hostnames, people's names, and anything else from a user's private setup. If a sheet needs such content, make a public version in `sheets/` and an internal version in `private/`.
2. **Run `./scripts/check-public.sh` before every commit** and fix every match. Never add denylist terms to a tracked file: the denylist lives only in `private/denylist.txt`.
3. **Never `git add -f` anything under `private/`.**
4. **Sheets must be self-contained.** Put all CSS and JS inline. Don't use CDNs, web fonts, external images or network requests. Pages must work from `file://` and offline. For icons, use inline SVG or text glyphs.
5. **Don't invent facts or statistics.** Check commands, flags and feature names against the tool itself (for Claude Code: `claude --help`, `/help`, the docs) before writing them. Put the tool version and date in the sheet's footer. Where content is opinion or judgment, such as a model-comparison bar, say so or keep it qualitative.

## Adding a sheet

1. Create `sheets/<kebab-case-name>.html` following the page conventions below. Starting from an existing sheet is easiest: `sheets/claude-code-cheat-sheet.html` for dense reference sheets, `sheets/ai-for-senior-backend-engineers.html` for narrative infographics.
2. Register it in the `SHEETS` array in `index.html`:
   ```js
   {
     file: "sheets/<name>.html",
     title: "Short card title",
     description: "One or two sentences.",
     type: "Cheat sheet",          // or "Infographic", "Guide", …
     tags: ["lowercase", "tags"],  // reuse existing tags where possible
     color: "teal",                // blue | purple | green | orange | teal | red | gold
     glyph: "{}",                  // 1–3 characters for the card
     date: "YYYY-MM-DD"
   }
   ```
   Cards sort by date, newest first. Cards less than 30 days old get a "New" label.
3. Add a row to the table in `README.md`.
4. Run `./scripts/check-public.sh`.

## Page conventions (every HTML file)

- **Head:** `<meta charset>`, `<meta name="viewport" content="width=device-width, initial-scale=1">`, a short `<title>` (2–4 words), and a `<meta name="description">`.
- **Colors:** define every color as a CSS custom property on `:root`. Define the dark theme twice, with identical values: under `@media (prefers-color-scheme: dark) { :root:not([data-theme="light"]) { … } }` and under `:root[data-theme="dark"] { … }`. Always give `body` an explicit background. Don't hard-code colors in components.
- **Theme toggle:** a button that sets `data-theme` on `<html>` and stores it under the localStorage key **`cheatsheets-theme`**. All pages share this key so the choice carries across the site. Wrap every localStorage call in `try/catch`.
- **Back link:** every sheet links to `../index.html` with the text "← All sheets". It sits in the sticky top bar on reference sheets, or at the fixed top-left on infographics.
- **Fonts:** system font stacks only (`ui-sans-serif, system-ui, …` and `ui-monospace, …`).
- **Layout:** content column up to about 1100–1240px, with 16px side padding. Grids use `repeat(auto-fill, minmax(min(100%, Npx), 1fr))` or collapse at ≤600–720px. There must be no horizontal scroll at phone width. Use `minmax(0, 1fr)` and `min-width: 0` on grid children, and `overflow-wrap: anywhere` on long code.
- **Print:** add an `@media print` block that hides controls, removes shadows, uses a white background and sets `break-inside: avoid` on cards.
- **Accessibility:** use semantic headings in order, `aria-label` on icon-only buttons and SVG diagrams (`role="img"`), and visible focus styles. Don't rely on color alone: keep text labels next to colored markers.
- **Reference-sheet extras:** a filter box (the `/` key focuses it and `Esc` clears it) that hides rows, cards and sections that don't match. Section anchors in a sticky nav.

## Writing style

- Plain English. Short sentences and concrete examples. Address the reader as "you".
- Each tool entry answers two questions: **what it does** and **when to use it**. Add a best-practice tip where one helps.
- Backend-flavored examples (Go, Postgres, Kafka, Kubernetes, observability) suit the audience. Keep them generic, not tied to any employer.
- Avoid hype and made-up numbers.

## Checking your work

- There are no tests. Open the page in a browser, or run `python3 -m http.server` and open `localhost:8000`. Check light mode, dark mode, a phone-width viewport and print preview.
- If there's no browser in your environment, at least check that the HTML is well-formed, for example `python3 -c "import html.parser,sys; html.parser.HTMLParser().feed(open(sys.argv[1]).read())" file.html`. Also check that every `SHEETS[].file` path exists.
- Run `./scripts/check-public.sh` last.

## Deploying

Pushing to `main` redeploys through GitHub Pages (Settings → Pages → Deploy from branch `main`, `/ (root)`). Relative links only: the site is served from `/<repo-name>/`, not the domain root, so never use links that start with `/`.
