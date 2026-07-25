import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});
  @override
  Widget build(BuildContext context) {
    const bars = [0.3, 0.65, 0.45, 0.8, 0.55, 0.9, 0.7];
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.science_outlined),
              title: Text('Demo analytics'),
              subtitle: Text(
                'All values on this screen are illustrative mock data.',
              ),
            ),
          ),
          const Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Weekly workouts',
                  value: '3',
                  icon: Icons.calendar_view_week,
                ),
              ),
              Expanded(
                child: StatCard(
                  label: 'Active minutes',
                  value: '146',
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Total reps',
                  value: '184',
                  icon: Icons.repeat,
                ),
              ),
              Expanded(
                child: StatCard(
                  label: 'Consistency',
                  value: '75%',
                  icon: Icons.track_changes,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Recent trend', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxs,
                      ),
                      child: Semantics(
                        label:
                            'Day ${i + 1}, ${(bars[i] * 100).round()} percent activity',
                        child: FractionallySizedBox(
                          heightFactor: bars[i],
                          alignment: Alignment.bottomCenter,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.xxs,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Exercise distribution',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const ListTile(title: Text('Strength'), trailing: Text('55%')),
          const LinearProgressIndicator(value: 0.55),
          const ListTile(title: Text('Core'), trailing: Text('25%')),
          const LinearProgressIndicator(value: 0.25),
          const ListTile(
            title: Text('Cardio & mobility'),
            trailing: Text('20%'),
          ),
          const LinearProgressIndicator(value: 0.2),
        ],
      ),
    );
  }
}
