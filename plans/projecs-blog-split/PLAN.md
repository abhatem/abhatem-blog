# Plan: Split the site into Projects and Blog sections

> **STATUS: ✅ Implemented** on branch `projects-blog-split` and verified with a
> local Zola 0.14.0 build (matching Netlify's pinned version). Kept as a record.
>
> **Correction discovered during implementation:** Zola's default slugify
> rewrites `_` → `-` in URLs, so the real pre-existing URLs were hyphenated
> (`/cmake-build-for-cyclone-physics/`, `/window-managers/`,
> `/emacs-vscode-journey/`), **not** the underscore forms. The `aliases` below
> were set to the hyphenated old URLs accordingly. See AGENTS.md §5.

**Goal:** Restructure abhatem.com so **Projects** and **Blog** are two separate
sections, each with its own listing page, and replace the homepage with a
landing page that surfaces the latest from *both*.

**Read first:** `AGENTS.md` (repo root) for how this Zola site is wired. This
plan assumes that context.

> ⚠️ This plan is written to be executed step by step by an implementing agent.
> Do the steps **in order**. Do not skip the verification step (Step 9). After
> each major step, a `zola build` (or `zola serve`) must still succeed.

---

## Decisions already made (do not re-litigate)

1. **Homepage** → a **landing page** showing "Latest Projects" and "Latest
   Posts" side by side, each linking to its full section.
2. **URLs** → adopt **nested URLs** (`/projects/<slug>/`, `/blog/<slug>/`) and
   **preserve the old flat URLs with redirects** (Zola `aliases`).
3. **Classification** → **strict**: only the three posts already tagged
   `categories = ["projects"]` become Projects. Everything else real becomes
   Blog.

### Classification table (the source of truth for moves)

| Current location                          | → New location                                          | Old URL → keep alias |
|-------------------------------------------|---------------------------------------------------------|----------------------|
| `content/RoboLens/`                       | `content/projects/RoboLens/`                            | `/robolens/`         |
| `content/lehelpinghand/`                  | `content/projects/lehelpinghand/`                       | `/lehelpinghand/`    |
| `content/talking_cat/`                    | `content/projects/talking_cat/`                         | `/talking-cat/`      |
| `content/cmake_build_for_cyclone_physics/`| `content/blog/cmake_build_for_cyclone_physics/`         | `/cmake_build_for_cyclone_physics/` |
| `content/window_managers/`                | `content/blog/window_managers/`                         | `/window_managers/`  |
| `content/parsec-setup/`                   | `content/blog/parsec-setup/`                            | `/parsec-setup/`     |
| `content/emacs_post/`                     | `content/blog/emacs_post/`                              | `/emacs_vscode_journey/` |
| `content/nvim/`                           | **delete** (broken duplicate of emacs post)            | — (Step 1)           |
| `content/lorem-ipsum/`                    | **delete** (theme demo)                                 | — (Step 1)           |
| `content/sem-nulla.md`                    | **delete** (theme demo)                                 | — (Step 1)           |
| `content/unlisted.md`                     | **delete** (theme demo)                                 | — (Step 1)           |
| `content/pages/about.md`                  | **unchanged** (stays at `/about/`)                      | —                    |

> Slugs do **not** change — only the section prefix is added. That is what makes
> the alias = old flat URL work.

---

## Step 0 — Safety checkpoint

```bash
cd /Users/abhatem/workspace/abhatem-blog
git status                      # should be clean
git checkout -b projects-blog-split
zola build                      # confirm the site builds BEFORE changes
```
If `zola build` fails before you start, stop and report it — do not proceed.

---

## Step 1 — Delete dead/demo content (confirm with the user first)

These are zola.386 theme leftovers / broken drafts. Deleting them keeps the new
sections clean. **If the user has not explicitly approved deletion, instead move
them to a `content/_archive/` folder (no `_index.md`, so they won't list) and
note it — do not silently keep them in the new sections.**

```bash
git rm -r content/nvim
git rm -r content/lorem-ipsum
git rm content/sem-nulla.md
git rm content/unlisted.md
```

---

## Step 2 — Create the two new sections

Create the section index files. These use the new `section.html` template added
in Step 6.

**`content/projects/_index.md`**
```toml
+++
title = "Projects"
description = "Things I've built — robots, hardware hacks, and software."
sort_by = "date"
paginate_by = 20
template = "section.html"
page_template = "page.html"
insert_anchor_links = "none"
+++
```

**`content/blog/_index.md`**
```toml
+++
title = "Blog"
description = "Notes, takes, and write-ups on what I'm learning."
sort_by = "date"
paginate_by = 20
template = "section.html"
page_template = "page.html"
insert_anchor_links = "none"
+++
```

> `page_template = "page.html"` makes every page inside the section render with
> the existing single-post template. `template = "section.html"` is explicit so
> behavior doesn't depend on Zola's default lookup.

---

## Step 3 — Move the content into the sections

Use `git mv` so history is preserved. Move whole folders (page bundles carry
their images with them).

```bash
# Projects
git mv content/RoboLens            content/projects/RoboLens
git mv content/lehelpinghand       content/projects/lehelpinghand
git mv content/talking_cat         content/projects/talking_cat

# Blog
git mv content/cmake_build_for_cyclone_physics content/blog/cmake_build_for_cyclone_physics
git mv content/window_managers     content/blog/window_managers
git mv content/parsec-setup        content/blog/parsec-setup
git mv content/emacs_post          content/blog/emacs_post
```

After this, `content/` at the top level should contain only: `_index.md`,
`projects/`, `blog/`, and `pages/`.

---

## Step 4 — Add redirect aliases + fix the emacs date

For **each moved post**, add an `aliases` line to its `index.md` front matter so
the old flat URL keeps working (301-style HTML redirect generated by Zola).

Add inside the top-level front matter (not under `[taxonomies]`/`[extra]`):

| File                                                         | Add this line                                  |
|-------------------------------------------------------------|------------------------------------------------|
| `content/projects/RoboLens/index.md`                        | `aliases = ["/robolens/"]`                     |
| `content/projects/lehelpinghand/index.md`                   | `aliases = ["/lehelpinghand/"]`                |
| `content/projects/talking_cat/index.md`                     | `aliases = ["/talking-cat/"]`                  |
| `content/blog/cmake_build_for_cyclone_physics/index.md`     | `aliases = ["/cmake-build-for-cyclone-physics/"]` |
| `content/blog/window_managers/index.md`                     | `aliases = ["/window-managers/"]`              |
| `content/blog/parsec-setup/index.md`                        | `aliases = ["/parsec-setup/"]`                 |
| `content/blog/emacs_post/index.md`                          | `aliases = ["/emacs-vscode-journey/"]`         |

Example — `content/projects/RoboLens/index.md` top of front matter becomes:
```toml
+++
title = "RoboLens, My Master's Thesis"
description = "RoboLens is a way to control robots using HoloLens based on WoT (Web of Things) protocols."
date = 2025-05-01
draft = false
slug = "robolens"
aliases = ["/robolens/"]
...
```

**Also fix the emacs post date** so it actually appears in the Blog listing.
In `content/blog/emacs_post/index.md`, the `date` is commented out:
```toml
#date = 2024-04-27
```
Change it to a real, uncommented date (use the original if known, otherwise pick
a sensible one and flag it for the user):
```toml
date = 2024-04-27
```

---

## Step 5 — Fix the thumbnail URL bug in `macros.html`

`post_max` currently builds image URLs from the slug, which breaks once posts
live in subsections. Open `templates/macros.html` and replace this block:

```jinja
  {% if page.extra.image %}
  <img src="{{get_url(path=page.slug)}}/{{page.extra.image}}"></img>
  {% endif %}
```

with a version that uses the page's real permalink and passes full URLs through:

```jinja
  {% if page.extra.image %}
    {% if page.extra.image is containing("://") %}
    <img src="{{ page.extra.image }}"></img>
    {% else %}
    <img src="{{ page.permalink | safe }}{{ page.extra.image }}"></img>
    {% endif %}
  {% endif %}
```

> `page.permalink` ends in `/`, so for RoboLens it yields
> `https://abhatem.com/projects/robolens/logo.png`. The `containing("://")`
> branch keeps external image URLs (if any) working.

---

## Step 6 — Add the section listing template

Create **`templates/section.html`**. It reuses the existing base layout
(`index.html`) and renders the section's paginated post feed (the same card
markup the homepage used to show), with the section title as the header.

```jinja
{% extends "index.html" %}

{% block title %}{{ config.title }} - {{ section.title }}{% endblock title %}

{% block header %}
<div class="page-header">
  <h1>{{ section.title }} <small>{{ section.description }}</small></h1>
</div>
{% endblock header %}

{% block main %}
  {% for page in paginator.pages %}
    {{ macro::post_max(page=page) }}
  {% endfor %}

  {{ macro::paginator(ref=paginator, extra=config.extra) }}
{% endblock main %}
```

> This works because both new sections set `paginate_by`, so `paginator` is
> defined when `section.html` renders them.

---

## Step 7 — Turn the homepage into a landing page

The root section (`content/_index.md`) renders with `index.html`. Replace
`index.html`'s default `block main` (the old paginated feed) with a landing that
pulls the latest items from each section. The old feed code now lives in
`section.html` (Step 6), so it's safe to overwrite here.

### 7a. Simplify `content/_index.md`

The root no longer needs pagination. Set it to:
```toml
+++
sort_by = "date"
insert_anchor_links = "none"
+++
```
(Removing `paginate_by` is important — the landing `block main` must **not**
reference `paginator`, which is undefined without it.)

### 7b. Edit `templates/index.html` `block main`

Find this block (around lines 95–101):
```jinja
      {% block main %}
        {% for page in paginator.pages %}
          {{ macro::post_max(page=page) }}
        {% endfor %}

        {{ macro::paginator(ref=paginator, extra=config.extra) }}
      {% endblock main %}
```

Replace it with a two-section landing. Use `get_section` to fetch each section
and slice its `pages` (already date-sorted):

```jinja
      {% block main %}
        {% set projects = get_section(path="projects/_index.md") %}
        {% set blog = get_section(path="blog/_index.md") %}

        <div class="page-header">
          <h1>Projects <small><a href="{{ config.base_url }}/projects">see all &rarr;</a></small></h1>
        </div>
        {% for page in projects.pages | slice(end=3) %}
          {{ macro::post_max(page=page) }}
        {% endfor %}

        <div class="page-header">
          <h1>Blog <small><a href="{{ config.base_url }}/blog">see all &rarr;</a></small></h1>
        </div>
        <ul>
          {% for page in blog.pages | slice(end=6) %}
            <li>{{ macro::post_min(page=page) }}</li>
          {% endfor %}
        </ul>
      {% endblock main %}
```

> Design choice: Projects are shown as rich cards (`post_max`, with thumbnails),
> the Blog as a compact dated list (`post_min`). Adjust the `slice(end=N)`
> counts to taste. If you prefer both as cards, use `post_max` in both loops.
>
> The other templates that extend `index.html` (`page.html`, `section.html`,
> `categories/*`, `tags/*`) all override `block main`, so this landing markup
> only ever runs for the actual homepage.

---

## Step 8 — Update the navigation menu

In `config.toml`, update `zola386_menu` to add Projects and Blog:

```toml
zola386_menu = [
  { path = "", name = "Home" },
  { path = "projects", name = "Projects" },
  { path = "blog", name = "Blog" },
  { path = "categories", name = "Categories" },
  { path = "tags", name = "Tags" },
  { path = "about", name = "About" },
]
```
(Keep Categories/Tags if you still want taxonomy browsing; drop them here if the
nav feels crowded — that's a cosmetic call.)

---

## Step 9 — Build, verify, and check links (required)

```bash
zola build
```
Zola's build includes an internal link checker and will warn about broken
internal links. Then run the dev server and click through:

```bash
zola serve
```

**Verification checklist:**
- [ ] `/` shows the landing page with a Projects section (cards + thumbnails)
      and a Blog section (dated list). **Thumbnails load** (this is the Step 5
      fix — check the RoboLens/Talking Cat/LeHelpingHand images render).
- [ ] `/projects/` lists exactly the 3 projects, paginated, with thumbnails.
- [ ] `/blog/` lists the blog posts **including the emacs post** (Step 4 date
      fix). Confirm the count matches the table above.
- [ ] New canonical URLs work: `/projects/robolens/`, `/blog/parsec-setup/`,
      etc.
- [ ] **Old URLs redirect:** visiting `/robolens/`, `/lehelpinghand/`,
      `/talking-cat/`, `/parsec-setup/`, `/window_managers/`,
      `/cmake_build_for_cyclone_physics/`, `/emacs_vscode_journey/` lands on the
      new nested URL.
- [ ] Nav bar shows Home / Projects / Blog / (Categories / Tags /) About and
      each link works; the active item highlights.
- [ ] `/about/` still works unchanged.
- [ ] Category/tag pages still work (e.g. `/categories/projects/`,
      `/tags/robotics/`).
- [ ] No broken-link or template warnings in the `zola build` output.

If your local Zola differs from Netlify's pinned `0.14.0`, also sanity-check
that `aliases`, `get_section`, and `slice` behave (all are available in 0.14).

---

## Step 10 — Update docs

- Update `AGENTS.md` §3 to describe the new section-based content model (posts
  now live under `content/projects/` and `content/blog/`; classification is by
  folder/section, not just the `categories` taxonomy).
- Update `README.md` if it describes content structure.
- Optionally reconcile `Qwen.md` / `gemini.md` (or leave a pointer to
  `AGENTS.md`).

---

## Step 11 — Commit

```bash
git add -A
git status     # review the moves/renames
git commit -m "Split content into Projects and Blog sections with landing page"
```
Do **not** push or merge unless the user asks. Let them review locally first.

---

## Appendix A — Alternative: Netlify redirects instead of `aliases`

This plan uses Zola `aliases` (self-contained, host-independent). If you'd
rather centralize redirects, drop the `aliases` lines and instead create a
`static/_redirects` file (Netlify copies `static/` to the publish root):

```
/robolens/                          /projects/robolens/                          301
/lehelpinghand/                     /projects/lehelpinghand/                     301
/talking-cat/                       /projects/talking-cat/                       301
/cmake_build_for_cyclone_physics/   /blog/cmake_build_for_cyclone_physics/       301
/window_managers/                   /blog/window_managers/                       301
/parsec-setup/                      /blog/parsec-setup/                          301
/emacs_vscode_journey/              /blog/emacs_vscode_journey/                   301
```
Pick **one** mechanism, not both. `aliases` is the recommended default here.

## Appendix B — Files touched (quick map)

- **Deleted:** `content/nvim/`, `content/lorem-ipsum/`, `content/sem-nulla.md`,
  `content/unlisted.md` (Step 1).
- **Moved:** 7 post folders into `content/projects/` and `content/blog/`
  (Step 3).
- **New:** `content/projects/_index.md`, `content/blog/_index.md`,
  `templates/section.html`.
- **Edited:** `content/_index.md`, `templates/index.html` (block main),
  `templates/macros.html` (image URL), `config.toml` (nav menu), each moved
  `index.md` (aliases + emacs date), `AGENTS.md`/`README.md` (docs).
- **Untouched:** `content/pages/about.md`, taxonomy templates, shortcodes,
  `static/`, `sass/`, `netlify.toml` (unless using Appendix A).

## Appendix C — Risk notes for the implementing agent

- The **single biggest trap** is the thumbnail URL bug (Step 5). If you skip it,
  the build succeeds but all card images 404. Don't skip it.
- The **second trap** is leaving `paginate_by` on the root `_index.md` while the
  landing `block main` doesn't use `paginator` — harmless, but if you instead
  reference `paginator` on the homepage it will error. Keep the landing using
  `get_section`.
- Keep every post's existing `slug` exactly as-is; the aliases depend on it.
- Use `git mv` (not delete+recreate) so image bundles and history survive.
