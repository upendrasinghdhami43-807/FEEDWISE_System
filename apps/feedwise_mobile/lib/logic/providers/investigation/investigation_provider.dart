import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/data/models/skill_model.dart';
import 'package:feedwise_mobile/data/mock/mock_scenarios.dart';

class InvestigationState {
  final ScenarioModel? scenario;
  final bool isLoading;
  final Decision? selectedDecision;
  final DateTime startTime;

  const InvestigationState({
    this.scenario,
    this.isLoading = false,
    this.selectedDecision,
    required this.startTime,
  });

  InvestigationState copyWith({
    ScenarioModel? scenario,
    bool? isLoading,
    Decision? selectedDecision,
  }) =>
      InvestigationState(
        scenario: scenario ?? this.scenario,
        isLoading: isLoading ?? this.isLoading,
        selectedDecision: selectedDecision ?? this.selectedDecision,
        startTime: startTime,
      );

  Duration get investigationDuration => DateTime.now().difference(startTime);
}

class InvestigationController extends AutoDisposeFamilyNotifier<InvestigationState, String> {
  @override
  InvestigationState build(String scenarioId) {
    _loadScenario(scenarioId);
    return InvestigationState(startTime: DateTime.now(), isLoading: true);
  }

  Future<void> _loadScenario(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final scenario = MockScenarios.all.where((s) => s.id == id).firstOrNull;
    state = state.copyWith(scenario: scenario, isLoading: false);
  }

  void selectDecision(Decision decision) {
    state = state.copyWith(selectedDecision: decision);
  }
}

final investigationProvider = AutoDisposeNotifierProviderFamily<InvestigationController, InvestigationState, String>(
  InvestigationController.new,
);

// Skill provider (mock)
final skillsProvider = FutureProvider<SkillsModel>((ref) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return SkillsModel.demo();
});
