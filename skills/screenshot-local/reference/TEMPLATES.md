# shot-scraper YAML Templates

Copy-paste templates for common screenshot scenarios.

## Basic Web App (React, Next.js, Vue, etc.)

```yaml
# shots.yml — Standard web app documentation screenshots
- url: http://localhost:3000
  output: screenshots/homepage.png
  width: 1280
  height: 800

- url: http://localhost:3000/about
  output: screenshots/about.png
  width: 1280

- url: http://localhost:3000/features
  output: screenshots/features.png
  width: 1280
  height: 900

- url: http://localhost:3000/pricing
  output: screenshots/pricing.png
  width: 1280
  height: 800
```

## SPA with Loading States

```yaml
# shots.yml — SPA that needs wait times for hydration
- url: http://localhost:3000
  output: screenshots/homepage.png
  width: 1280
  height: 800
  wait: 2000

- url: http://localhost:3000/dashboard
  output: screenshots/dashboard.png
  width: 1280
  height: 900
  wait: 3000
  javascript: |
    document.querySelector('.cookie-banner')?.remove();
    document.querySelector('.onboarding-modal')?.remove();

- url: http://localhost:3000/profile
  output: screenshots/profile.png
  width: 1280
  wait: 2000
  wait_for: "document.querySelector('.profile-card')"
```

## Component Library / Design System

```yaml
# shots.yml — Capture individual components
- url: http://localhost:6006/iframe.html?id=button--primary
  output: screenshots/components/button-primary.png
  width: 400
  height: 200
  selector: "#storybook-root"
  padding: 20

- url: http://localhost:6006/iframe.html?id=card--default
  output: screenshots/components/card-default.png
  width: 600
  height: 400
  selector: "#storybook-root"
  padding: 20

- url: http://localhost:6006/iframe.html?id=form--login
  output: screenshots/components/form-login.png
  width: 500
  height: 600
  selector: "#storybook-root"
  padding: 20
```

## Responsive Breakpoints

```yaml
# shots.yml — Same page at multiple viewport sizes
- url: http://localhost:3000
  output: screenshots/responsive/desktop.png
  width: 1440
  height: 900

- url: http://localhost:3000
  output: screenshots/responsive/laptop.png
  width: 1280
  height: 800

- url: http://localhost:3000
  output: screenshots/responsive/tablet.png
  width: 768
  height: 1024

- url: http://localhost:3000
  output: screenshots/responsive/mobile.png
  width: 375
  height: 812
```

## Dashboard with Dynamic Data

```yaml
# shots.yml — Dashboard that needs JS setup
- url: http://localhost:3000/dashboard
  output: screenshots/dashboard-overview.png
  width: 1440
  height: 900
  wait: 3000
  javascript: |
    // Dismiss notifications
    document.querySelectorAll('.notification').forEach(n => n.remove());
    // Wait for charts to render
    await new Promise(r => setTimeout(r, 1000));

- url: http://localhost:3000/dashboard/analytics
  output: screenshots/dashboard-analytics.png
  width: 1440
  height: 900
  wait: 3000
  javascript: |
    document.querySelector('.date-picker')?.remove();

- url: http://localhost:3000/dashboard
  output: screenshots/dashboard-sidebar.png
  width: 1440
  selector: ".sidebar"
  padding: 10
```

## Before/After Comparison

```yaml
# shots-before.yml — Capture before refactoring
- url: http://localhost:3000
  output: screenshots/before/homepage.png
  width: 1280
  height: 800

- url: http://localhost:3000/settings
  output: screenshots/before/settings.png
  width: 1280
  height: 800
```

```yaml
# shots-after.yml — Capture after refactoring (same dimensions!)
- url: http://localhost:3000
  output: screenshots/after/homepage.png
  width: 1280
  height: 800

- url: http://localhost:3000/settings
  output: screenshots/after/settings.png
  width: 1280
  height: 800
```

## Static Site (Hugo, Jekyll, Astro, etc.)

```yaml
# shots.yml — Static site with built output
- url: http://localhost:4321
  output: screenshots/home.png
  width: 1280
  height: 800

- url: http://localhost:4321/blog
  output: screenshots/blog-listing.png
  width: 1280

- url: http://localhost:4321/blog/first-post
  output: screenshots/blog-post.png
  width: 1280
  height: 900

- url: http://localhost:4321/docs
  output: screenshots/docs.png
  width: 1280
  height: 900
```

## Local HTML Files (No Server)

```yaml
# shots.yml — Capture static HTML files directly
- url: ./dist/index.html
  output: screenshots/build-output.png
  width: 1280
  height: 800

- url: ./reports/coverage/index.html
  output: screenshots/coverage-report.png
  width: 1280

- url: ./docs/api.html
  output: screenshots/api-docs.png
  width: 1280
  height: 900
```

## Retina + OG Images for README

```yaml
# shots.yml — High-quality images for README and social
- url: http://localhost:3000
  output: screenshots/hero.png
  width: 1280
  height: 640
  retina: true

- url: http://localhost:3000
  output: screenshots/og-image.png
  width: 1200
  height: 630

- url: http://localhost:3000
  output: screenshots/hero-section.png
  width: 1280
  selector: ".hero"
  padding: 40
  retina: true
  omit_background: true
```

## With Auto-Started Server

```yaml
# shots.yml — shot-scraper starts the server for you
- url: http://localhost:3000
  output: screenshots/homepage.png
  width: 1280
  height: 800
  server: "npm run dev"

- url: http://localhost:3000/about
  output: screenshots/about.png
  width: 1280
  server: "npm run dev"
```

Note: The `server` process runs for the duration of the multi-shot session.

## Behind Authentication

```bash
# Step 1: Create auth context (interactive browser opens)
shot-scraper auth http://localhost:3000/login auth.json
```

```yaml
# Step 2: shots.yml — Use saved auth
- url: http://localhost:3000/admin
  output: screenshots/admin-dashboard.png
  width: 1280
  height: 900
  auth: auth.json

- url: http://localhost:3000/admin/users
  output: screenshots/admin-users.png
  width: 1280
  auth: auth.json
```
