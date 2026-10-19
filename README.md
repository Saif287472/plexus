# Plexus

Mobile-first, offline-capable, encrypted mesh messenger. Works without any central server or internet dependency. Persistent local storage, multi-transport discovery (Wi-Fi, Bluetooth, cellular, USB, direct IP), multi-hop mesh routing, and an optional rendezvous relay for NAT traversal.

## Status

Planning phase. No code written yet.

## Repo layout

| Path | Purpose |
|------|---------|
| `plexus_app/` | Flutter application (mobile-first) |
| `packages/` | Pure-Dart packages (core, storage, transport, mesh, crypto, protocol, discovery, ui) |
| `docs/` | Product, architecture, security, protocol, operations docs |
| `tool/` | Dart admin scripts (codegen, boundary checks) |
| `scripts/` | Verify, coverage, CI scripts |

## Key documents

- `PRODUCT_VISION.md` — product principles and user journeys
- `ARCHITECTURE.md` — clean architecture, layers, dependency rules
- `REPO_STRUCTURE.md` — directory layout and package dependency rules
- `DATA_LAYER.md` — encrypted database schema, migrations, repositories
- `TRANSPORT_MESH.md` — transport adapters, discovery, mesh routing
- `SECURITY_MODEL.md` — crypto design, identity lifecycle, app lock
- `DEV_STANDARDS.md` — testing, linting, CI gate, release process
- `ROADMAP.md` — phased delivery plan (Phase 1 → Phase 5)

## Separation

Plexus is entirely separate from Helix Remote, Helix Local, and Orbit. Different brand, different repo, different infrastructure. No shared code, no shared servers, no shared identities.

## License

See `LICENSE`.
