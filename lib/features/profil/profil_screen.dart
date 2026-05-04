import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';
import '../../providers/profil_provider.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../data/models/profil_models.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<ProfilProvider>();
      if (p.state == LoadState.idle || p.state == LoadState.error) p.loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilProvider>(builder: (_, p, __) {
      if (p.state == LoadState.loading) {
        return const Scaffold(
          backgroundColor: AppColors.lightBg,
          body: LoadingWidget(),
        );
      }
      if (p.state == LoadState.error) {
        return Scaffold(
          backgroundColor: AppColors.lightBg,
          body: ErrorRetryWidget(
            message: p.errorMsg,
            onRetry: p.loadAll,
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.navy,
        onRefresh: p.loadAll,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _HeroSection(),
            _SejarahSection(list: p.sejarahList),
            _VisiMisiSection(provider: p),
            _StrukturSection(list: p.strukturList),
            _FasilitasSection(list: p.fasilitasList),
            _PrestasiSection(list: p.prestasiList),
            _JurusanSection(list: p.programList),
            _MitraSection(list: p.mitraList),
            _KontakSection(),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}

// ────────────────────────────────────────────────────────────────────
// HERO
// ────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
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
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
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
                  child: const Text('PROFIL SEKOLAH',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                          letterSpacing: 1.2)),
                ),
                const SizedBox(height: 10),
                const Text(
                  'PROFIL SMK\nNEGERI 3\nBALIGE',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bergabunglah dengan kami dalam mencetak masa depan yang cerah melalui pendidikan berkualitas, fasilitas modern, dan pengajaran yang inovatif.',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// SEJARAH & IDENTITAS
// ────────────────────────────────────────────────────────────────────
class _SejarahSection extends StatelessWidget {
  final List<SejarahIdentitasModel> list;
  const _SejarahSection({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const SizedBox.shrink();
    final item = list.first;
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Sejarah & Identitas'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.tahunBerdiri != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Berdiri Tahun ${item.tahunBerdiri}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                Text(
                  item.deskripsi,
                  style: const TextStyle(
                      fontSize: 13, height: 1.7, color: AppColors.textDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// VISI & MISI
// ────────────────────────────────────────────────────────────────────
class _VisiMisiSection extends StatelessWidget {
  final ProfilProvider provider;
  const _VisiMisiSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.visiMisiList.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.lightBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(title: 'Visi & Misi'),
          const SizedBox(height: 16),
          if (provider.visi != null) _VisiCard(visi: provider.visi!),
          const SizedBox(height: 12),
          if (provider.misiList.isNotEmpty) _MisiCard(list: provider.misiList),
        ],
      ),
    );
  }
}

class _VisiCard extends StatelessWidget {
  final VisiMisiModel visi;
  const _VisiCard({required this.visi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.visibility_rounded,
                  color: AppColors.navy, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('VISI',
                style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    fontSize: 14)),
          ]),
          const SizedBox(height: 12),
          Text(visi.deskripsi,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 13,
                  height: 1.6)),
        ],
      ),
    );
  }
}

class _MisiCard extends StatelessWidget {
  final List<VisiMisiModel> list;
  const _MisiCard({required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.flag_rounded,
                  color: AppColors.navy, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('MISI',
                style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    fontSize: 14)),
          ]),
          const SizedBox(height: 14),
          ...list.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.value.deskripsi,
                          style: const TextStyle(
                              fontSize: 13,
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

// ────────────────────────────────────────────────────────────────────
// STRUKTUR ORGANISASI
// ────────────────────────────────────────────────────────────────────
class _StrukturSection extends StatelessWidget {
  final List<StrukturOrganisasiModel> list;
  const _StrukturSection({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(title: 'Struktur Organisasi'),
          const SizedBox(height: 16),
          ...list.map((item) {
            final url = item.gambar.startsWith('http')
                ? item.gambar
                : '${ApiConstants.uploadsUrl}/${item.gambar.replaceAll('uploads/', '')}';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: const Color(0xFFEEF2FF),
                    child: const Center(
                        child: Icon(Icons.account_tree_rounded,
                            size: 48, color: AppColors.navy)),
                  ),
                  loadingBuilder: (_, child, prog) {
                    if (prog == null) return child;
                    return Container(
                      height: 180,
                      color: const Color(0xFFEEF2FF),
                      child: const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.navy)),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// FASILITAS
// ────────────────────────────────────────────────────────────────────
class _FasilitasSection extends StatelessWidget {
  final List<FasilitasModel> list;
  const _FasilitasSection({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.lightBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Fasilitas & Sarana Belajar',
            subtitle: 'Dilengkapi fasilitas modern untuk mendukung pembelajaran',
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) => _FasCard(item: list[i]),
          ),
        ],
      ),
    );
  }
}

class _FasCard extends StatelessWidget {
  final FasilitasModel item;
  const _FasCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final url = item.foto != null && item.foto!.isNotEmpty
        ? (item.foto!.startsWith('http')
            ? item.foto!
            : '${ApiConstants.uploadsUrl}/${item.foto!.replaceAll('uploads/', '')}')
        : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null)
              Image.network(url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                  loadingBuilder: (_, child, prog) {
                    if (prog == null) return child;
                    return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.navy));
                  })
            else
              _placeholder(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  item.namaFasilitas,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFEEF2FF),
        child: const Center(
            child: Icon(Icons.business_rounded,
                size: 36, color: AppColors.navy)),
      );
}

