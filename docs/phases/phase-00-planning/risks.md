# Risk Register

Probability and impact use Low/Medium/High. Priority combines likelihood, consequence, and schedule sensitivity and must be reviewed at each phase gate.

| ID | Category | Description | Probability | Impact | Priority | Trigger | Mitigation | Contingency | Suggested owner |
|---|---|---|---|---|---|---|---|---|---|
| R-001 | ML/accuracy | Pose landmarks or rep rules are inaccurate across users. | High | High | Critical | Validation misses agreed error target | Diverse consented fixtures; versioned/calibrated rules; confidence gating | Narrow supported conditions; label beta; manual correction if approved | Pose lead |
| R-002 | Environment | Lighting variation reduces confidence. | High | Medium | High | Sustained low-confidence frames | Onboarding guidance; quality indicator; varied-light tests | Pause counting and prompt repositioning | Mobile/UX lead |
| R-003 | Usability | Incorrect camera position distorts angles. | High | High | Critical | Required body regions clipped/wrong view | Exercise-specific visual setup; preflight landmark check | Block start or pause with corrective prompt | UX lead |
| R-004 | ML/accuracy | Limbs, clothing, or equipment occlude landmarks. | High | High | Critical | Required landmarks lost | Confidence mask; supported-condition rules; fixture coverage | Exclude frames and ask user to reposition | Pose lead |
| R-005 | Performance | Mid-range devices cannot sustain inference target. | Medium | High | High | FPS/thermal benchmark fails | Early device matrix; tune model/delegate/resolution/rate | Reduce processing rate/visual effects; narrow support | Native integration lead |
| R-006 | Battery | Camera/GPS sessions consume excessive battery or heat device. | High | Medium | High | Power/thermal budget exceeded | Profile early; adaptive sampling; stop sensors promptly | Warn user; lower-power mode/session limit | Mobile lead |
| R-007 | Location | GPS inaccuracy inflates routes, pace, or distance. | High | High | Critical | Accuracy/jump filters reject many points | Accuracy metadata, plausibility filters, field tests | Flag degraded result and avoid false precision | Location lead |
| R-008 | Platform | Android background-location restrictions stop tracking. | Medium | High | High | Track gaps when app backgrounds | Foreground service; permission education; API-level tests | Keep session/recover; disclose gaps/unsupported devices | Android lead |
| R-009 | Privacy | Camera, route, or identity data is exposed or over-collected. | Medium | High | Critical | Network/log/privacy review finds leakage | On-device frames; minimization; HTTPS; access control; secret scans | Disable affected flow, rotate secrets, incident response | Security/privacy owner |
| R-010 | Authentication | Token lifecycle or auth errors lock users out/mix sessions. | Medium | High | High | Refresh/logout/isolation tests fail | Official SDK patterns; server authorization; state tests | Safe logout, retain isolated pending local data, support recovery | Backend lead |
| R-011 | Data integrity | Offline synchronization conflicts or duplicates records. | Medium | High | High | Same client session appears twice | Stable IDs, idempotency, immutable completed sessions, retry tests | Reconciliation job/tool and audit trail | Data/backend lead |
| R-012 | Dependency | Flutter, MediaPipe, location, or Supabase packages conflict. | Medium | High | High | Build/API incompatibility | Pin compatible versions; spike early; upgrade policy | Substitute package or isolate adapter; delay non-MVP feature | Architect |
| R-013 | Integration | Flutter/Kotlin MediaPipe bridge adds complexity or latency. | High | High | Critical | Serialization/crash/latency spike fails | Typed Pigeon contract; lifecycle/error contract; focused prototype in Phase 1 | Simplify payload/rate; use supported plugin route | Native integration lead |
| R-014 | Validation | Insufficient representative testing data causes misleading results. | High | High | Critical | Coverage gaps or small sample | Consent protocol; scenario matrix; separate detector/count/form metrics | Limit claims/scope; collect more data before release | QA/research lead |
| R-015 | Scope | New exercises or social/nutrition features displace MVP. | High | High | Critical | Unapproved backlog growth | Enforce [Scope](scope.md); phase gates and change control | Defer to future backlog; protect MVP baseline | Project manager |
| R-016 | People | A specialist/team member becomes unavailable. | Medium | High | High | Single-owner work stalls | Pairing, ADRs, interface docs, cross-review | Reassign and reduce extended scope | Project manager |
| R-017 | Deployment | API/container/CI deployment fails near demonstration. | Medium | High | High | Staging pipeline or rollback test fails | Early reproducible environments; health checks; staged CI | Demo offline/local capability; use last verified artifact | DevOps/backend lead |
| R-018 | Schedule | Academic timeline is insufficient for calibration and testing. | High | High | Critical | Phase milestones slip >1 week | MVP-first plan; weekly burn-up; freeze extended work | Remove extended exercises, preserve evidence/quality | Project manager |
| R-019 | Safety | Users treat automated cues as medical or universally correct. | Medium | High | High | User testing shows over-reliance | Clear limitation language; observable cues; expert review | Disable disputed cue; strengthen warnings | Product/safety owner |
| R-020 | Maps/cost | Maps-provider limits, terms, or pricing change. | Medium | Medium | Medium | Quota/cost projection exceeded | Provider abstraction; cache only permitted data; usage budget | Basic route without premium tiles; switch provider | Architect |

## Review Cadence

The team should review Critical and High risks weekly during implementation and before each demonstration. Owners must convert triggers into measurable tasks; accepting a risk requires project-owner approval and a recorded rationale.

