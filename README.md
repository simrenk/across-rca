# Still in Orbit

An archive of lost RCA projects, inspired by space debris. Projects float in a drifting universe; switch to **Overview** to see every project in orbit around a planet, rotate it and zoom in.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole site: layout, styles and code in one file |
| `projects.json` | The list of projects shown in the archive |
| `images/` | Project images referenced from `projects.json` |

## Publish on GitHub Pages

1. Create a new repository on GitHub, for example `across-rca`.
2. Upload `index.html`, `projects.json`, `README.md` and the `images` folder (on the repository page: **Add file → Upload files**).
3. Go to **Settings → Pages**. Under **Build and deployment**, set **Source** to *Deploy from a branch*, pick the `main` branch and the `/ (root)` folder, then **Save**.
4. After a minute the site is live at `https://<your-username>.github.io/across-rca/`.

Opening `index.html` straight from your computer won't load `projects.json`, because browsers block that. To preview locally, run `python3 -m http.server` in this folder and open `http://localhost:8000`.

## Add a project

Each project is one entry in `projects.json`:

```json
{
  "id": "kessler-garden",
  "title": "Kessler Garden",
  "maker": "Mira Okafor",
  "programme": "Ceramics & Glass",
  "media": "Image",
  "tags": ["material", "installation", "storytelling"],
  "year": "2026",
  "description": "A few sentences about the project.",
  "link": "https://example.com",
  "image": "images/kessler-garden.jpg",
  "createdAt": 1794700000000
}
```

- **programme** is the major. Known majors get their own bubble colour; any new name is given one automatically.
- **media** is one of: `Image`, `Drawing (DXF)`, `Sheet (MDF)`, `3D model`, `Code`, `Video`, `Sound`, `Text`.
- **tags** is an optional list of short lowercase words. Pick from the ones already used or make up your own. Tags show up under **Overview → Index → Tags** for filtering, and they drive the **Related in orbit** list on each project (together with words shared between descriptions, plus the medium and major).
- **image** is optional. Without one, the project gets a generated preview in the style of its medium. For a video, use `"video": "images/film.mp4"` instead.
- **createdAt** is a timestamp in milliseconds. Projects from the last 7 days are marked as new.

The 24 projects already in the file are made-up examples (`"example": true`). Delete them when real work comes in.

## Launching projects (anyone, no account)

Anyone visiting the site can press **+ Launch**, add up to 8 files (images, video, sound, PDF, or a `.glb` 3D model; 50 MB each) and the project appears in orbit for everyone straight away. Launched projects and their files are stored in [Supabase](https://supabase.com) (free plan); the example projects stay in `projects.json`.

### One-time setup

1. Create a free Supabase account and a new project.
2. In the project, open **SQL Editor → New query**, paste everything from [`supabase/setup.sql`](supabase/setup.sql) and press **Run**. This creates the `projects` table and the `projects` file bucket, and sets the rules: anyone can read and add projects, nobody can edit or delete them except you from the dashboard.
3. In **Project Settings → API**, copy the **Project URL** and the **publishable** (or `anon`) key, and put them at the top of the script in `index.html`:
   ```js
   const SUPABASE_URL = 'https://xxxx.supabase.co';
   const SUPABASE_KEY = 'sb_publishable_…';
   ```
   This key is meant to be public. Never put the `service_role` / secret key in the page.

Until those two values are filled in, **+ Launch** falls back to building a `projects.json` entry for you to paste in.

### Taking a project down

In Supabase, open **Table Editor → projects**, find the row and tick **hidden** (it disappears from the site but is kept), or delete the row. To also remove its files, delete its folder in **Storage → projects** (the folder name is listed in the row's `files` column).

## Viewing a project

Click a project, then its image (or **Open full view**) to open it full screen. Every file gets its own view: images zoom and pan (scroll, double-click, pinch, drag), video plays full size, sound gets a waveform player, PDFs open inline, `.glb` models can be spun and zoomed, and the project's link opens inside the viewer (some sites refuse to be embedded; **Open original** always works). Use the arrows or the strip at the bottom to move between items.
