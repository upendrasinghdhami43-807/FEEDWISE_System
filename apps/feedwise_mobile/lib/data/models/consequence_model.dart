import 'package:equatable/equatable.dart';
import 'scenario_model.dart';

class ConsequenceModel extends Equatable {
  final String id;
  final String scenarioId;
  final Decision decision;
  final int reach;
  final int furtherShares;
  final int credibilityDelta;
  final List<String> missedClues;
  final String explanation;

  const ConsequenceModel({
    required this.id,
    required this.scenarioId,
    required this.decision,
    required this.reach,
    required this.furtherShares,
    required this.credibilityDelta,
    required this.missedClues,
    required this.explanation,
  });

  bool get isPositive => credibilityDelta >= 0;

  String get formattedReach {
    if (reach >= 1000000) return '${(reach / 1000000).toStringAsFixed(1)}M';
    if (reach >= 1000) return '${(reach / 1000).toStringAsFixed(1)}K';
    return reach.toString();
  }

  @override
  List<Object?> get props => [id, scenarioId, decision, reach];
}
