import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/design_system/app_typography.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_tutorial_preferences.dart';
import 'package:fitvision_ai/features/exercise/presentation/widgets/exercise_animation.dart';
import 'package:flutter/material.dart';

Future<bool> showExerciseTutorial(
  BuildContext context,
  Exercise exercise,
) async {
  if (!await ExerciseTutorialPreferences.shouldShow(exercise.id)) return true;
  if (!context.mounted) return false;
  return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => ExerciseTutorialView(exercise: exercise),
      ) ??
      false;
}

class ExerciseTutorialView extends StatefulWidget {
  const ExerciseTutorialView({required this.exercise, super.key});
  final Exercise exercise;

  @override
  State<ExerciseTutorialView> createState() => _ExerciseTutorialViewState();
}

class _ExerciseTutorialViewState extends State<ExerciseTutorialView> {
  final PageController _pages = PageController();
  int _page = 0;
  int _animationRevision = 0;
  bool _skipNextTime = false;

  static const _titles = ['Demonstration', 'Setup', 'Form & safety', 'Ready'];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_page < _titles.length - 1) {
      await _pages.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    await ExerciseTutorialPreferences.complete(
      widget.exercise.id,
      skipNextTime: _skipNextTime,
    );
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _skip() async {
    await ExerciseTutorialPreferences.complete(
      widget.exercise.id,
      skipNextTime: false,
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * .9;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.xs,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.name,
                        style: AppTypography.sectionTitle(context),
                      ),
                      Text(
                        _titles[_page],
                        style: AppTypography.caption(context),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close tutorial',
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Semantics(
              label: 'Tutorial step ${_page + 1} of ${_titles.length}',
              child: LinearProgressIndicator(
                value: (_page + 1) / _titles.length,
                minHeight: 6,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: PageView(
              controller: _pages,
              onPageChanged: (value) => setState(() => _page = value),
              children: [
                _DemonstrationStep(
                  exercise: widget.exercise,
                  animationRevision: _animationRevision,
                  onWatchAgain: () => setState(() => _animationRevision++),
                ),
                _SetupStep(exercise: widget.exercise),
                _FormStep(exercise: widget.exercise),
                _ReadyStep(
                  exercise: widget.exercise,
                  skipNextTime: _skipNextTime,
                  onSkipChanged: (value) =>
                      setState(() => _skipNextTime = value),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                if (_page > 0)
                  OutlinedButton.icon(
                    onPressed: () => _pages.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  )
                else
                  TextButton(
                    onPressed: _skip,
                    child: const Text('Skip for now'),
                  ),
                const Spacer(),
                FilledButton.icon(
                  key: Key(
                    _page == _titles.length - 1
                        ? 'tutorial-ready'
                        : 'tutorial-next',
                  ),
                  onPressed: _next,
                  icon: Icon(
                    _page == _titles.length - 1
                        ? Icons.check
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    _page == _titles.length - 1 ? 'I’m Ready' : 'Next',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemonstrationStep extends StatelessWidget {
  const _DemonstrationStep({
    required this.exercise,
    required this.animationRevision,
    required this.onWatchAgain,
  });
  final Exercise exercise;
  final int animationRevision;
  final VoidCallback onWatchAgain;

  @override
  Widget build(BuildContext context) {
    final spec = ExerciseAnimationRegistry.resolve(exercise.id);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        SizedBox(
          height: 260,
          child: ExerciseAnimation(
            key: ValueKey('${exercise.id}-$animationRevision'),
            exerciseId: exercise.id,
            autoPlay: true,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(spec.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            Chip(label: Text(exercise.difficultyLabel)),
            Chip(label: Text('${exercise.estimatedDuration.inMinutes} min')),
            for (final muscle in exercise.targetMuscles)
              Chip(label: Text(muscle)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: onWatchAgain,
          icon: const Icon(Icons.replay),
          label: const Text('Watch Again'),
        ),
      ],
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.md),
    children: [
      _TutorialHero(
        icon: Icons.phone_android,
        title: 'Set up your training space',
        subtitle: exercise.supportsPoseDemo
            ? 'The camera needs a clear, stable view before tracking begins.'
            : 'Use a stable setup and follow the timed movement guidance.',
      ),
      const SizedBox(height: AppSpacing.md),
      ..._setupGuidance(exercise).map(_GuidanceTile.new),
    ],
  );
}

class _FormStep extends StatelessWidget {
  const _FormStep({required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.md),
    children: [
      Text('Movement steps', style: AppTypography.sectionTitle(context)),
      const SizedBox(height: AppSpacing.xs),
      for (var index = 0; index < exercise.instructions.length; index++)
        Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(exercise.instructions[index]),
          ),
        ),
      const SizedBox(height: AppSpacing.md),
      Text('Form & safety', style: AppTypography.sectionTitle(context)),
      const SizedBox(height: AppSpacing.xs),
      ..._formGuidance(exercise.id).map(_GuidanceTile.new),
      const _GuidanceTile(
        'Stop if you feel pain, dizziness, or unusual discomfort.',
        warning: true,
      ),
    ],
  );
}

class _ReadyStep extends StatelessWidget {
  const _ReadyStep({
    required this.exercise,
    required this.skipNextTime,
    required this.onSkipChanged,
  });
  final Exercise exercise;
  final bool skipNextTime;
  final ValueChanged<bool> onSkipChanged;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.md),
    children: [
      _TutorialHero(
        icon: exercise.supportsPoseDemo
            ? Icons.center_focus_strong
            : Icons.timer_outlined,
        title: 'You’re ready to begin',
        subtitle: exercise.supportsPoseDemo
            ? 'Next, FitVision will request camera access and help you move into frame.'
            : 'This exercise uses guided manual timing rather than automated rep detection.',
      ),
      const SizedBox(height: AppSpacing.md),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Equipment'),
              subtitle: Text(exercise.equipment.join(', ')),
            ),
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('Tracking support'),
              subtitle: Text(
                exercise.supportsPoseDemo
                    ? 'Pose-guided demo. Automated analysis depends on the supported detector.'
                    : 'Manual guided demo; automated pose analysis is unavailable.',
              ),
            ),
          ],
        ),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: skipNextTime,
        onChanged: (value) => onSkipChanged(value ?? false),
        title: const Text('Don’t show again for this exercise'),
        subtitle: const Text('You can reset tutorials from Settings.'),
      ),
    ],
  );
}

class _TutorialHero extends StatelessWidget {
  const _TutorialHero({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.xl),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
    ),
    child: Column(
      children: [
        Icon(icon, size: 64),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          style: AppTypography.sectionTitle(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, textAlign: TextAlign.center),
      ],
    ),
  );
}

class _GuidanceTile extends StatelessWidget {
  const _GuidanceTile(this.text, {this.warning = false});
  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(
      warning ? Icons.warning_amber_rounded : Icons.check_circle_outline,
      color: warning
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
    ),
    title: Text(text),
  );
}

