// ── SejarahIdentitas ──────────────────────────────────
class SejarahIdentitasModel {
  final String id;
  final String? tahunBerdiri;
  final String deskripsi;

  SejarahIdentitasModel({required this.id, this.tahunBerdiri, required this.deskripsi});

  factory SejarahIdentitasModel.fromJson(Map<String, dynamic> j) =>
      SejarahIdentitasModel(
        id: j['id']?.toString() ?? '',
        tahunBerdiri: j['tahun_berdiri']?.toString(),
        deskripsi: j['deskripsi'] ?? '',
      );
}

// ── VisiMisi ──────────────────────────────────────────
class VisiMisiModel {
  final String id;
  final String tipe; // 'visi' | 'misi'
  final String deskripsi;

  VisiMisiModel({required this.id, required this.tipe, required this.deskripsi});

  factory VisiMisiModel.fromJson(Map<String, dynamic> j) => VisiMisiModel(
        id: j['id']?.toString() ?? '',
        tipe: j['tipe'] ?? '',
        deskripsi: j['deskripsi'] ?? '',
      );
}

// ── StrukturOrganisasi ────────────────────────────────
class StrukturOrganisasiModel {
  final String id;
  final String gambar;

  StrukturOrganisasiModel({required this.id, required this.gambar});

  factory StrukturOrganisasiModel.fromJson(Map<String, dynamic> j) =>
      StrukturOrganisasiModel(
        id: j['id']?.toString() ?? '',
        gambar: j['gambar'] ?? '',
      );
}

// ── Fasilitas ─────────────────────────────────────────
class FasilitasModel {
  final String id;
  final String namaFasilitas;
  final String? foto;
  final String? deskripsi;

  FasilitasModel({required this.id, required this.namaFasilitas, this.foto, this.deskripsi});

  factory FasilitasModel.fromJson(Map<String, dynamic> j) => FasilitasModel(
        id: j['id']?.toString() ?? '',
        namaFasilitas: j['nama_fasilitas'] ?? '',
        foto: j['foto'],
        deskripsi: j['deskripsi'],
      );
}

// ── Prestasi ──────────────────────────────────────────
class PrestasiModel {
  final String id;
  final String judul;
  final String tingkat;
  final String tahun;
  final String? keterangan;

  PrestasiModel({required this.id, required this.judul, required this.tingkat, required this.tahun, this.keterangan});

  factory PrestasiModel.fromJson(Map<String, dynamic> j) => PrestasiModel(
        id: j['id']?.toString() ?? '',
        judul: j['judul'] ?? '',
        tingkat: j['tingkat'] ?? '',
        tahun: j['tahun']?.toString() ?? '',
        keterangan: j['keterangan'],
      );
}

// ── ProgramKeahlian ───────────────────────────────────
class ProgramKeahlianModel {
  final String id;
  final String namaJurusan;
  final String? deskripsi;
  final String? icon;

  ProgramKeahlianModel({required this.id, required this.namaJurusan, this.deskripsi, this.icon});

  factory ProgramKeahlianModel.fromJson(Map<String, dynamic> j) =>
      ProgramKeahlianModel(
        id: j['id']?.toString() ?? '',
        namaJurusan: j['nama_jurusan'] ?? '',
        deskripsi: j['deskripsi'],
        icon: j['icon'],
      );
}

// ── MitraKerjasama ────────────────────────────────────
class MitraKerjasamaModel {
  final String id;
  final String namaMitra;
  final String? logo;
  final String? deskripsi;

  MitraKerjasamaModel({required this.id, required this.namaMitra, this.logo, this.deskripsi});

  factory MitraKerjasamaModel.fromJson(Map<String, dynamic> j) =>
      MitraKerjasamaModel(
        id: j['id']?.toString() ?? '',
        namaMitra: j['nama_mitra'] ?? '',
        logo: j['logo'],
        deskripsi: j['deskripsi'],
      );
}
