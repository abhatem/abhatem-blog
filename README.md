# Abdullah Al-Hatem's Personal Blog

This is the source code for my personal blog, available at [abhatem.com](https://abhatem.com/).

This blog is where I write about my projects and things I'm learning, with topics including AI, robotics, software development, and programming tools.

## Tech Stack

*   **Static Site Generator:** [Zola](https://www.getzola.org/)
*   **Hosting:** [Netlify](https://www.netlify.com/)
*   **Theme:** Based on the awesome retro theme [zola.386](https://github.com/lopes/zola.386) by [lopes](https://github.com/lopes).

## Development

To run this site locally, you need to have Zola installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/abhatem/abhatem-blog
    cd abhatem-blog
    ```

2.  **Run the development server:**
    ```bash
    zola serve
    ```
    The site will be available at `http://127.0.0.1:1111`.

3.  **Build the site:**
    ```bash
    zola build
    ```
    The static files will be generated in the `public` directory.

## Image Compression Script

To compress images in `content/` and backup originals, run:

```bash
./compress_images.sh
```

- Originals are backed up to `content/.original_images/` (overwritten each run).
- Compressed images replace originals in place.
- Backup folder is excluded from git and Netlify builds.

### Requirements
- `jpegoptim` (for JPEGs)
- `optipng` (for PNGs)

Install on Ubuntu/Debian:
```bash
sudo apt-get install jpegoptim optipng
```

### Optional: Pre-commit Hook
To run compression before each commit, symlink the script:
```bash
ln -s ../../compress_images.sh .git/hooks/pre-commit
```

Remove the symlink to disable.

---