import 'package:equatable/equatable.dart';

enum EvidenceCategory {
  source('Source'),
  date('Date'),
  evidence('Evidence'),
  language('Language'),
  crossSource('Cross-Source'),
  aiAnalysis('AI Analysis');

  final String displayName;
  const EvidenceCategory(this.displayName);
}

enum EvidenceStatus {
  supported('Supported', '✅'),
  uncertain('Uncertain', '⚠️'),
  missing('Missing', '🔴'),
  neutral('Neutral', '⚪');

  final String displayName;
  final String emoji;
  const EvidenceStatus(this.displayName, this.emoji);
}

class EvidenceItem extends Equatable {
  final String id;
  final String scenarioId;
  final EvidenceCategory category;
  final EvidenceStatus status;
  final String label;
  final String value;
  final String explanation;
  final int sortOrder;

  const EvidenceItem({
    required this.id,
    required this.scenarioId,
    required this.category,
    required this.status,
    required this.label,
    required this.value,
    required this.explanation,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [id, scenarioId, category, status, label];
}

class EvidenceSet extends Equatable {
  final List<EvidenceItem> items;

  const EvidenceSet({required this.items});

  List<EvidenceItem> get byCategory =>
      List<EvidenceItem>.from(items)..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<EvidenceItem> whereStatus(EvidenceStatus status) =>
      items.where((e) => e.status == status).toList();

  int get supportedCount => whereStatus(EvidenceStatus.supported).length;
  int get uncertainCount => whereStatus(EvidenceStatus.uncertain).length;
  int get missingCount => whereStatus(EvidenceStatus.missing).length;

  double get overallScore {
    if (items.isEmpty) return 0.0;
    final total = items.length;
    final weighted = supportedCount * 1.0 + uncertainCount * 0.5 + missingCount * 0.0;
    return weighted / total;
  }

  EvidenceStatus get overallStatus {
    if (overallScore >= 0.7) return EvidenceStatus.supported;
    if (overallScore >= 0.4) return EvidenceStatus.uncertain;
    return EvidenceStatus.missing;
  }

  @override
  List<Object?> get props => [items];
}
