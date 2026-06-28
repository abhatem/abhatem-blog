# AGENTS.md — abhatem.com

Working notes for AI agents (and humans) operating in this repo. This is the
source for **abhatem.com**, Abdullah Al-Hatem's personal site, built with the
[Zola](https://www.getzola.org/) static site generator and deployed on Netlify.

There are two older, narrower context files — `Qwen.md` and `gemini.md`. This
file supersedes both for general work; keep them in sync if you change anything
structural.

---

## 1. Tech stack

| Concern        | Choice                                                                 |
|----------------|------------------------------------------------------------------------|
| Generator      | Zola (Netlify pins `ZOLA_VERSION = 0.22.1` in `netlify.toml`; matches `brew install zola`) |
| Theme          | Custom, derived from the retro [zola.386](https://github.com/lopes/zola.386) theme by lopes |
| CSS            | Bootstrap 2-era (`static/css/bootstrap*.css`) + `sass/site.scss` (compiled by Zola → `site.css`) |
| JS             | jQuery + Bootstrap 2 plugins + Zola search (`elasticlunr`)              |
| Hosting        | Netlify; auto-deploys on push to `master`. Build command: `zola build`  |
| Analytics      | Plausible (self-hosted at `plausible.abhatem.com`), wired in `templates/index.html` |
| Comments       | Disqus, **disabled** (config `disqus` is commented out); per-page `extra.comments` flag exists but is inert |

Local dev: `zola serve` → http://127.0.0.1:1111. Build: `zola build` → `public/`
(gitignored). Local and Netlify are both on **0.22.x** — keep them in sync if you
bump one. Syntax highlighting uses the 0.22+ "Giallo" engine, configured under
`[markdown.highlighting]` in `config.toml` (`theme = "monokai"`, `style = "inline"`);
a theme is **required** in 0.22+, and the pre-0.22 `highlight_code` / `highlight_theme`
keys (and the old `kronuz` theme) no longer exist.

---

## 2. Repository layout

```
.
├── config.toml            # Site config: base_url, taxonomies, nav menu, social, i18n labels
├── netlify.toml           # Netlify build + (currently no) redirects; pins Zola 0.22.1
├── theme.toml             # Theme metadata (cosmetic)
├── compress_images.sh     # Optional image-compression helper (jpegoptim/optipng)
├── content/               # All Markdown content (see §3)
├── templates/             # Tera templates (see §4)
├── sass/site.scss         # Site styles (compiled to site.css; compile_sass = true)
├── static/                # Verbatim-copied assets: css/, js/, images/ (favicons, manifest)
├── assets/                # Source thumbnails (xcf/png) — NOT auto-published
├── README.md              # Public-facing readme
├── Qwen.md / gemini.md    # Older agent context files
└── AGENTS.md              # This file
```

`.gitignore` excludes `public/`, `zola`, `static/processed_images`, `build`,
`.DS_Store`, and `content/.original_images/` (image-compression backups).

---

## 3. Content model (important — read before editing content)

**Content is split into two sections: `projects/` and `blog/`.** Each has its
own `_index.md` (paginated, `sort_by = "date"`, `template = "section.html"`,
`page_template = "page.html"`). The root `content/_index.md` is now a thin
landing page (no pagination) rendered by `index.html`, which surfaces the latest
from both sections via `get_section`.

> History: until the projects/blog split, *all* posts lived in the root section
> and "project vs blog" was distinguished only by the `categories = ["projects"]`
> taxonomy. See `plans/projecs-blog-split/PLAN.md` for the migration.

### Two kinds of content pages
- **Page bundles** (most posts): a folder with `index.md` + colocated images,
  e.g. `content/RoboLens/index.md` + `logo.png`. This is the preferred form.
- **Flat files**: a single `.md` directly in `content/`, e.g. `sem-nulla.md`.

### Front matter conventions (TOML, between `+++` fences)
```toml
+++
title = "..."
description = "..."          # shown on cards and as og:description
date = 2025-05-01            # REQUIRED for the post to appear (see gotcha below)
draft = false
slug = "robolens"            # explicit → drives the URL's last segment

[taxonomies]
categories = ["projects"]    # 0-or-1 used meaningfully; "projects" marks a project
tags = ["robotics", "..."]

[extra]
comments = true              # inert (Disqus disabled)
lang = "pt"                  # mostly "pt" copied from theme; cosmetic only here
image = "logo.png"           # card thumbnail; colocated filename OR full URL
+++
```

### How "project" vs "blog post" is distinguished
**By which section folder the post lives in** (`content/projects/` vs
`content/blog/`). The `categories = ["projects"]` taxonomy is still present on
project posts (and still powers `/categories/projects/`), but folder membership
is now the source of truth. To add a project, drop a page bundle under
`content/projects/`; for a blog post, under `content/blog/`.

### Current content inventory
| File (page bundle)                                      | Live URL                                  | categories          | Section  |
|--------------------------------------------------------|-------------------------------------------|---------------------|----------|
| `projects/RoboLens/index.md`                           | `/projects/robolens/`                     | projects            | Projects |
| `projects/lehelpinghand/index.md`                      | `/projects/lehelpinghand/`                | projects, hackathon | Projects |
| `projects/talking_cat/index.md`                        | `/projects/talking-cat/`                  | projects            | Projects |
| `blog/cmake_build_for_cyclone_physics/index.md`        | `/blog/cmake-build-for-cyclone-physics/`  | showing off         | Blog     |
| `blog/window_managers/index.md`                        | `/blog/window-managers/`                  | takes               | Blog     |
| `blog/parsec-setup/index.md`                           | `/blog/parsec-setup/`                     | tech                | Blog     |
| `blog/emacs_post/index.md`                             | `/blog/emacs-vscode-journey/`             | takes               | Blog     |
| `pages/about.md`                                        | `/about/` (via `path="about"`)            | —                   | Page     |

Every moved post carries an `aliases = ["/old-flat-url/"]` line so its previous
top-level URL 301-redirects to the new nested one.

> Content hygiene aside: `blog/cmake_build_for_cyclone_physics/` contains the
> *same image assets* as `blog/window_managers/` (gifs, `window_bush.png`, etc.)
> — likely an old copy-paste artifact. Not load-bearing, but worth a cleanup
> someday.

---

## 4. Templates (Tera)

```
templates/
├── index.html              # BASE layout (full <html>, nav, header, sidebar, footer)
│                           #   + default `block main` = the HOMEPAGE LANDING (latest
│                           #     Projects as cards + latest Blog as a list, via get_section)
├── section.html            # Listing template for /projects and /blog (paginated post_max cards)
├── page.html               # Single post; extends index.html; overrides breadcrumb/header/meta/main
├── macros.html             # post_max (rich card), post_min (date | title line), paginator
├── about.html              # EMPTY / dead — about.md renders via page.html, not this
├── 404.html
├── categories/
│   ├── list.html           # all categories; extends index.html
│   └── single.html         # one category's pages; uses post_min
├── tags/
│   ├── list.html           # all tags
│   └── single.html         # one tag's pages
└── shortcodes/
    ├── youtube.html        # {{ youtube(id="VIDEO_ID") }}  → responsive iframe
    └── resize_image.html   # {{ resize_image(path=..., width=, height=, op=, caption=, figure=) }}
```

### Template inheritance & lookup facts that matter
- **`index.html` is the base** that every other template `extends`. It owns the
  `<html>`, nav bar, the `header`/`meta`/`breadcrumb`/`main`/`sidebar` blocks,
  and the footer.
- Zola renders the **root section** (`content/_index.md`) with `index.html`.
  Any **other section** (`content/<x>/_index.md`) renders with `section.html`
  **which does not exist yet** — so creating subsections requires adding a
  `templates/section.html` (or per-section `template = ...`).
- The sidebar (search box + Categories + Tags lists) lives in `index.html`'s
  `block sidebar` and is inherited everywhere.
- The nav menu is driven by `config.extra.zola386_menu` (a list of
  `{ path, name }`). It's rendered in `index.html`'s `block navbar`.

### Known template gotchas (do not propagate these into new code)
- **Card thumbnails use `page.permalink ~ page.extra.image`** in `post_max`
  (with a `containing("://")` branch for full URLs). This was changed from the
  old slug-based `get_url(path=page.slug)`, which 404'd once posts moved into
  subsections — don't revert it.
- `macros.html` has a stray `c` after `{% if page.extra.author %}` (line ~14) —
  harmless typo that prints a literal "c".
- `config.toml` `base_url` has a trailing slash, and the nav builds links as
  `{{ config.base_url }}/{{ item.path }}` → produces a harmless `//` double
  slash. Don't "fix" by adding more slashes elsewhere.

---

## 5. Build / behavior gotchas

1. **Dateless pages vanish from listings.** With `sort_by = "date"`, Zola moves
   pages without a `date` into `ignored_pages` — they still build at their URL
   but never appear in `section.pages`/pagination. Always give a new post a
   `date` or it won't show in its section. (This bit the emacs post, whose date
   was commented out; it's now set.)
2. **Moving a page changes its URL.** URL = parent section path + `slug`.
   Preserve old URLs with Zola `aliases = ["/old/"]` front matter (generates
   redirect stubs) — that's what every moved post does.
3. **Slugify rewrites `_` → `-` in URLs.** There's no `[slugify]` override in
   `config.toml`, so Zola's default `paths = "on"` applies: a `slug` like
   `cmake_build_for_cyclone_physics` is served at
   `/cmake-build-for-cyclone-physics/` (hyphens), **not** the underscore form.
   When writing `aliases`, match the *hyphenated* old URL, not the raw slug.
4. **`generate_rss` is commented out** in `config.toml`, but taxonomies declare
   `rss = true`, so only per-taxonomy feeds generate. Enable `generate_rss` for
   a site-wide feed.
5. **Search index** (`build_search_index = true`) is rebuilt on every build;
   `search_index.en.js` + `elasticlunr.min.js` are loaded in `index.html`.

---

## 6. Common tasks

- **New post:** create a page bundle under the right section —
  `content/blog/<folder>/index.md` or `content/projects/<folder>/index.md` —
  with the front matter in §3 (don't forget a `date`). Colocate images in the
  same folder; reference them with `![alt](logo.png)` or the `resize_image`
  shortcode. Set `extra.image` to a colocated filename for the card thumbnail.
- **Embed YouTube:** `{{ youtube(id="VIDEO_ID") }}`.
- **Change nav:** edit `config.extra.zola386_menu` in `config.toml`.
- **Change styles:** edit `sass/site.scss` (auto-compiled). Avoid editing
  `static/css/bootstrap*.css` (vendor).
- **Compress images:** `./compress_images.sh` (needs `jpegoptim`, `optipng`;
  backs up originals to `content/.original_images/`).
- **Deploy:** push to `master`; Netlify builds and publishes automatically.

---

## 7. Plans

- `plans/projecs-blog-split/` — **DONE.** Restructured the site into separate
  **Projects** and **Blog** sections with a landing homepage that surfaces both.
  Kept as a record of the migration.
