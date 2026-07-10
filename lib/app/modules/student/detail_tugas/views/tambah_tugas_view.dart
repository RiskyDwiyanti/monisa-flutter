// tambah_tugas_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';
import '../controllers/tambah_tugas_controller.dart';

class TambahTugasView extends StatefulWidget {
  const TambahTugasView({super.key});

  @override
  State<TambahTugasView> createState() => _TambahTugasViewState();
}

class _TambahTugasViewState extends State<TambahTugasView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  TambahTugasController get ctrl => Get.find<TambahTugasController>();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    const curve = _SpringCurve(stiffness: 256, damping: 24);

    _slideAnim = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: curve),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.0, 0.45, curve: Curves.easeOut)),
    );
    _scaleAnim = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: curve),
    );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnim,
        child: Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: Transform.scale(
            scale: _scaleAnim.value,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Obx(() => _buildFileGrid()),
                ),
              ),

              // Kirim button
              Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
                child: Obx(() => GestureDetector(
                  onTap: ctrl.isLoading.value ? null : ctrl.kirimTugas,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: ctrl.isLoading.value
                          ? AppColors.Tangerine.withOpacity(0.65)
                          : AppColors.Tangerine,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    child: Center(
                      child: ctrl.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              'Kirim tugas',
                              style: AppText.SubHeading.copyWith(color: AppColors.white),
                            ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileGrid() {
    final files = ctrl.attachedFiles;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
        children: [
          ...files.asMap().entries.map((e) => _FileCard(
                file: e.value,
                onRemove: () => ctrl.removeFile(e.key),
              )),
          _AddFileButton(onTap: ctrl.pickImage),
        ],
      ),
    );
  }
}

// ─── File Card ─────────────────────────────────────────────────────────────

class _FileCard extends StatelessWidget {
  final AttachedFile file;
  final VoidCallback onRemove;

  const _FileCard({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF0EBE0),
              child: Image.file(
                File(file.path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.insert_drive_file, size: 40, color: Colors.black54),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                file.name,
                style: AppText.Body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, size: 16, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Add File Button ────────────────────────────────────────────────────────

class _AddFileButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddFileButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black26, width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 36, color: Colors.black54),
        ),
      ),
    );
  }
}

// ─── Spring Curve ───────────────────────────────────────────────────────────

class _SpringCurve extends Curve {
  final double stiffness;
  final double damping;

  const _SpringCurve({required this.stiffness, required this.damping});

  @override
  double transformInternal(double t) {
    final sqrtOmega = stiffness.clamp(0.001, 1000.0);
    final zeta = damping / (2 * sqrtOmega);
    final omegaD = sqrtOmega * (zeta < 1 ? (1 - zeta * zeta).clamp(0.0, 1.0) : 0.0);

    if (zeta < 1 && omegaD > 0) {
      final decay = zeta * sqrtOmega;
      final envelope = _exp(-decay * t * 6);
      final oscillation = _cos(omegaD * t * 6);
      return 1.0 - envelope * oscillation;
    }
    final x = sqrtOmega * t * 6;
    return 1.0 - (1 + x) * _exp(-x);
  }

  static double _exp(double x) {
    if (x > 20) return 0.0;
    if (x < 0) return 1.0 / _exp(-x);
    double r = 1, t = 1;
    for (int i = 1; i <= 12; i++) { t *= x / i; r += t; }
    return r;
  }

  static double _cos(double x) {
    x = x % (2 * 3.14159265358979);
    double r = 1, t = 1;
    for (int i = 1; i <= 6; i++) { t *= -x * x / ((2*i-1) * (2*i)); r += t; }
    return r;
  }
}