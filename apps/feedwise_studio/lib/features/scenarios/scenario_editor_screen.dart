import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/models/scenario_model.dart';
import '../../core/providers/scenario_provider.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_text_field.dart';

class ScenarioEditorScreen extends ConsumerStatefulWidget {
  final String? scenarioId;
  const ScenarioEditorScreen({super.key, this.scenarioId});

  @override
  ConsumerState<ScenarioEditorScreen> createState() => _ScenarioEditorScreenState();
}

class _ScenarioEditorScreenState extends ConsumerState<ScenarioEditorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _idCtrl     = TextEditingController();
  final _titleCtrl  = TextEditingController();
  final _descCtrl   = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _headlineCtrl = TextEditingController();
  final _bodyCtrl   = TextEditingController();
  final _likesCtrl  = TextEditingController(text: '0');
  final _commentsCtrl = TextEditingController(text: '0');
  final _sharesCtrl = TextEditingController(text: '0');
  final _lessonTitleCtrl = TextEditingController();
  final _explanationCtrl = TextEditingController();
  final _takeawayCtrl = TextEditingController();

  ScenarioCategory _category  = ScenarioCategory.sourceVerification;
  DifficultyLevel _difficulty = DifficultyLevel.intermediate;
  Decision _expectedAction    = Decision.verify;
  ScenarioStatus _status      = ScenarioStatus.draft;
  List<String> _languages     = ['en'];
  bool _isSaving = false;

  bool get _isEditing => widget.scenarioId != null;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 5, vsync: this);
    if (_isEditing) _loadScenario();
  }

  void _loadScenario() {
    final scenario = ref.read(scenariosProvider.notifier).getById(widget.scenarioId!);
    if (scenario == null) return;
    _idCtrl.text       = scenario.id;
    _titleCtrl.text    = scenario.title;
    _descCtrl.text     = scenario.description ?? '';
    _sourceCtrl.text   = scenario.sourceName;
    _headlineCtrl.text = scenario.headline;
    _bodyCtrl.text     = scenario.body ?? '';
    _likesCtrl.text    = scenario.likes.toString();
    _commentsCtrl.text = scenario.comments.toString();
    _sharesCtrl.text   = scenario.shares.toString();
    _lessonTitleCtrl.text = scenario.lessonTitle;
    _explanationCtrl.text = scenario.explanation;
    _takeawayCtrl.text    = scenario.keyTakeaway;
    _category       = scenario.category;
    _difficulty     = scenario.difficulty;
    _expectedAction = scenario.expectedAction;
    _status         = scenario.status;
    _languages      = List.from(scenario.languages);
    setState(() {});
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _idCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _sourceCtrl.dispose();
    _headlineCtrl.dispose();
    _bodyCtrl.dispose();
    _likesCtrl.dispose();
    _commentsCtrl.dispose();
    _sharesCtrl.dispose();
    _lessonTitleCtrl.dispose();
    _explanationCtrl.dispose();
    _takeawayCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(ScenarioStatus newStatus) async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() { _isSaving = false; _status = newStatus; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Scenario ${newStatus == ScenarioStatus.draft ? 'saved as draft' : 'submitted for review'}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: _isEditing ? 'Edit Scenario' : 'New Scenario',
      actions: [
        FWButton(
          label: 'Save Draft',
          variant: FWButtonVariant.ghost,
          onPressed: () => _save(ScenarioStatus.draft),
          size: FWButtonSize.small,
          isLoading: _isSaving,
        ),
        const SizedBox(width: 8),
        FWButton(
          label: 'Submit for Review',
          icon: Icons.send_outlined,
          onPressed: () => _save(ScenarioStatus.inReview),
          size: FWButtonSize.small,
        ),
      ],
      child: Column(
        children: [
          // Tab bar
          Container(
            color: AppColors.surfaceCardDark,
            child: TabBar(
              controller: _tabCtrl,
              isScrollable: true,
              indicatorColor: AppColors.primary500,
              labelColor: AppColors.primary400,
              unselectedLabelColor: AppColors.textSecondaryDark,
              indicatorWeight: 2,
              labelStyle: AppTypography.labelMedium(),
              unselectedLabelStyle: AppTypography.labelMedium(),
              tabs: const [
                Tab(text: '① Basic Info'),
                Tab(text: '② Content'),
                Tab(text: '③ Evidence'),
                Tab(text: '④ Consequences'),
                Tab(text: '⑤ Lesson'),
              ],
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _BasicInfoTab(
                    idCtrl: _idCtrl,
                    titleCtrl: _titleCtrl,
                    descCtrl: _descCtrl,
                    category: _category,
                    difficulty: _difficulty,
                    expectedAction: _expectedAction,
                    languages: _languages,
                    onCategoryChanged: (v) => setState(() => _category = v),
                    onDifficultyChanged: (v) => setState(() => _difficulty = v),
                    onActionChanged: (v) => setState(() => _expectedAction = v),
                    onLanguageToggled: (lang) => setState(() {
                      if (_languages.contains(lang)) {
                        _languages.remove(lang);
                      } else {
                        _languages.add(lang);
                      }
                    }),
                  ),
                  _ContentTab(
                    sourceCtrl: _sourceCtrl,
                    headlineCtrl: _headlineCtrl,
                    bodyCtrl: _bodyCtrl,
                    likesCtrl: _likesCtrl,
                    commentsCtrl: _commentsCtrl,
                    sharesCtrl: _sharesCtrl,
                  ),
                  const _EvidenceTab(),
                  const _ConsequencesTab(),
                  _LessonTab(
                    titleCtrl: _lessonTitleCtrl,
                    explanationCtrl: _explanationCtrl,
                    takeawayCtrl: _takeawayCtrl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab Widgets ──────────────────────────────────────────────────────────────

class _BasicInfoTab extends StatelessWidget {
  final TextEditingController idCtrl, titleCtrl, descCtrl;
  final ScenarioCategory category;
  final DifficultyLevel difficulty;
  final Decision expectedAction;
  final List<String> languages;
  final ValueChanged<ScenarioCategory> onCategoryChanged;
  final ValueChanged<DifficultyLevel> onDifficultyChanged;
  final ValueChanged<Decision> onActionChanged;
  final ValueChanged<String> onLanguageToggled;

  const _BasicInfoTab({
    required this.idCtrl,
    required this.titleCtrl,
    required this.descCtrl,
    required this.category,
    required this.difficulty,
    required this.expectedAction,
    required this.languages,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
    required this.onActionChanged,
    required this.onLanguageToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Basic Information'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: FWTextField(label: 'Scenario ID', hint: 'FW-AI-001', controller: idCtrl)),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: FWTextField(label: 'Title', hint: 'Descriptive scenario title', controller: titleCtrl)),
              ],
            ),
            const SizedBox(height: 16),
            FWTextField(label: 'Description', hint: 'Brief description of the scenario...', controller: descCtrl, maxLines: 3),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _DropdownField<ScenarioCategory>(
                  label: 'Category',
                  value: category,
                  items: ScenarioCategory.values,
                  labelOf: (c) => '${c.emoji} ${c.displayName}',
                  onChanged: onCategoryChanged,
                )),
                const SizedBox(width: 16),
                Expanded(child: _DropdownField<DifficultyLevel>(
                  label: 'Difficulty',
                  value: difficulty,
                  items: DifficultyLevel.values,
                  labelOf: (d) => '${d.dots} ${d.label}',
                  onChanged: onDifficultyChanged,
                )),
              ],
            ),
            const SizedBox(height: 16),
            _DropdownField<Decision>(
              label: 'Expected Action (Correct Answer)',
              value: expectedAction,
              items: Decision.values,
              labelOf: (d) => '${d.icon} ${d.label}',
              onChanged: onActionChanged,
            ),
            const SizedBox(height: 20),

            // Languages
            const Text('Languages', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['en', 'ne', 'hi', 'bn', 'ur'].map((lang) =>
                FilterChip(
                  label: Text(lang.toUpperCase()),
                  selected: languages.contains(lang),
                  onSelected: (_) => onLanguageToggled(lang),
                  selectedColor: AppColors.primary500.withValues(alpha: 0.2),
                  backgroundColor: AppColors.surfaceElevatedDark,
                  labelStyle: TextStyle(
                    color: languages.contains(lang) ? AppColors.primary400 : AppColors.textSecondaryDark,
                    fontSize: 12, fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(color: languages.contains(lang) ? AppColors.primary500 : AppColors.borderDark),
                  showCheckmark: false,
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentTab extends StatelessWidget {
  final TextEditingController sourceCtrl, headlineCtrl, bodyCtrl, likesCtrl, commentsCtrl, sharesCtrl;

  const _ContentTab({
    required this.sourceCtrl,
    required this.headlineCtrl,
    required this.bodyCtrl,
    required this.likesCtrl,
    required this.commentsCtrl,
    required this.sharesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Content — Feed Post'),
            const SizedBox(height: 20),
            FWTextField(label: 'Source Name', hint: 'e.g. NepaliTechBuzz, HealthGuru_Official', controller: sourceCtrl),
            const SizedBox(height: 16),
            FWTextField(label: 'Headline', hint: 'The viral post headline...', controller: headlineCtrl, maxLines: 2),
            const SizedBox(height: 16),
            FWTextField(label: 'Body Text', hint: 'Full content of the post...', controller: bodyCtrl, maxLines: 5),
            const SizedBox(height: 16),

            // Image upload placeholder
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderDark, style: BorderStyle.solid),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 32, color: AppColors.textTertiaryDark),
                    SizedBox(height: 8),
                    Text('Upload Post Image', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14)),
                    Text('PNG, JPG up to 5MB', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Social metrics
            const Text('Social Metrics', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: FWTextField(label: '❤️ Likes',    hint: '0', controller: likesCtrl,    keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: FWTextField(label: '💬 Comments', hint: '0', controller: commentsCtrl, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: FWTextField(label: '↗ Shares',   hint: '0', controller: sharesCtrl,   keyboardType: TextInputType.number)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EvidenceTab extends StatelessWidget {
  const _EvidenceTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Evidence Data'),
            const SizedBox(height: 6),
            const Text('Define what students discover when they investigate each evidence category.', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
            const SizedBox(height: 24),
            ...['Source', 'Date', 'Evidence', 'Language', 'Cross-Sources'].map(
              (cat) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _EvidenceEditor(category: cat),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvidenceEditor extends StatefulWidget {
  final String category;
  const _EvidenceEditor({required this.category});

  @override
  State<_EvidenceEditor> createState() => _EvidenceEditorState();
}

class _EvidenceEditorState extends State<_EvidenceEditor> {
  bool _expanded = false;
  String _status = 'neutral';

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (_status) {
      'supported' => AppColors.evidenceSupported,
      'uncertain' => AppColors.evidenceUncertain,
      'missing'   => AppColors.evidenceMissing,
      _           => AppColors.evidenceNeutral,
    };

    return FWCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevatedDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(widget.category.toUpperCase(), style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
                const SizedBox(width: 6),
                Text(_status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                const Spacer(),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textTertiaryDark, size: 20),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 16),
            // Status selector
            Row(
              children: ['supported', 'uncertain', 'missing', 'neutral'].map((s) {
                final c = switch (s) {
                  'supported' => AppColors.evidenceSupported,
                  'uncertain' => AppColors.evidenceUncertain,
                  'missing'   => AppColors.evidenceMissing,
                  _           => AppColors.evidenceNeutral,
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _status == s ? c.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _status == s ? c : AppColors.borderDark),
                      ),
                      child: Text(s[0].toUpperCase() + s.substring(1), style: TextStyle(color: _status == s ? c : AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const FWTextField(label: 'Label', hint: 'e.g. Source credibility'),
            const SizedBox(height: 10),
            const FWTextField(label: 'Value', hint: 'What students see'),
            const SizedBox(height: 10),
            const FWTextField(label: 'Explanation', hint: 'Why this evidence matters...', maxLines: 2),
          ],
        ],
      ),
    );
  }
}

class _ConsequencesTab extends StatelessWidget {
  const _ConsequencesTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Consequences'),
            const SizedBox(height: 6),
            const Text('Define what happens after students make each decision.', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
            const SizedBox(height: 24),
            ...Decision.values.map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ConsequenceEditor(decision: d),
            )),
          ],
        ),
      ),
    );
  }
}

class _ConsequenceEditor extends StatefulWidget {
  final Decision decision;
  const _ConsequenceEditor({required this.decision});

  @override
  State<_ConsequenceEditor> createState() => _ConsequenceEditorState();
}

class _ConsequenceEditorState extends State<_ConsequenceEditor> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = {
      Decision.share:  AppColors.error,
      Decision.verify: AppColors.success,
      Decision.report: AppColors.warning,
      Decision.ignore: AppColors.textSecondaryDark,
    };
    final color = colors[widget.decision] ?? AppColors.textSecondaryDark;

    return FWCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${widget.decision.icon} ${widget.decision.label}',
                    style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textTertiaryDark, size: 20),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: FWTextField(label: 'Reach (people)', hint: '10000')),
                SizedBox(width: 12),
                Expanded(child: FWTextField(label: 'Further Shares', hint: '500')),
                SizedBox(width: 12),
                Expanded(child: FWTextField(label: 'Credibility Δ', hint: '+10 or -15')),
              ],
            ),
            const SizedBox(height: 12),
            const FWTextField(label: 'Community Impact', hint: 'Describe real-world consequences...', maxLines: 2),
            const SizedBox(height: 12),
            const FWTextField(label: 'Explanation', hint: 'Why this decision leads to this outcome...', maxLines: 2),
          ],
        ],
      ),
    );
  }
}

