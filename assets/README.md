# PlayHaven home assets

Visual references were read from the public local PlayHaven home page (`http://playhaven.test/`) on 2026-11-18 and its `resources/js/pages/welcome.tsx` implementation. The web project is a reference; the mobile app stores its own copies.

- `brand/playhaven-logo.svg`: copied from the web project's `public/brand/playhaven-logo.svg`.
- `images/games/`: copies of the public cover artwork used by the six featured web catalog entries below.

| Game | Source image |
| --- | --- |
| A Space for the Unbound | https://media.rawg.io/media/games/c18/c180a02a53ce8c8cf23f11f182184103.jpg |
| The Walking Dead: Season 1 | https://media.rawg.io/media/games/8d6/8d69eb6c32ed6acfd75f82d532144993.jpg |
| Genshin Impact | https://media.rawg.io/media/games/c38/c38bdb5da139005777176d33c463d70f.jpg |
| Red Dead Redemption 2 | https://media.rawg.io/media/games/511/5118aff5091cb3efec399c808f8c598f.jpg |
| Grand Theft Auto: San Andreas | https://media.rawg.io/media/games/960/960b601d9541cec776c5fa42a00bf6c4.jpg |
| The Last Of Us | https://media.rawg.io/media/games/a5a/a5a7fb8d9cb8063a8b42ee002b410db6.jpg |

The mobile banner uses the same featured artwork, with a portrait focal point and a vertical fade implemented in Flutter. Poster images decode at a bounded display size to avoid retaining full-resolution artwork in memory. The bundled ordering is a visual preview of the web home page, not a live weekly ranking.
