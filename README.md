# across rca

A lost archive of RCA student projects inspired by space debris. Projects float in a drifting universe; switch to **Overview** to see every project in orbit around a planet, rotate it and zoom in.

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

You can also use the **+ Launch** form on the live site: it builds the entry for you and gives you the text to paste into `projects.json`.

The 24 projects already in the file are made-up examples (`"example": true`). Delete them when real work comes in.

## Letting people upload directly

GitHub Pages only hosts files, so visitors can't save new projects to it. For direct uploads you need a small backend such as Supabase or Firebase to store entries and images.
