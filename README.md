# LeedPDF / Self-Hosted

Docker setup to self-host [LeedPDF](https://github.com/rudi-q/leed_pdf_viewer), an **open-source** PDF annotation tool.

## Quick Start

```bash
# 1. Configure environment
cp .env.example .env   # edit .env as needed

# 2. Pull and run
docker compose up -d
```

The app will be available at **http://localhost:3000**.

## Configuration

All settings live in `.env`. The app works out of the box — every variable is optional.

| Variable | Purpose |
|---|---|
| `ORIGIN` | Public URL of your instance (e.g. `https://pdf.example.com`). Required when not on localhost. |
| `PORT` | Host port (default: `3000`) |
| `BRAVE_SEARCH_API_KEY` | Enables the PDF search feature ([get a free key](https://api.search.brave.com/app/keys)) |

## Build from Source

If you prefer to build the image yourself instead of using the pre-built one:

```bash
docker compose -f docker-compose.yml -f docker-compose.build.yml up --build -d
```

## License

The Docker configuration in this repo is provided as-is. LeedPDF itself is licensed under [AGPL-3.0](https://github.com/rudi-q/leed_pdf_viewer/blob/main/LICENSE).