// ────────────────────────────────────────────────────────────────────
// AKREDITASI & PRESTASI
// ────────────────────────────────────────────────────────────────────
class _PrestasiSection extends StatelessWidget {
  final List<PrestasiModel> list;
  const _PrestasiSection({required this.list});

  static const _colors = {
    'kabupaten': Color(0xFF10B981),
    'provinsi': Color(0xFF3B82F6),
    'nasional': Color(0xFFF59E0B),
    'internasional': Color(0xFFEF4444),
  };

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Akreditasi & Prestasi'),
          const SizedBox(height: 16),
          ...list.map((item) {
            final c = _colors[item.tingkat.toLowerCase()] ?? AppColors.navy;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.emoji_events_rounded, color: c, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.judul,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textDark)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _Badge(item.tingkat.toUpperCase(), c),
                            const SizedBox(width: 6),
                            _Badge(item.tahun, Colors.grey),
                          ],
                        ),
                        if (item.keterangan?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(item.keterangan!,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textGrey)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4)),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// JURUSAN
// ────────────────────────────────────────────────────────────────────
class _JurusanSection extends StatelessWidget {
  final List<ProgramKeahlianModel> list;
  const _JurusanSection({required this.list});

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
    if (list.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.lightBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Jurusan',
            subtitle: 'Pilih program keahlian di SMK Negeri 3 Balige',
          ),
          const SizedBox(height: 16),
          ...list.asMap().entries.map((e) {
            final idx = e.key % _colors.length;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: _colors[idx].withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(width: 5, color: _colors[idx]),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _colors[idx].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_icons[idx],
                              color: _colors[idx], size: 26),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value.namaJurusan,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: AppColors.navy)),
                              if (e.value.deskripsi?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(e.value.deskripsi!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                        height: 1.4),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// MITRA KERJASAMA
// ────────────────────────────────────────────────────────────────────
class _MitraSection extends StatelessWidget {
  final List<MitraKerjasamaModel> list;
  const _MitraSection({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Mitra Kerjasama',
            subtitle: 'Institusi dan perusahaan yang bermitra dengan kami',
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final m = list[i];
              final url = m.logo != null && m.logo!.isNotEmpty
                  ? (m.logo!.startsWith('http')
                      ? m.logo!
                      : '${ApiConstants.uploadsUrl}/${m.logo!.replaceAll('uploads/', '')}')
                  : null;
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                padding: const EdgeInsets.all(12),
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
                                size: 28)),
                      )
                    else
                      const Icon(Icons.business_rounded,
                          color: AppColors.navy, size: 30),
                    const SizedBox(height: 6),
                    Text(m.namaMitra,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 11,
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
  }
}

// ────────────────────────────────────────────────────────────────────
// KONTAK FOOTER
// ────────────────────────────────────────────────────────────────────
class _KontakSection extends StatelessWidget {
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
          const SizedBox(height: 4),
          Text('Kami siap membantu menjawab pertanyaan Anda.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
          const SizedBox(height: 20),
          _KI(Icons.location_on_rounded,
              'Jl. Patuan Nagari No. 162, Balige, Toba Samosir 22314'),
          _KI(Icons.phone_rounded, '+62 632 21014'),
          _KI(Icons.email_rounded, 'info@smkn3balige.sch.id'),
          _KI(Icons.access_time_rounded, 'Senin–Jumat: 07.00–15.00 WIB'),
          const SizedBox(height: 16),
          Row(children: [
            _Soc(Icons.facebook_rounded, 'Facebook'),
            const SizedBox(width: 10),
            _Soc(Icons.camera_alt_rounded, 'Instagram'),
          ]),
        ],
      ),
    );
  }
}

class _KI extends StatelessWidget {
  final IconData icon;
  final String text;
  const _KI(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: AppColors.gold, size: 16),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      height: 1.5))),
        ]),
      );
}

class _Soc extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Soc(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style:
                  const TextStyle(color: Colors.white, fontSize: 12)),
        ]),
      );
}
