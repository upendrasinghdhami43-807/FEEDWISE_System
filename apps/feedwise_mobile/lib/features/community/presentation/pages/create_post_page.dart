import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _accountController = TextEditingController();
  final _urlController = TextEditingController();

  String _selectedPlatform = 'Facebook';
  String _selectedCategory = 'Science';
  DateTime? _selectedDate;

  final List<String> _platforms = ['Facebook', 'Instagram', 'TikTok', 'X/Twitter', 'Website', 'Other'];
  final List<String> _categories = ['Science', 'Politics', 'Health', 'Environment', 'Tech', 'Economy'];

  @override
  void dispose() {
    _noteController.dispose();
    _accountController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _onPreview() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a post date')),
        );
        return;
      }
      
      // In a real app, we would pass the data as an object to the preview page.
      // For this mockup, we'll just navigate to the preview page.
      context.pushNamed('postPreview');
    }
  }

  String get _accountHint {
    if (_selectedPlatform == 'Website') return 'Website Domain (e.g. news.com)';
    return 'Account Name / Handle';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Create Post', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submit a Scenario', style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              Text('Found a questionable claim online? Submit it for review and turn it into a learning scenario for the community.', 
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
              
              const SizedBox(height: 24),
              
              // Note
              Text('Short Note (Claim Context)', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  hintText: 'What is the main claim being made? (Max 150 words)',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark),
                  filled: true,
                  fillColor: AppColors.surfaceElevatedDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please write a short note';
                  final wordCount = val.trim().split(RegExp(r'\s+')).length;
                  if (wordCount > 150) return 'Note must be under 150 words';
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Platform
              Text('Information Platform', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPlatform,
                dropdownColor: AppColors.surfaceElevatedDark,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceElevatedDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _platforms.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPlatform = val);
                },
              ),
              
              const SizedBox(height: 20),
              
              // Account Name / Domain
              Text(_selectedPlatform == 'Website' ? 'Website Domain' : 'Account Name', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _accountController,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  hintText: _accountHint,
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark),
                  filled: true,
                  fillColor: AppColors.surfaceElevatedDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 20),
              
              // URL Link
              Text('Link URL', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _urlController,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark),
                  filled: true,
                  fillColor: AppColors.surfaceElevatedDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Required';
                  if (!Uri.parse(val).isAbsolute) return 'Please enter a valid URL';
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Post Date
              Text('Original Post Date', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevatedDark,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    _selectedDate == null ? 'Select Date' : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2,'0')}-${_selectedDate!.day.toString().padLeft(2,'0')}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: _selectedDate == null ? AppColors.textTertiaryDark : AppColors.textPrimaryDark
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Category
              Text('Topic Category', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((c) => ChoiceChip(
                  label: Text(c),
                  selected: _selectedCategory == c,
                  selectedColor: AppColors.primary500,
                  backgroundColor: AppColors.surfaceElevatedDark,
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: _selectedCategory == c ? Colors.white : AppColors.textSecondaryDark
                  ),
                  onSelected: (sel) {
                    if (sel) setState(() => _selectedCategory = c);
                  },
                )).toList(),
              ),
              
              const SizedBox(height: 40),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                child: FWButton(
                  label: 'Preview Post',
                  onPressed: _onPreview,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
