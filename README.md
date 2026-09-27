# Engineering Cheat Sheets

One-page cheat sheets, guides and infographics for engineers: working with AI, backend engineering, and professional skills such as reading and communicating in English. Each sheet is a single, self-contained HTML file. Sheets work offline, print cleanly, work on phone screens, and support light and dark mode.

**Live site:** `https://<your-username>.github.io/<repo-name>/`. Replace this with your URL after the first deploy.

## Sheets

| Sheet | Type | What it covers |
|---|---|---|
| [Active reading in a second language](sheets/active-reading.html) | Guide | A reading routine, a marking code, handling unknown words, a phrasebook method, and turning reading into speaking and writing, for non-native English speakers |
| [Claude Code: every tool and when to use it](sheets/claude-code-cheat-sheet.html) | Cheat sheet | Surfaces, models and effort, permission modes, context control, skills, hooks, MCP, parallel and background work, review commands, principles, workflow recipes |
| [How AI helps a senior backend engineer](sheets/ai-for-senior-backend-engineers.html) | Infographic | Productivity and quality gains across the backend lifecycle, the specify–delegate–verify loop, what to delegate and what to keep, risks and guardrails |

The [landing page](index.html) lists every sheet, with search and tag filters.

## View locally

Open `index.html` in a browser. No build step and no server are needed.

On WSL, use this path from Windows:

```
\\wsl.localhost\<distro>\home\<user>\<path-to-repo>\index.html
```

You can also serve the folder with `python3 -m http.server 8000` and open http://localhost:8000.

## Add a sheet

1. Put the HTML file in `sheets/`, with a lowercase, hyphenated name (for example `sheets/postgres-tuning.html`).
2. Add an entry to the `SHEETS` array near the bottom of `index.html`.
3. Add a row to the table above.
4. Run `./scripts/check-public.sh` and fix anything it reports.
5. Commit and push. GitHub Pages redeploys automatically.

See [CLAUDE.md](CLAUDE.md) for the full design and content conventions.

## Private content

This repo is **public**. Anything specific to an employer (internal tool names, plugin names, ticket keys, hostnames) goes in `private/`, which is gitignored. `scripts/check-public.sh` checks every publishable file against a denylist of terms kept in `private/denylist.txt`.

## Deploy (GitHub Pages)

One-time setup:

```bash
git init -b main
git add .
./scripts/check-public.sh && git commit -m "Initial cheat sheets"
git remote add origin git@github.com:<your-username>/<repo-name>.git
git push -u origin main
```

Then on GitHub, go to **Settings → Pages → Build and deployment**. Set Source to *Deploy from a branch*, choose `main` and `/ (root)`, and save. The site is live within a minute or two.

The `.nojekyll` file tells GitHub Pages to serve the files as they are, without Jekyll processing.
