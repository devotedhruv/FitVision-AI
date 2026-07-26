import '../config/exercise_engine_config.dart';
import 'exercise_state.dart';

class RepTransition {
  const RepTransition({
    required this.changed,
    required this.repCompleted,
    required this.incomplete,
    required this.state,
  });
  final bool changed, repCompleted, incomplete;
  final ExerciseState state;
}

class RepStateMachine {
  RepStateMachine({
    required this.initialState,
    required this.sequence,
    this.config = const RepTimingConfig(),
  }) : _current = initialState;
  final ExerciseState initialState;
  final List<ExerciseState> sequence;
  final RepTimingConfig config;
  ExerciseState _current;
  ExerciseState? _previous, _candidate;
  int _candidateFrames = 0, _sequenceIndex = 0;
  Duration? _stateEntered, _repStart;
  bool _paused = false;
  ExerciseState get currentState => _paused ? ExerciseState.paused : _current;
  ExerciseState? get previousState => _previous;
  Duration? get stateEnteredTimestamp => _stateEntered;
  Duration? get repStartTimestamp => _repStart;
  int get consecutiveValidFrames => _candidateFrames;
  bool get isActiveRep => _repStart != null;

  RepTransition propose(ExerciseState state, Duration timestamp) {
    if (_paused || state == _current) {
      _candidate = null;
      _candidateFrames = 0;
      return RepTransition(
        changed: false,
        repCompleted: false,
        incomplete: false,
        state: currentState,
      );
    }
    if (_candidate != state) {
      _candidate = state;
      _candidateFrames = 1;
    } else {
      _candidateFrames++;
    }
    if (_candidateFrames < config.minimumStableFrames) {
      return RepTransition(
        changed: false,
        repCompleted: false,
        incomplete: false,
        state: currentState,
      );
    }
    _candidate = null;
    _candidateFrames = 0;
    var incomplete = false, completed = false;
    final expected = sequence[(_sequenceIndex + 1) % sequence.length];
    if (state == expected) {
      if (_sequenceIndex == 0) _repStart = timestamp;
      _sequenceIndex = (_sequenceIndex + 1) % sequence.length;
      if (_sequenceIndex == 0 && _repStart != null) {
        final duration = timestamp - _repStart!;
        completed =
            duration >= config.minimumDuration &&
            duration <= config.maximumDuration;
        incomplete = !completed;
        _repStart = null;
      }
    } else if (state == initialState && _repStart != null) {
      incomplete = true;
      _repStart = null;
      _sequenceIndex = 0;
    } else {
      return RepTransition(
        changed: false,
        repCompleted: false,
        incomplete: false,
        state: currentState,
      );
    }
    _previous = _current;
    _current = state;
    _stateEntered = timestamp;
    return RepTransition(
      changed: true,
      repCompleted: completed,
      incomplete: incomplete,
      state: currentState,
    );
  }

  bool abandonActiveRep() {
    final had = _repStart != null;
    _repStart = null;
    _sequenceIndex = 0;
    return had;
  }

  void pause() => _paused = true;
  void resume() {
    _paused = false;
    _candidate = null;
    _candidateFrames = 0;
  }

  void reset() {
    _current = initialState;
    _previous = null;
    _candidate = null;
    _candidateFrames = 0;
    _sequenceIndex = 0;
    _stateEntered = null;
    _repStart = null;
    _paused = false;
  }
}
