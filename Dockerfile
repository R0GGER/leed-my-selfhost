FROM node:24-alpine AS base

RUN corepack enable && corepack prepare pnpm@10.32.1 --activate
RUN apk add --no-cache git

# ── Clone & patch ────────────────────────────────────────────────
FROM base AS source

ARG LEEDPDF_VERSION=main
RUN git clone --depth 1 --branch "$LEEDPDF_VERSION" \
    https://github.com/rudi-q/leed_pdf_viewer.git /app

WORKDIR /app

# Swap Vercel adapter for Node adapter
RUN pnpm add -D @sveltejs/adapter-node && \
    pnpm remove @sveltejs/adapter-vercel

RUN cat > svelte.config.js <<'EOF'
import adapter from '@sveltejs/adapter-node';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: vitePreprocess(),
  kit: {
    adapter: adapter({
      envPrefix: ''
    })
  }
};

export default config;
EOF

# ── Build ────────────────────────────────────────────────────────
FROM source AS build

ARG BRAVE_SEARCH_API_KEY=""
ARG PUBLIC_POSTHOG_KEY=""
ARG PUBLIC_APPWRITE_ENDPOINT=""
ARG PUBLIC_APPWRITE_PROJECT_ID=""
ARG PUBLIC_APPWRITE_DATABASE_ID=""
ARG PUBLIC_APPWRITE_STORAGE_BUCKET_ID=""
ARG PUBLIC_APPWRITE_SHARED_PDFS_COLLECTION_ID=""
ARG PUBLIC_APPWRITE_PDF_ANNOTATIONS_COLLECTION_ID=""

RUN pnpm build

# ── Production image ─────────────────────────────────────────────
FROM node:24-alpine AS production

RUN addgroup -S leedpdf && adduser -S leedpdf -G leedpdf

WORKDIR /app

COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./

ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0
ENV ORIGIN=http://localhost:3000

EXPOSE 3000

USER leedpdf

CMD ["node", "build"]
