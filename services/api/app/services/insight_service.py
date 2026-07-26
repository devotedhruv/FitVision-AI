"""Deterministic analytics insight selection; no generated text."""

from app.schemas.analytics import AnalyticsInsight, AnalyticsSummary


class InsightService:
    @staticmethod
    def generate(summary: AnalyticsSummary) -> list[AnalyticsInsight]:
        values = []
        if summary.active_days:
            values.append(
                AnalyticsInsight(
                    code="activity_days_summary",
                    priority=4,
                    localization_key="activity_days_summary",
                    current_value=float(summary.active_days),
                )
            )
        if (
            summary.total_running_sessions >= 2
            and summary.weighted_average_pace_seconds_per_km is not None
        ):
            values.append(
                AnalyticsInsight(
                    code="running_pace_available",
                    priority=2,
                    localization_key="running_pace_available",
                    current_value=summary.weighted_average_pace_seconds_per_km,
                )
            )
        return sorted(values, key=lambda item: item.priority)[:4]
