import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/profil_provider.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../data/models/profil_models.dart';
import '../../core/constants/api_constants.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<ProfilProvider>();
      if (p.state == LoadState.idle) p.loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.navy,
      onRefresh: () => context.read<ProfilProvider>().loadAll(),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _HeroBanner(onNavigate: widget.onNavigate),
          _StatsRow(),
          _ProfilSekolahPreview(onNavigate: widget.onNavigate),
          _TentangSekolah(),
          _JurusanPreview(onNavigate: widget.onNavigate),
          _BeritaSection(),
          _MitraSection(),
          _KontakFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Hero Banner ─────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final Function(int) onNavigate;
  const _HeroBanner({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDark, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // decorative circles
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TAHUN AJARAN 2024/2025',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'SMK NEGERI 3\nBALIGE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bergabunglah dengan kami dalam mencetak masa depan yang cerah melalui pendidikan berkualitas, fasilitas modern, dan pengajaran yang inovatif.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => onNavigate(2), // ke Profil Sekolah
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profil Sekolah',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            color: AppColors.navy, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Row ────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          _StatItem(value: '1200+', label: 'Siswa Aktif', icon: Icons.people_rounded),
          _vDivider(),
          _StatItem(value: '85+', label: 'Tenaga Pengajar', icon: Icons.person_rounded),
          _vDivider(),
          _StatItem(value: '3', label: 'Program Keahlian', icon: Icons.school_rounded),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 40,
        color: AppColors.borderColor,
      );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Profil Sekolah Preview ───────────────────────────────────
class _ProfilSekolahPreview extends StatelessWidget {
  final Function(int) onNavigate;
  const _ProfilSekolahPreview({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilProvider>(
      builder: (_, p, __) {
        if (p.state != LoadState.loaded) return const SizedBox.shrink();

        final visi = p.visi;
        final misiList = p.misiList;
        if (visi == null && misiList.isEmpty) return const SizedBox.shrink();

        return Container(
          color: AppColors.lightBg,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SectionHeader(title: 'Profil Sekolah'),
              const SizedBox(height: 16),
              // Visi card
              if (visi != null) _MiniVisiCard(visi: visi),
              const SizedBox(height: 12),
              // Misi preview (max 3)
              if (misiList.isNotEmpty)
                _MiniMisiCard(misiList: misiList.take(3).toList()),
              const SizedBox(height: 16),
              // Lihat selengkapnya
              GestureDetector(
                onTap: () => onNavigate(2),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.navy),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lihat Profil Lengkap',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded,
                          color: AppColors.navy, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniVisiCard extends StatelessWidget {
  final VisiMisiModel visi;
  const _MiniVisiCard({required this.visi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.visibility_rounded,
                  color: AppColors.navy, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('VISI',
                style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5)),
          ]),
          const SizedBox(height: 10),
          Text(visi.deskripsi,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  height: 1.6)),
        ],
      ),
    );
  }
}

class _MiniMisiCard extends StatelessWidget {
  final List<VisiMisiModel> misiList;
  const _MiniMisiCard({required this.misiList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flag_rounded,
                  color: AppColors.navy, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('MISI',
                style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5)),
          ]),
          const SizedBox(height: 12),
          ...misiList.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.value.deskripsi,
                          style: const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: AppColors.textDark)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Tentang Sekolah ──────────────────────────────────────────