class _LessonTab extends StatelessWidget {
  final TextEditingController titleCtrl, explanationCtrl, takeawayCtrl;
  const _LessonTab({required this.titleCtrl, required this.explanationCtrl, required this.takeawayCtrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('MIL Lesson'),
            const SizedBox(height: 20),
            FWTextField(label: 'Lesson Title', hint: 'What skill does this teach?', controller: titleCtrl),
            const SizedBox(height: 16),
            FWTextField(label: 'Explanation', hint: 'Explain the key MIL concept in detail...', controller: explanationCtrl, maxLines: 5),
            const SizedBox(height: 16),
            FWTextField(label: 'Key Takeaway', hint: 'The most important thing students should remember.', controller: takeawayCtrl, maxLines: 2),
            const SizedBox(height: 20),

            // Target Skills
            const Text('Target Skills', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Source Verification', 'Evidence Evaluation', 'AI Literacy', 'Bias Detection', 'Digital Safety',
              ].map((s) => FilterChip(
                label: Text(s),
                selected: false,
                onSelected: (_) {},
                backgroundColor: AppColors.surfaceElevatedDark,
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                side: const BorderSide(color: AppColors.borderDark),
                showCheckmark: false,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTypography.headlineSmall(AppColors.textPrimaryDark)),
      const SizedBox(height: 4),
      Container(width: 40, height: 3, decoration: BoxDecoration(gradient: const LinearGradient(colors: AppColors.heroGradientColors), borderRadius: BorderRadius.circular(2))),
    ],
  );
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: AppColors.surfaceElevatedDark,
            style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
            items: items.map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelOf(item)),
            )).toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ),
      ],
    );
  }
}
