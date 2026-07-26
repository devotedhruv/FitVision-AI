# Known limitations

Backlight, partial framing, joint occlusion, multiple people, very fast movement, camera motion and unsupported orientation can degrade landmarks; the UI must keep confidence/view warnings visible and rejected frames do not advance reps. Indoor/poor GPS, force-stop, OEM battery restrictions and permission revocation can interrupt a run. Screen-off support is conditional on Android foreground-service rules.

Form scores are absent when Phase 5 cannot calculate them reliably. Real-device thermal, battery and three-phone gates are unverified and block a beta-ready verdict. The API limiter is process-local; multi-instance deployments require a shared gateway/Redis limiter.
