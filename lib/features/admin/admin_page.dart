import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // XFile + ImagePicker
import '../../core/constants/app_colors.dart';
import '../../data/services/profil_service.dart';
import '../../data/models/profil_models.dart';

// hapus: import 'dart:io';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedMenu = 0;
  final _service = ProfilService();

  static const _menus = [
    {'icon': Icons.history_edu_rounded,  'label': 'Sejarah & Identitas'},
    {'icon': Icons.visibility_rounded,   'label': 'Visi & Misi'},
    {'icon': Icons.account_tree_rounded, 'label': 'Struktur Organisasi'},
    {'icon': Icons.apartment_rounded,    'label': 'Fasilitas'},
    {'icon': Icons.emoji_events_rounded, 'label': 'Prestasi'},
    {'icon': Icons.school_rounded,       'label': 'Program Keahlian'},
    {'icon': Icons.handshake_rounded,    'label': 'Mitra Kerjasama'},
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _SejarahPage(service: _service),
      _VisiMisiPage(service: _service),
      _StrukturPage(service: _service),
      _FasilitasPage(service: _service),
      _PrestasiPage(service: _service),
      _ProgramKeahlianPage(service: _service),
      _MitraPage(service: _service),
    ];

    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0,
        leading: isTablet
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
        title: Text(
          _menus[_selectedMenu]['label'] as String,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
            ),
            child: const Row(children: [
              Icon(Icons.shield_rounded, color: AppColors.gold, size: 14),
              SizedBox(width: 4),
              Text('Admin',
                  style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ],
      ),
      drawer: isTablet ? null : _buildDrawer(),
      body: isTablet
          ? Row(children: [
        Container(
          width: 210,
          color: AppColors.navy,
          child: _buildMenuList(isTablet: true),
        ),
        Expanded(child: pages[_selectedMenu]),
      ])
          : pages[_selectedMenu],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(children: [
                const Icon(Icons.admin_panel_settings_rounded,
                    color: AppColors.gold, size: 22),
                const SizedBox(width: 8),
                const Text('Panel Admin',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ]),
            ),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 8),
            Expanded(child: _buildMenuList(isTablet: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList({required bool isTablet}) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _menus.length,
      itemBuilder: (_, i) {
        final active = _selectedMenu == i;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedMenu = i);
            if (!isTablet) Navigator.of(context).pop();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.gold.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: active
                  ? Border.all(color: AppColors.gold.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(children: [
              Icon(_menus[i]['icon'] as IconData,
                  color: active
                      ? AppColors.gold
                      : Colors.white.withValues(alpha: 0.6),
                  size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_menus[i]['label'] as String,
                    style: TextStyle(
                        color: active
                            ? AppColors.gold
                            : Colors.white.withValues(alpha: 0.7),
                        fontWeight:
                        active ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 13)),
              ),
            ]),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
// SHARED HELPERS
// ════════════════════════════════════════════════════════════

Widget _fabAdd(VoidCallback onTap) => Padding(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
  child: Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Tambah',
          style: TextStyle(fontWeight: FontWeight.w700)),
    ),
  ),
);

Widget _itemCard({
  required String title,
  String? subtitle,
  String? imageUrl,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2))
      ],
    ),
    child: Row(children: [
      if (imageUrl != null && imageUrl.isNotEmpty) ...[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey))),
        ),
        const SizedBox(width: 12),
      ],
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ]),
      ),
      IconButton(
          icon: const Icon(Icons.edit_rounded, color: AppColors.navy, size: 20),
          onPressed: onEdit),
      IconButton(
          icon: Icon(Icons.delete_rounded, color: Colors.red.shade400, size: 20),
          onPressed: onDelete),
    ]),
  );
}

Future<bool> _confirmDelete(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: const Text('Hapus Data?',
          style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text('Data yang dihapus tidak dapat dikembalikan.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  ) ??
      false;
}

Widget _field(TextEditingController c, String label,
    {int maxLines = 1, TextInputType? type}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );

void _showSnack(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: error ? Colors.red.shade600 : Colors.green.shade600,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ));
}

