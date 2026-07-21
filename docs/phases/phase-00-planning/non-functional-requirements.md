# Non-Functional Requirements

Performance and accuracy numbers below are **initial engineering targets requiring device validation**, not guaranteed outcomes. “Supported device/conditions” will be fixed by the Phase 1 compatibility and test matrix.

| ID | Quality | Requirement / target | Priority | Verification |
|---|---|---|---|---|
| NFR-PERF-001 | Performance | The pose pipeline shall target at least 15 processed frames per second on a supported mid-range Android device under supported conditions. | Must | Device benchmark |
| NFR-PERF-002 | Performance | Visible form/count feedback shall target less than 150 ms from an eligible processed frame to UI update. | Must | Instrumented benchmark |
| NFR-PERF-003 | Performance | The UI shall remain responsive while pose or GPS processing is active, with no sustained main-thread blocking above the platform frame budget. | Must | Profiling |
| NFR-RELIABILITY-001 | Reliability | A held pose, duplicated frame, or repeated retry shall not produce duplicate reps or sessions. | Must | Property/failure test |
| NFR-RELIABILITY-002 | Reliability | Completed local records shall survive process termination and device restart before synchronization. | Must | Recovery test |
| NFR-RELIABILITY-003 | Reliability | Temporary camera, GPS, or network loss shall degrade safely and permit recovery without fabricating data. | Must | Fault-injection test |
| NFR-AVAIL-001 | Availability | Authorized users shall be able to record and review locally cached sessions without network access; registration, fresh login, and cloud sync may be unavailable. | Must | Offline test |
| NFR-SEC-001 | Security | All production client-server communication shall use HTTPS with valid certificate verification. | Must | Configuration/security test |
| NFR-SEC-002 | Security | Backend secrets and service-role credentials shall not be embedded in the mobile application or repository. | Must | Secret scan/inspection |
| NFR-SEC-003 | Security | Authorization shall be enforced server-side for every user-owned record; client-provided user IDs alone shall not establish ownership. | Must | Penetration/API test |
| NFR-SEC-004 | Security | Authentication tokens shall use platform-appropriate secure storage and shall be excluded from logs. | Must | Inspection/test |
| NFR-PRIVACY-001 | Privacy | Camera frames and derived full-frame imagery shall remain on device and shall not be transmitted by default. | Must | Network inspection |
| NFR-PRIVACY-002 | Privacy | Location collection shall occur only for an explicitly active run with permission and shall stop when it is finished. | Must | Device test |
| NFR-PRIVACY-003 | Privacy | Data collection and retention shall be minimized to features described in [Scope](scope.md), with clear consent and deletion behavior. | Must | Privacy review |
| NFR-USABILITY-001 | Usability | A first-time user shall be able to reach exercise countdown or run start from Home within three primary selections after permissions are resolved. | Should | Usability test |
| NFR-USABILITY-002 | Usability | Live feedback shall be short, actionable, and distinguish status, warning, and blocking conditions without relying only on color. | Must | UX inspection |
| NFR-ACCESS-001 | Accessibility | Core flows shall provide semantic labels, a logical focus order, touch targets of at least 48×48 dp, and support Android text scaling without hiding essential actions. | Should | Accessibility audit |
| NFR-MAINT-001 | Maintainability | UI, use cases, device services, exercise rules, repositories, and API clients shall have explicit interfaces and one-way dependency boundaries. | Must | Architecture review |
| NFR-MAINT-002 | Maintainability | Exercise thresholds and rule versions shall be configurable and traceable without changing detector code. | Must | Inspection/unit test |
| NFR-TEST-001 | Testability | State machines, angle calculations, GPS filtering, unit conversion, sync idempotency, and analytics shall be testable without physical sensors using recorded structured fixtures. | Must | Test-design review |
| NFR-TEST-002 | Testability | Each Must functional requirement shall map to at least one planned test or inspection before release. | Must | Traceability audit |
| NFR-COMPAT-001 | Compatibility | The release shall declare and verify minimum Android API level, architectures, camera requirements, background-location behavior, and a representative device matrix before implementation acceptance. | Must | Compatibility report |
| NFR-SCALE-001 | Scalability | API operations that list sessions shall support pagination and indexed user/time filtering; design target is 10,000 sessions per user without full-table transfer. | Should | Load/query analysis |
| NFR-BATTERY-001 | Battery | Camera and location sensors shall be active only for the relevant session; processing rate and model settings shall be tunable based on measured thermal/battery behavior. | Must | Power profiling |
| NFR-BATTERY-002 | Battery | Background runs shall use platform-compliant location settings and a foreground service rather than unrestricted background polling. | Must | Inspection/device test |
| NFR-OFFLINE-001 | Offline | Session creation shall not depend on API availability, and queued mutations shall expose status and retry safely. | Must | Offline/failure test |
| NFR-OBS-001 | Observability | The system shall record structured, non-sensitive diagnostics for detector initialization, session lifecycle, sync outcomes, and GPS quality, using correlation IDs where applicable. | Should | Log inspection |
| NFR-OBS-002 | Observability | Production diagnostics shall exclude raw frames, tokens, passwords, and precise route points by default and shall apply documented retention controls. | Must | Privacy/log audit |

## Accuracy Evaluation Boundary

Rep-count and form-rule performance shall be reported only after testing on a documented, consented dataset across users, devices, views, lighting, and valid/invalid motions. Reports shall separate detection failures, counting errors, and form-classification errors and provide sample size and methodology. No universal or clinical accuracy claim is permitted.

