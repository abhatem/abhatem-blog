# Project Qwen Context

## Project Overview
This is the source code for Abdullah Al-Hatem's personal blog, available at [abhatem.com](https://abhatem.com/). This blog is where Abdullah writes about his projects and things he's learning, with topics including AI, robotics, software development, and programming tools.

The blog uses a custom retro/terminal theme (zola.386 based) and is built with the Zola static site generator.

## Tech Stack
- **Static Site Generator:** [Zola](https://www.getzola.org/)
- **Hosting:** [Netlify](https://www.netlify.com/)
- **Theme:** Based on the awesome retro theme [zola.386](https://github.com/lopes/zola.386) by [lopes](https://github.com/lopes)

## Project Structure
```
├── config.toml           # Main configuration file
├── content/              # Blog posts and pages
│   ├── _index.md         # Homepage configuration
│   ├── about/            # About page
│   ├── categories/       # Categories page
│   ├── tags/             # Tags page
│   └── [post folders]/   # Individual blog posts
├── templates/            # HTML templates
├── static/               # Static assets (images, CSS, JS)
├── sass/                 # Sass stylesheets
├── assets/               # Theme assets
│   └── thumbnails/       # Post thumbnails
├── theme.toml            # Theme configuration
└── netlify.toml          # Netlify deployment configuration
```

## Configuration
The main configuration is in `config.toml`:
- Base URL: https://abhatem.com/
- Default language: English
- Site title: "abhatem.com"
- Description: "Tinkering the night away 👨‍💻"
- Uses categories and tags taxonomies
- Social media links for Twitter, LinkedIn, and GitHub

## Development Workflow
1. Clone the repository
2. Install Zola (static site generator)
3. Run `zola serve` for local development
4. The site will be available at `http://127.0.0.1:1111`
5. Run `zola build` to generate static files in the `public` directory

## Content Guidelines
- Blog posts are written in Markdown with frontmatter
- Posts are organized in folders within the `content/` directory
- Each post includes metadata like title, description, date, categories, and tags
- Common categories include "takes" and "showing off"
- Tags vary by topic (e.g., "emacs", "vscode", "cmake", "c++", "AI", "robotics")

## Content Conventions
- **YouTube Videos:** Embed videos using the `youtube` shortcode: `{{ youtube(id="VIDEO_ID") }}`
- **Images:** Add images using standard Markdown `![alt text](image.jpg)`. Place the image file in the same folder as the post's `index.md`
- **Links:** Use standard Markdown links: `[link text](https://example.com)`

## Deployment
The site is automatically deployed to Netlify on pushes to the main branch. The build command is configured in `netlify.toml`.

## Common Tasks
- Adding a new blog post: Create a new folder in `content/` with an `index.md` file
- Updating site configuration: Modify `config.toml`
- Adding static assets: Place files in the `static/` directory
- Modifying templates: Edit files in the `templates/` directory
- Changing styles: Modify files in the `sass/` directory
- Embedding YouTube videos: Use the shortcode `{{ youtube(id="VIDEO_ID") }}`
- Running development server: `zola serve`
- Building the site: `zola build`

## Notable Features
- RSS feed generation
- Search functionality
- Syntax highlighting for code snippets
- Responsive design
- Retro aesthetic from the zola.386 theme
- Social media integration (Twitter, LinkedIn, GitHub)
- Disqus comments (when enabled)

## Author Information
- Name: Abdullah Al-Hatem
- GitHub: [abhatem](https://github.com/abhatem)
- LinkedIn: [abhatem](https://linkedin.com/in/abhatem)
- Twitter: [@abhatem2689](https://twitter.com/abhatem2689)