import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PortofolioScreen extends StatelessWidget {
  const PortofolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        const Text('Portofolio & Skill',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy)),
        const SizedBox(height: 4),
        const Text('Karya dan kemampuan siswa SMK Negeri 3 Balige',
            style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: const [
            _PortoCard(
                judul: 'Desain Grafis',
                kategori: 'Multimedia',
                icon: Icons.design_services_rounded,
                color: Color(0xFF7B1FA2)),
            _PortoCard(
                judul: 'Pemrograman Web',
                kategori: 'TKJ',
                icon: Icons.code_rounded,
                color: AppColors.navy),
            _PortoCard(
                judul: 'Animasi 3D',
                kategori: 'Multimedia',
                icon: Icons.threed_rotation_rounded,
                color: Color(0xFF7B1FA2)),
            _PortoCard(
                judul: 'Jaringan Komputer',
                kategori: 'TKJ',
                icon: Icons.router_rounded,
                color: AppColors.navy),
            _PortoCard(
                judul: 'Laporan Keuangan',
                kategori: 'Akuntansi',
                icon: Icons.bar_chart_rounded,
                color: Color(0xFF1565C0)),
            _PortoCard(
                judul: 'Editing Video',
                kategori: 'Multimedia',
                icon: Icons.video_collection_rounded,
                color: Color(0xFF7B1FA2)),
          ],
        ),
      ],
    );
  }
}

class _PortoCard extends StatelessWidget {
  final String judul;
  final String kategori;
  final IconData icon;
  final Color color;

  const _PortoCard(
      {required this.judul,
      required this.kategori,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(judul,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textDark)),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(kategori,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ),
        ],
      ),
    );
  }
}
