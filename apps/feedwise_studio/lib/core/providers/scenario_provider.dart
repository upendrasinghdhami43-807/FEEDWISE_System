import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scenario_model.dart';
import '../mock/mock_data.dart';

// ─── Scenario List Provider ───────────────────────────────────────────────────

class ScenariosNotifier extends StateNotifier<List<ScenarioModel>> {
  ScenariosNotifier() : super(MockData.scenarios);

  void filterByStatus(ScenarioStatus? status) {
    if (status == null) {
      state = MockData.scenarios;
    } else {
      state = MockData.scenarios.where((s) => s.status == status).toList();
    }
  }

  void filterByCategory(ScenarioCategory? category) {
    if (category == null) {
      state = MockData.scenarios;
    } else {
      state = MockData.scenarios.where((s) => s.category == category).toList();
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      state = MockData.scenarios;
    } else {
      final q = query.toLowerCase();
      state = MockData.scenarios.where((s) =>
        s.title.toLowerCase().contains(q) ||
        s.id.toLowerCase().contains(q) ||
        s.category.displayName.toLowerCase().contains(q)
      ).toList();
    }
  }

  void updateStatus(String scenarioId, ScenarioStatus newStatus) {
    state = state.map((s) {
      if (s.id == scenarioId) return s.copyWith(status: newStatus);
      return s;
    }).toList();
  }

  ScenarioModel? getById(String id) {
    try {
      return state.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Map<ScenarioStatus, int> get statusCounts {
    final counts = <ScenarioStatus, int>{};
    for (final status in ScenarioStatus.values) {
      counts[status] = MockData.scenarios.where((s) => s.status == status).length;
    }
    return counts;
  }
}

final scenariosProvider =
    StateNotifierProvider<ScenariosNotifier, List<ScenarioModel>>((ref) {
  return ScenariosNotifier();
});

final scenarioStatusCountsProvider = Provider<Map<ScenarioStatus, int>>((ref) {
  final notifier = ref.watch(scenariosProvider.notifier);
  return notifier.statusCounts;
});

// ─── Selected Scenario ────────────────────────────────────────────────────────

final selectedScenarioIdProvider = StateProvider<String?>((ref) => null);

final selectedScenarioProvider = Provider<ScenarioModel?>((ref) {
  final id = ref.watch(selectedScenarioIdProvider);
  if (id == null) return null;
  return ref.watch(scenariosProvider.notifier).getById(id);
});
