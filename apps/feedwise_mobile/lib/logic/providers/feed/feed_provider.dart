import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/data/mock/mock_scenarios.dart';

final feedFilterProvider = StateProvider<String>((ref) => 'All');

final feedProvider = FutureProvider<List<ContentItemModel>>((ref) async {
  final filter = ref.watch(feedFilterProvider);
  await Future.delayed(const Duration(milliseconds: 400));

  final scenarios = MockScenarios.all;
  final items = scenarios.map((s) => s.content).toList();

  if (filter == 'All') return items;
  if (filter == 'Trending') return items.where((i) => i.isTrending).toList();

  return items.where((i) => i.tags.any((t) => t.toLowerCase() == filter.toLowerCase())).toList();
});

final scenarioByIdProvider = FutureProvider.family<ScenarioModel?, String>((ref, id) async {
  await Future.delayed(const Duration(milliseconds: 200));
  try {
    return MockScenarios.all.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
});

final allScenariosProvider = FutureProvider<List<ScenarioModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return MockScenarios.all;
});
