import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BeritaScreen extends StatelessWidget {
  const BeritaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        const Text('Berita & Informasi',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy)),
        const SizedBox(height: 16),
        _BeritaCard(
          kategori: 'Prestasi',
          tanggal: '15 Juli 2025',
          judul: 'Siswa SMK Negeri 3 Balige Raih Juara 1 Olimpiade Sains Nasional',
          deskripsi: 'Tim ini terdiri dari 30 orang siswa-siswi yang sukses mewakili provinsi Sumatera Utara.',
          warna: const Color(0xFF10B981),
        ),
        _BeritaCard(
          kategori: 'Budaya',
          tanggal: '10 Maret 2025',
          judul: 'Festival Adat dan Budaya 2025 Sukses Digelar',
          deskripsi: 'Acara festival Adat dan budaya Batak yang digelar dengan penuh antusias tinggi.',
          warna: AppColors.gold,
        ),
        _BeritaCard(
          kategori: 'Fasilitas',
          tanggal: '15 Maret 2025',
          judul: 'Peresmian Laboratorium Komputer Terbaru',
          deskripsi: 'Laboratorium komputer baru yang dilengkapi teknologi komputer terkini dalam era digital.',
          warna: AppColors.navy,
        ),
      ],
    );
  }
}

class _BeritaCard extends StatelessWidget {
  final String kategori;
  final String tanggal;
  final String judul;
  final String deskripsi;
  final Color warna;

  const _BeritaCard({
    required this.kategori,
    required this.tanggal,
    required this.judul,
    required this.deskripsi,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              color: warna,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: warna.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(kategori,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: warna)),
                    ),
                    const SizedBox(width: 8),
                    Text(tanggal,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textGrey)),
                  ]),
                  const SizedBox(height: 8),
                  Text(judul,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textDark,
                          height: 1.4)),
                  const SizedBox(height: 6),
                  Text(deskripsi,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Text('Baca Selengkapnya →',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
