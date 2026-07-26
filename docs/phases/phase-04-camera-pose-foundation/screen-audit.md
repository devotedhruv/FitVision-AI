# Screen and Route Audit

| Screen | Route | Phase 4 result |
|---|---|---|
| Splash | `/splash` | Added; resolves auth without a fixed delay |
| Login | `/auth/login` | Phase 3 preserved; `/login` redirects |
| Registration | `/auth/register` | Phase 3 preserved; `/register` redirects |
| Permission onboarding | `/onboarding/permissions` | Existing onboarding preserved |
| Dashboard | `/dashboard` | Phase 2 preserved |
| Exercise library | `/exercises` | Phase 3 API loading/error/empty preserved |
| Instructions/camera guide | `/exercises/:id`, then live guide | Repository-backed detail loading/error/not-found/data states |
| Live exercise | `/exercises/:id/live` | Repository-backed exercise resolution and real camera/pose integration |
| Workout result | `/exercises/:id/result` | Measured Phase 4 metrics only |
| Running setup | `/running/setup` | Explicit GPS boundary |
| Live running | `/running/live` | Explicit unavailable state; no fake GPS |
| Running result | `/running/result` | Explicit unavailable state |
| History | `/history` | Existing Phase 2 view preserved |
| Session details | `/history/:sessionId` | Safe boundary/invalid ID handling |
| Analytics | `/analytics` | Existing view preserved |
| Profile | `/profile` | Phase 3 API preserved |
| Settings | `/settings` | Camera/audio/haptic/privacy settings added |

Authentication redirect rules protect all non-auth routes. Authenticated users
cannot remain on login/register/verification. Active camera back navigation
requires confirmation. Existing visual tokens and bottom navigation were
preserved.

Detail and live routes no longer instantiate `ExerciseMockRepository` inside
the router. Both resolve the route ID from `exerciseByIdProvider`, which derives
from the same Phase 3 `exerciseCatalogueProvider` used by the list. Tests cover
loading, repository error, not-found, and successful resolution. Test/offline
builds may still explicitly override `exerciseRepositoryProvider` with the
clearly named bundled mock repository.
