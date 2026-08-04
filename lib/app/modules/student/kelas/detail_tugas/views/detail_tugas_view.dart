import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/detail_tugas_controller.dart';
import '../controllers/tambah_tugas_controller.dart';

class DetailTugasView extends GetView<DetailTugasController> {
  const DetailTugasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _DetailTugasBody(controller: controller),
            ),
          ],
        ),
      ),
    );
  }

  // ============================== HEADER ==============================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Text('Detail Tugas', style: AppText.Header1),
        ],
      ),
    );
  }
}

// ============================== BODY ==============================

class _DetailTugasBody extends StatefulWidget {
  final DetailTugasController controller;
  const _DetailTugasBody({required this.controller});

  @override
  State<_DetailTugasBody> createState() => _DetailTugasBodyState();
}

class _DetailTugasBodyState extends State<_DetailTugasBody>
    with SingleTickerProviderStateMixin {

  bool _showTambahTugas = false;
  bool _isLoading = false;

  late AnimationController _animCtrl;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _guruFadeAnim;

  DetailTugasController get ctrl => widget.controller;
  TambahTugasController get tugasCtrl => Get.find<TambahTugasController>();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    const springCurve = _SpringCurve(stiffness: 256, damping: 24);

    _slideAnim = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: springCurve),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _guruFadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // Sync loading state dari controller ke setState
    tugasCtrl.isLoading.listen((val) {
      if (mounted) setState(() => _isLoading = val);
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onTambahTugasTap() {
    setState(() => _showTambahTugas = true);
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainCard(),
          const SizedBox(height: 16),
          _buildTambahTugasCardAnimated(),
          const SizedBox(height: 16),
          // ← hanya tampil saat belum klik tambah tugas
          if (!_showTambahTugas) _buildButton(),
        ],
      ),
    );
  }

  // ============================== MAIN CARD ==============================
  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + status
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(ctrl.title, style: AppText.Header2),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(ctrl.status, style: AppText.Body1_SemiBold),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.black, height: 1, thickness: 1),

          // Section guru — fade+collapse keluar saat tambah tugas muncul
          AnimatedBuilder(
            animation: _guruFadeAnim,
            builder: (context, child) => Opacity(
              opacity: _guruFadeAnim.value,
              child: SizeTransition(
                sizeFactor: _guruFadeAnim,
                axisAlignment: -1,
                child: child,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(ctrl.teacherAvatarUrl),
                    backgroundColor: Colors.grey[200],
                    onBackgroundImageError: (_, __) {},
                    child: ctrl.teacherAvatarUrl.isEmpty
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(ctrl.teacherName, style: AppText.Body1_SemiBold),
                ],
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(ctrl.description, style: AppText.Body2),
          ),

          // Dashed divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDashedDivider(),
          ),

          // Meta info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMetaRow(
                  icon: 'assets/icons/share_icon.svg',
                  label: 'Diunggah pada:',
                  value: ctrl.tanggal,
                ),
                const SizedBox(height: 10),
                _buildMetaRow(
                  icon: 'assets/icons/hourglass_icon.svg',
                  label: 'Tenggat:',
                  value: ctrl.tenggat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================== TAMBAH TUGAS CARD ==============================
  Widget _buildTambahTugasCardAnimated() {
    if (!_showTambahTugas) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnim,
        child: Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: child,
        ),
      ),
      child: _buildFileGrid(),
    );
  }

  Widget _buildFileGrid() {
    // Gunakan StatefulBuilder agar list file bisa rebuild sendiri
    return StatefulBuilder(
      builder: (context, setInnerState) {
        // Listen perubahan files via reaction
        // final files = tugasCtrl.attachedFiles.toList();
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(color: AppColors.black, width: 1),
                  left: BorderSide(color: AppColors.black, width: 1),
                  right: BorderSide(color: AppColors.black, width: 1),
                ),
              ),
              child: Obx(() {
                final files = tugasCtrl.attachedFiles;
                return Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.25,
                      children: [
                        ...files.asMap().entries.map((e) => _FileCard(
                              file: e.value,
                              onRemove: () => tugasCtrl.removeFile(e.key),
                            )),
                        _AddFileButton(onTap: tugasCtrl.pickImage),
                      ],
                    ),
                  ],
                );
              }),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: GestureDetector(
                onTap: _isLoading ? null : tugasCtrl.kirim,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isLoading
                        ? AppColors.Tangerine.withOpacity(0.65)
                        : AppColors.Tangerine,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Kirim tugas',
                            style: AppText.SubHeading.copyWith(color: AppColors.white),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================== BUTTON ==============================
  Widget _buildButton() {
    return GestureDetector(
      onTap: _onTambahTugasTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.Tangerine,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Tambahkan tugas',
              style: AppText.SubHeading.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  // ============================== HELPERS ==============================
  Widget _buildMetaRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 23, height: 23),
        const SizedBox(width: 8),
        Text(label, style: AppText.Body1),
        const SizedBox(width: 4),
        Text(value, style: AppText.Body1_SemiBold),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(builder: (context, constraints) {
      const dashWidth = 8.0;
      const dashSpace = 4.0;
      final count =
          (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Padding(
            padding: const EdgeInsets.only(right: dashSpace),
            child: Container(
                width: dashWidth, height: 1, color: Colors.black38),
          ),
        ),
      );
    });
  }
}

// ============================== FILE CARD ==============================
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF0EBE0),
                child: FutureBuilder<Uint8List>(
                  future: file.xFile.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Icon(Icons.broken_image,
                            size: 40, color: Colors.black38),
                      );
                    }
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
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

// ============================== ADD FILE BUTTON ==============================
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
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Center(
          child: Icon(Icons.add, size: 36, color: AppColors.black),
        ),
      ),
    );
  }
}

// ============================== SPRING CURVE ==============================
class _SpringCurve extends Curve {
  final double stiffness;
  final double damping;

  const _SpringCurve({required this.stiffness, required this.damping});

  @override
  double transformInternal(double t) {
    final sqrtOmega = stiffness.clamp(0.001, 1000.0);
    final zeta = damping / (2 * sqrtOmega);
    final omegaD =
        sqrtOmega * (zeta < 1 ? (1 - zeta * zeta).clamp(0.0, 1.0) : 0.0);

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
    double r = 1, term = 1;
    for (int i = 1; i <= 12; i++) {
      term *= x / i;
      r += term;
    }
    return r;
  }

  static double _cos(double x) {
    x = x % (2 * 3.14159265358979);
    double r = 1, term = 1;
    for (int i = 1; i <= 6; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      r += term;
    }
    return r;
  }
}