List<String> _setupGuidance(Exercise exercise) {
  final common = <String>[
    'Place the phone on a stable support with clear, even lighting.',
    'Clear enough surrounding space to complete the movement safely.',
  ];
  if (!exercise.supportsPoseDemo) return common;
  return [
    ...common,
    'Stand far enough away for the required joints to remain visible.',
    switch (exercise.id) {
      'push-up' =>
        'Use a side view with shoulders, hips, knees, and ankles visible.',
      'bicep-curl' =>
        'Keep shoulders, elbows, and wrists visible from the front.',
      _ =>
        'Keep your full body, including shoulders, hips, knees, and ankles, visible.',
    },
  ];
}

List<String> _formGuidance(String exerciseId) => switch (exerciseId) {
  'squat' => [
    'Keep knees aligned with the direction of your toes.',
    'Keep your chest lifted and spine neutral.',
  ],
  'push-up' => [
    'Maintain a straight line through shoulders, hips, and ankles.',
    'Lower and press with control instead of dropping quickly.',
  ],
  'bicep-curl' => [
    'Keep elbows close to your torso.',
    'Avoid swinging your body to move the resistance.',
  ],
  'plank' => [
    'Keep shoulders, hips, and ankles in a steady line.',
    'Avoid letting the hips drop or rise excessively.',
  ],
  'lunges' => [
    'Keep the front knee aligned over the foot.',
    'Lower vertically with a stable torso.',
  ],
  'shoulder-press' => [
    'Brace the torso and use a comfortable resistance.',
    'Lower the hands to shoulder level with control.',
  ],
  'jumping-jack' => [
    'Land softly with knees relaxed.',
    'Use a stepping variation if jumping is uncomfortable.',
  ],
  _ => ['Use a comfortable range and follow the written steps.'],
};
