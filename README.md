# Compass

A goal-tracking workspace for Zostel — a single-file (vanilla HTML/CSS/JS) app for setting goals, marking measures, running initiatives, capturing loose ideas, and sharing weekly updates over the course of a quarter.

Built around how a real team actually moves: outcome-first goals, weekly check-ins via an activity trail, and a low-friction ideas wall for sparks before they become work.

**Live demo:** https://vikasnagpal.github.io/Compass/

## Run it locally

Open `index.html` in any modern browser. No build step, no server, no dependencies. State persists in `localStorage`.

## What's inside

- **Goals → Measures → Initiatives** hierarchy, with an Activity Trail per initiative (status changes + comments, chronological)
- **Ideas hub** for loose thoughts — filter by goal, promote any idea to an initiative when planning rolls around
- **Team Settings** to manage who can lead initiatives — drives the "Led by" dropdown everywhere
- **Help page** explaining the philosophy, the rhythm, and the principles
- Click-to-edit owner and due-date chips inside the initiative drawer
- Status changes only commit when you click **Share Update** — pills "stage" the change first
- Subtle delight on idea capture: rotating placeholders, sparkle burst, milestone moments, sidebar counter bump, fresh-card glow
- Responsive: desktop sidebar, mobile drawer with hamburger; container-queried row layouts that wrap attributes onto their own line when space is tight
- Earthy palette (warm mustard, charcoal, soft cream, success green), Poppins + Inter + IBM Plex Sans typography
- WCAG-friendly type scale and contrast, `prefers-reduced-motion` support

## Brand voice

Warm and human — clear core nouns (Goals, Measures, Initiatives, Ideas) with motivating microcopy in banners, validation, and empty states. Designed to feel like a productivity companion for a travel community, not enterprise HR software.

---

Crafted with care by [Vikas N.](https://www.linkedin.com/in/vikasnagpal/?skipRedirect=true)