class _TentangSekolah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilProvider>(
      builder: (_, p, __) {
        if (p.state != LoadState.loaded || p.sejarahList.isEmpty) {
          return const SizedBox.shrink();
        }
        final item = p.sejarahList.first;
        return Container(
          color: AppColors.cardBg,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Tentang Sekolah'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Text(
                  item.deskripsi,
                  style: const TextStyle(
                      fontSize: 13,
                      height: 1.7,
                      color: AppColors.textDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Jurusan Preview ──────────────────────────────────────────
class _JurusanPreview extends StatelessWidget {
  final Function(int) onNavigate;
  const _JurusanPreview({required this.onNavigate});

  static const _colors = [
    AppColors.navy,
    Color(0xFF7B1FA2),
    Color(0xFF1565C0),
  ];
  static const _icons = [
    Icons.computer_rounded,
    Icons.movie_creation_rounded,
    Icons.calculate_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilProvider>(
      builder: (_, p, __) {
        if (p.state != LoadState.loaded || p.programList.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          color: AppColors.lightBg,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SectionHeader(
                title: 'Jurusan Di SMK Negeri 3 Balige',
                subtitle: 'Pilih program keahlian di SMK Negeri 3 Balige',
              ),
              const SizedBox(height: 16),
              ...p.programList.asMap().entries.map((e) {
                final idx = e.key % _colors.length;
                final color = _colors[idx];
                final icon = _icons[idx];
                return _JurusanCard(
                  item: e.value,
                  color: color,
                  icon: icon,
                  onTap: () => onNavigate(2),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _JurusanCard extends StatelessWidget {
  final ProgramKeahlianModel item;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _JurusanCard(
      {required this.item,
      required this.color,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 5, color: color),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.namaJurusan,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppColors.navy)),
                        if (item.deskripsi?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.deskripsi!,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                                height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Detail',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Berita Section (placeholder) ─────────────────────────────
class _BeritaSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(title: 'Berita Terbaru & Pengumuman'),
          const SizedBox(height: 16),
          // Placeholder cards berita
          ...[
            _BeritaItem(
              kategori: 'Prestasi',
              tanggal: '15 Juli 2025',
              judul: 'Siswa SMK Negeri 3 Balige Raih Juara 1 Olimpiade Sains Nasional',
              warna: const Color(0xFF10B981),
            ),
            _BeritaItem(
              kategori: 'Budaya',
              tanggal: '10 Maret 2025',
              judul: 'Festival Adat dan Budaya 2025 Sukses Digelar',
              warna: AppColors.gold,
            ),
            _BeritaItem(
              kategori: 'Fasilitas',
              tanggal: '15 Maret 2025',
              judul: 'Peresmian Laboratorium Komputer Terbaru',
              warna: AppColors.navy,
            ),
          ],
        ],
      ),
    );
  }
}

class _BeritaItem extends StatelessWidget {
  final String kategori;
  final String tanggal;
  final String judul;
  final Color warna;

  const _BeritaItem(
      {required this.kategori,
      required this.tanggal,
      required this.judul,
      required this.warna});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: warna),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
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
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(judul,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.textDark,
                              height: 1.4)),
                      const SizedBox(height: 8),
                      Text('Baca Selengkapnya →',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.navy,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Mitra Section ────────────────────────────────────────────
class _MitraSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilProvider>(builder: (_, p, __) {
      if (p.state != LoadState.loaded || p.mitraList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        color: AppColors.lightBg,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SectionHeader(title: 'Mitra Kerjasama'),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: p.mitraList.length,
              itemBuilder: (_, i) {
                final m = p.mitraList[i];
                final url = m.logo != null && m.logo!.isNotEmpty
                    ? (m.logo!.startsWith('http')
                        ? m.logo!
                        : '${ApiConstants.uploadsUrl}/${m.logo!.replaceAll('uploads/', '')}')
                    : null;
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (url != null)
                        Expanded(
                          child: Image.network(url,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.business_rounded,
                                  color: AppColors.navy,
                                  size: 24)),
                        )
                      else
                        const Icon(Icons.business_rounded,
                            color: AppColors.navy, size: 28),
                      const SizedBox(height: 4),
                      Text(m.namaMitra,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

// ── Kontak Footer ────────────────────────────────────────────
class _KontakFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kontak',
              style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.5)),
          const SizedBox(height: 4),
          const Text('Sekolah',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22)),
          const SizedBox(height: 16),
          _KItem(Icons.location_on_rounded,
              'Jl. Patuan Nagari No. 162, Balige, Toba Samosir 22314'),
          _KItem(Icons.phone_rounded, '+62 632 21014'),
          _KItem(Icons.email_rounded, 'info@smkn3balige.sch.id'),
          _KItem(Icons.access_time_rounded, 'Senin–Jumat: 07.00–15.00 WIB'),
          const SizedBox(height: 16),
          Row(
            children: [
              _SocBtn(Icons.facebook_rounded, 'Facebook'),
              const SizedBox(width: 10),
              _SocBtn(Icons.camera_alt_rounded, 'Instagram'),
            ],
          ),
        ],
      ),
    );
  }
}

class _KItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _KItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _SocBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocBtn(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style:
                  const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
