class GradeState {

  final int participation;   // 10%
  final List<int> homeworks; // 4 items, 20% as average of 4
  final int presentation;    // 10%
  final int midterm1;        // 10%
  final int midterm2;        // 20%
  final int finalProject;    // 30%

  const GradeState({
    required this.participation,
    required this.homeworks,
    required this.presentation,
    required this.midterm1,
    required this.midterm2,
    required this.finalProject,
  });

  factory GradeState.defaults() => const GradeState(
    participation: 100,
    homeworks: [100, 100, 100, 100],
    presentation: 100,
    midterm1: 100,
    midterm2: 100,
    finalProject: 100,
  );

  GradeState copyWith({
    int? participation,
    List<int>? homeworks,
    int? presentation,
    int? midterm1,
    int? midterm2,
    int? finalProject,
  }) {
    return GradeState(
      participation: participation ?? this.participation,
      homeworks: homeworks ?? this.homeworks,
      presentation: presentation ?? this.presentation,
      midterm1: midterm1 ?? this.midterm1,
      midterm2: midterm2 ?? this.midterm2,
      finalProject: finalProject ?? this.finalProject,
    );
  }

  Map<String, dynamic> toMap() => {
    'participation': participation,
    'homeworks': homeworks,
    'presentation': presentation,
    'midterm1': midterm1,
    'midterm2': midterm2,
    'finalProject': finalProject,
  };

  factory GradeState.fromMap(Map<String, dynamic> map) {
    final rawList = (map['homeworks'] as List?)?.cast<int>() ?? [100, 100, 100, 100];
    final list = List<int>.from(rawList).map(_clamp).toList();
    return GradeState(
      participation: _clamp(map['participation'] as int? ?? 100),
      homeworks: list.length == 4 ? list : [100, 100, 100, 100],
      presentation: _clamp(map['presentation'] as int? ?? 100),
      midterm1: _clamp(map['midterm1'] as int? ?? 100),
      midterm2: _clamp(map['midterm2'] as int? ?? 100),
      finalProject: _clamp(map['finalProject'] as int? ?? 100),
    );
  }

  // Weighted final grade as per syllabus
  double computeFinal() {
    final hwAvg = homeworks.isEmpty
        ? 0.0
        : homeworks.reduce((a, b) => a + b) / homeworks.length;

    final total =
        participation * 0.10 +
            hwAvg * 0.20 +
            presentation * 0.10 +
            midterm1 * 0.10 +
            midterm2 * 0.20 +
            finalProject * 0.30;
    // Round to 2 decimals for display
    return double.parse(total.toStringAsFixed(2));
  }

  static int _clamp(int v) => v.clamp(0, 100);
}
