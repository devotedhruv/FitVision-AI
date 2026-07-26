# Performance baseline

Host automation on 2026-07-26 (Asia/Kathmandu): Flutter analyze 1.3 s; 89 mobile tests passed in about 8 s; 26 pure-Dart engine tests passed in under one second; backend formatting/lint and 28 tests passed with one external-database test skipped in about 2.5 s. Synthetic evaluation fixture latencies only test percentile math and are **not device performance**.

Camera FPS, MediaPipe inference, platform serialization, UI frame timing, memory, CPU, thermal behavior, feedback latency, profile-mode end-to-end throughput, outdoor GPS error and battery/hour remain NOT MEASURED. No optimization or threshold change is justified from host-test duration.