// ════════════════════════════════════════════════════════════
// PAGE: SEJARAH & IDENTITAS
// ════════════════════════════════════════════════════════════
class _SejarahPage extends StatefulWidget {
  final ProfilService service;
  const _SejarahPage({required this.service});
  @override
  State<_SejarahPage> createState() => _SejarahPageState();
}

class _SejarahPageState extends State<_SejarahPage> {
  List<SejarahIdentitasModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getSejarahIdentitas(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({SejarahIdentitasModel? item}) {
    final tahunC = TextEditingController(text: item?.tahunBerdiri ?? '');
    final deskC  = TextEditingController(text: item?.deskripsi ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(item == null ? 'Tambah Sejarah' : 'Edit Sejarah',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _field(tahunC, 'Tahun Berdiri', type: TextInputType.number),
          _field(deskC, 'Deskripsi', maxLines: 4),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
            onPressed: () async {
              try {
                item == null
                    ? await widget.service.createSejarahIdentitas(tahunC.text, deskC.text)
                    : await widget.service.updateSejarahIdentitas(item.id, tahunC.text, deskC.text);
                if (mounted) Navigator.pop(context);
                _load();
                if (mounted) _showSnack(context, 'Berhasil disimpan');
              } catch (e) {
                if (mounted) _showSnack(context, e.toString(), error: true);
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: 'Tahun Berdiri: ${item.tahunBerdiri ?? '-'}',
            subtitle: item.deskripsi,
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deleteSejarahIdentitas(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
// PAGE: VISI & MISI
// ════════════════════════════════════════════════════════════
class _VisiMisiPage extends StatefulWidget {
  final ProfilService service;
  const _VisiMisiPage({required this.service});
  @override
  State<_VisiMisiPage> createState() => _VisiMisiPageState();
}

class _VisiMisiPageState extends State<_VisiMisiPage> {
  List<VisiMisiModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getVisiMisi(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({VisiMisiModel? item}) {
    final tipeC = ValueNotifier<String>(item?.tipe ?? 'visi');
    final deskC = TextEditingController(text: item?.deskripsi ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(item == null ? 'Tambah Visi/Misi' : 'Edit Visi/Misi',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
          ValueListenableBuilder<String>(
            valueListenable: tipeC,
            builder: (_, val, __) => DropdownButtonFormField<String>(
              value: val,
              decoration: InputDecoration(labelText: 'Tipe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              items: const [
                DropdownMenuItem(value: 'visi', child: Text('Visi')),
                DropdownMenuItem(value: 'misi', child: Text('Misi')),
              ],
              onChanged: (v) => tipeC.value = v!,
            ),
          ),
          const SizedBox(height: 14),
          _field(deskC, 'Deskripsi', maxLines: 4),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
            onPressed: () async {
              try {
                item == null
                    ? await widget.service.createVisiMisi(tipeC.value, deskC.text)
                    : await widget.service.updateVisiMisi(item.id, tipeC.value, deskC.text);
                if (mounted) Navigator.pop(context);
                _load();
                if (mounted) _showSnack(context, 'Berhasil disimpan');
              } catch (e) {
                if (mounted) _showSnack(context, e.toString(), error: true);
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: item.tipe[0].toUpperCase() + item.tipe.substring(1),
            subtitle: item.deskripsi,
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deleteVisiMisi(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
// PAGE: STRUKTUR ORGANISASI
// ════════════════════════════════════════════════════════════
class _StrukturPage extends StatefulWidget {
  final ProfilService service;
  const _StrukturPage({required this.service});
  @override
  State<_StrukturPage> createState() => _StrukturPageState();
}

class _StrukturPageState extends State<_StrukturPage> {
  List<StrukturOrganisasiModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getStrukturOrganisasi(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({StrukturOrganisasiModel? item}) {
    XFile? pickedFile; // ← XFile
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(item == null ? 'Upload Struktur' : 'Ganti Gambar',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (item != null && item.gambar.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.gambar, height: 120, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) setS(() => pickedFile = picked); // ← langsung assign XFile
              },
              icon: const Icon(Icons.upload_file_rounded),
              label: Text(pickedFile != null ? 'Gambar dipilih ✓' : 'Pilih Gambar'),
            ),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
              onPressed: () async {
                if (pickedFile == null) {
                  _showSnack(context, 'Pilih gambar dulu', error: true);
                  return;
                }
                try {
                  item == null
                      ? await widget.service.createStrukturOrganisasi(pickedFile!)
                      : await widget.service.updateStrukturOrganisasi(item.id, pickedFile!);
                  if (mounted) Navigator.pop(ctx);
                  _load();
                  if (mounted) _showSnack(context, 'Berhasil disimpan');
                } catch (e) {
                  if (mounted) _showSnack(context, e.toString(), error: true);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: 'Struktur Organisasi #${i + 1}',
            imageUrl: item.gambar,
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deleteStrukturOrganisasi(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
// PAGE: FASILITAS
// ════════════════════════════════════════════════════════════
class _FasilitasPage extends StatefulWidget {
  final ProfilService service;
  const _FasilitasPage({required this.service});
  @override
  State<_FasilitasPage> createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<_FasilitasPage> {
  List<FasilitasModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getFasilitas(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({FasilitasModel? item}) {
    final namaC = TextEditingController(text: item?.namaFasilitas ?? '');
    final deskC = TextEditingController(text: item?.deskripsi ?? '');
    XFile? pickedFile; // ← XFile
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(item == null ? 'Tambah Fasilitas' : 'Edit Fasilitas',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(namaC, 'Nama Fasilitas'),
            _field(deskC, 'Deskripsi', maxLines: 3),
            if (item?.foto != null && item!.foto!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(item.foto!, height: 80, fit: BoxFit.cover),
                ),
              ),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) setS(() => pickedFile = picked); // ← langsung assign
              },
              icon: const Icon(Icons.photo_rounded),
              label: Text(pickedFile != null ? 'Foto dipilih ✓' : 'Pilih Foto (opsional)'),
            ),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
              onPressed: () async {
                try {
                  item == null
                      ? await widget.service.createFasilitas(namaC.text, deskC.text, foto: pickedFile)
                      : await widget.service.updateFasilitas(item.id, namaC.text, deskC.text, foto: pickedFile);
                  if (mounted) Navigator.pop(ctx);
                  _load();
                  if (mounted) _showSnack(context, 'Berhasil disimpan');
                } catch (e) {
                  if (mounted) _showSnack(context, e.toString(), error: true);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: item.namaFasilitas,
            subtitle: item.deskripsi,
            imageUrl: item.foto,
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deleteFasilitas(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
// PAGE: PRESTASI
// ════════════════════════════════════════════════════════════
class _PrestasiPage extends StatefulWidget {
  final ProfilService service;
  const _PrestasiPage({required this.service});
  @override
  State<_PrestasiPage> createState() => _PrestasiPageState();
}

class _PrestasiPageState extends State<_PrestasiPage> {
  List<PrestasiModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getPrestasi(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({PrestasiModel? item}) {
    final judulC  = TextEditingController(text: item?.judul ?? '');
    final tahunC  = TextEditingController(text: item?.tahun ?? '');
    final ketC    = TextEditingController(text: item?.keterangan ?? '');
    final tingkatC = ValueNotifier<String>(item?.tingkat ?? 'kabupaten');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(item == null ? 'Tambah Prestasi' : 'Edit Prestasi',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _field(judulC, 'Judul Prestasi'),
          ValueListenableBuilder<String>(
            valueListenable: tingkatC,
            builder: (_, val, __) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<String>(
                value: val,
                decoration: InputDecoration(labelText: 'Tingkat',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                items: ['kabupaten', 'provinsi', 'nasional', 'internasional']
                    .map((t) => DropdownMenuItem(value: t,
                    child: Text(t[0].toUpperCase() + t.substring(1))))
                    .toList(),
                onChanged: (v) => tingkatC.value = v!,
              ),
            ),
          ),
          _field(tahunC, 'Tahun', type: TextInputType.number),
          _field(ketC, 'Keterangan (opsional)', maxLines: 3),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
            onPressed: () async {
              try {
                item == null
                    ? await widget.service.createPrestasi(judulC.text, tingkatC.value, tahunC.text, ketC.text)
                    : await widget.service.updatePrestasi(item.id, judulC.text, tingkatC.value, tahunC.text, ketC.text);
                if (mounted) Navigator.pop(context);
                _load();
                if (mounted) _showSnack(context, 'Berhasil disimpan');
              } catch (e) {
                if (mounted) _showSnack(context, e.toString(), error: true);
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: item.judul,
            subtitle: '${item.tingkat[0].toUpperCase()}${item.tingkat.substring(1)} • ${item.tahun}',
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deletePrestasi(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
// PAGE: PROGRAM KEAHLIAN
// ════════════════════════════════════════════════════════════
class _ProgramKeahlianPage extends StatefulWidget {
  final ProfilService service;
  const _ProgramKeahlianPage({required this.service});
  @override
  State<_ProgramKeahlianPage> createState() => _ProgramKeahlianPageState();
}

class _ProgramKeahlianPageState extends State<_ProgramKeahlianPage> {
  List<ProgramKeahlianModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getProgramKeahlian(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({ProgramKeahlianModel? item}) {
    final namaC = TextEditingController(text: item?.namaJurusan ?? '');
    final deskC = TextEditingController(text: item?.deskripsi ?? '');
    final iconC = TextEditingController(text: item?.icon ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(item == null ? 'Tambah Program Keahlian' : 'Edit Program Keahlian',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _field(namaC, 'Nama Jurusan'),
          _field(deskC, 'Deskripsi', maxLines: 3),
          _field(iconC, 'Icon (emoji atau URL)'),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
            onPressed: () async {
              try {
                item == null
                    ? await widget.service.createProgramKeahlian(namaC.text, deskC.text, iconC.text)
                    : await widget.service.updateProgramKeahlian(item.id, namaC.text, deskC.text, iconC.text);
                if (mounted) Navigator.pop(context);
                _load();
                if (mounted) _showSnack(context, 'Berhasil disimpan');
              } catch (e) {
                if (mounted) _showSnack(context, e.toString(), error: true);
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: item.namaJurusan,
            subtitle: item.deskripsi,
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deleteProgramKeahlian(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
// PAGE: MITRA KERJASAMA
// ════════════════════════════════════════════════════════════
class _MitraPage extends StatefulWidget {
  final ProfilService service;
  const _MitraPage({required this.service});
  @override
  State<_MitraPage> createState() => _MitraPageState();
}

class _MitraPageState extends State<_MitraPage> {
  List<MitraKerjasamaModel> _data = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _data = await widget.service.getMitraKerjasama(); }
    catch (e) { if (mounted) _showSnack(context, e.toString(), error: true); }
    if (mounted) setState(() => _loading = false);
  }

  void _showForm({MitraKerjasamaModel? item}) {
    final namaC = TextEditingController(text: item?.namaMitra ?? '');
    final deskC = TextEditingController(text: item?.deskripsi ?? '');
    XFile? pickedFile; // ← XFile
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(item == null ? 'Tambah Mitra' : 'Edit Mitra',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(namaC, 'Nama Mitra'),
            _field(deskC, 'Deskripsi', maxLines: 3),
            if (item?.logo != null && item!.logo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(item.logo!, height: 60, fit: BoxFit.contain),
                ),
              ),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) setS(() => pickedFile = picked); // ← langsung assign
              },
              icon: const Icon(Icons.upload_rounded),
              label: Text(pickedFile != null ? 'Logo dipilih ✓' : 'Upload Logo (opsional)'),
            ),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
              onPressed: () async {
                try {
                  item == null
                      ? await widget.service.createMitraKerjasama(namaC.text, deskC.text, logo: pickedFile)
                      : await widget.service.updateMitraKerjasama(item.id, namaC.text, deskC.text, logo: pickedFile);
                  if (mounted) Navigator.pop(ctx);
                  _load();
                  if (mounted) _showSnack(context, 'Berhasil disimpan');
                } catch (e) {
                  if (mounted) _showSnack(context, e.toString(), error: true);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fabAdd(() => _showForm()),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i];
          return _itemCard(
            title: item.namaMitra,
            subtitle: item.deskripsi,
            imageUrl: item.logo,
            onEdit: () => _showForm(item: item),
            onDelete: () async {
              if (await _confirmDelete(context)) {
                await widget.service.deleteMitraKerjasama(item.id);
                _load();
              }
            },
          );
        },
      )),
    ]);
  }
}