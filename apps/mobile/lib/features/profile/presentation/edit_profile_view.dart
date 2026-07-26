import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/features/profile/data/profile_repository.dart';
import 'package:fitvision_ai/features/profile/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({required this.profile, super.key});
  final UserProfile profile;

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController name;
  late final TextEditingController height;
  late final TextEditingController weight;
  late final TextEditingController targetWeight;
  late final TextEditingController goal;
  late final TextEditingController limitations;
  late String units;
  late String fitnessLevel;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    name = TextEditingController(text: profile.displayName);
    height = TextEditingController(
      text: profile.heightCm?.toStringAsFixed(0) ?? '',
    );
    weight = TextEditingController(
      text: profile.weightKg?.toStringAsFixed(1) ?? '',
    );
    targetWeight = TextEditingController(
      text: profile.targetWeightKg?.toStringAsFixed(1) ?? '',
    );
    goal = TextEditingController(text: profile.fitnessGoal ?? '');
    limitations = TextEditingController(
      text: profile.movementLimitations ?? '',
    );
    units = profile.preferredUnits;
    fitnessLevel = profile.fitnessLevel ?? 'beginner';
  }

  @override
  void dispose() {
    for (final controller in [
      name,
      height,
      weight,
      targetWeight,
      goal,
      limitations,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _number(TextEditingController controller) =>
      controller.text.trim().isEmpty
      ? null
      : double.tryParse(controller.text.trim());

  Future<void> _save() async {
    final heightCm = _number(height);
    final weightKg = _number(weight);
    if (name.text.trim().isEmpty ||
        (heightCm != null && (heightCm < 80 || heightCm > 260)) ||
        (weightKg != null && (weightKg < 25 || weightKg > 400))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Check your name, height (80–260 cm), and weight (25–400 kg).',
          ),
        ),
      );
      return;
    }
    setState(() => saving = true);
    try {
      await ref
          .read(profileRepositoryProvider)
          .update(
            displayName: name.text.trim(),
            preferredUnits: units,
            fields: {
              'height_cm': heightCm,
              'weight_kg': weightKg,
              'target_weight_kg': _number(targetWeight),
              'fitness_level': fitnessLevel,
              'fitness_goal': goal.text.trim().isEmpty
                  ? null
                  : goal.text.trim(),
              'movement_limitations': limitations.text.trim().isEmpty
                  ? null
                  : limitations.text.trim(),
            },
          );
      ref.invalidate(currentProfileProvider);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile could not be saved. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Edit profile'),
      actions: [
        TextButton(onPressed: saving ? null : _save, child: const Text('Save')),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const _Heading('Personal information'),
        TextField(
          controller: name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _Heading('Health profile'),
        const Text(
          'Used to personalize fitness guidance. FitVision AI is not a medical service.',
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: height,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Height',
            suffixText: 'cm',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: weight,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Weight',
            suffixText: 'kg',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: targetWeight,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Target weight (optional)',
            suffixText: 'kg',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _Heading('Fitness preferences'),
        DropdownButtonFormField<String>(
          initialValue: fitnessLevel,
          decoration: const InputDecoration(labelText: 'Fitness level'),
          items: const [
            DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
            DropdownMenuItem(
              value: 'intermediate',
              child: Text('Intermediate'),
            ),
            DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
          ],
          onChanged: (value) =>
              setState(() => fitnessLevel = value ?? fitnessLevel),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: goal,
          decoration: const InputDecoration(labelText: 'Primary fitness goal'),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: limitations,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Injuries or movement limitations (optional)',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'metric', label: Text('Metric')),
            ButtonSegment(value: 'imperial', label: Text('Imperial')),
          ],
          selected: {units},
          onSelectionChanged: (value) => setState(() => units = value.first),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: saving ? null : _save,
          child: Text(saving ? 'Saving…' : 'Save profile'),
        ),
      ],
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge),
  );
}
