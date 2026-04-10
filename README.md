# LeedPDF / Self-Hosted

Docker setup to self-host [LeedPDF](https://github.com/rudi-q/leed_pdf_viewer), an **open-source** PDF annotation tool.

### Docker Image

```bash
docker pull ghcr.io/r0gger/leed-my-selfhost:latest
```

### Docker Compose

```yaml
services:
  leedpdf:
    image: ghcr.io/r0gger/leed-my-selfhost:latest
    container_name: leedpdf
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      # The public URL where your instance will be reachable.
      # Required for CORS / cookie handling in SvelteKit adapter-node.
      - ORIGIN=http://localhost:3000
      # Brave Search API (enables PDF search feature)
      # Free tier: 2000 queries/month — https://api.search.brave.com/app/keys
      - BRAVE_SEARCH_API_KEY=
      # PostHog Analytics (optional)
      - PUBLIC_POSTHOG_KEY=
      # Appwrite (enables PDF sharing)
      # https://cloud.appwrite.io
      - PUBLIC_APPWRITE_ENDPOINT=
      - PUBLIC_APPWRITE_PROJECT_ID=
      - PUBLIC_APPWRITE_DATABASE_ID=
      - PUBLIC_APPWRITE_STORAGE_BUCKET_ID=
      - PUBLIC_APPWRITE_SHARED_PDFS_COLLECTION_ID=
      - PUBLIC_APPWRITE_PDF_ANNOTATIONS_COLLECTION_ID=
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s
```

The app will be available at **http://localhost:3000**.

## Configuration

All settings live in `.env`. The app works out of the box - every variable is optional.

| Variable | Purpose |
|---|---|
| `ORIGIN` | Public URL of your instance (e.g. `https://pdf.example.com`). Required when not on localhost. |
| `PORT` | Host port (default: `3000`) |
| `BRAVE_SEARCH_API_KEY` | Enables the PDF search feature ([get a free key](https://api.search.brave.com/app/keys)) |

## License

The Docker configuration in this repo is provided as-is. LeedPDF itself is licensed under [AGPL-3.0](https://github.com/rudi-q/leed_pdf_viewer/blob/main/LICENSE).
