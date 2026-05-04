class SuratPanggilan {
  final int id;
  final String noSurat;
  final String idSiswa;
  final String namaSiswa;
  final String tanggal;
  final String permasalahan;

  SuratPanggilan({
    required this.id,
    required this.noSurat,
    required this.idSiswa,
    required this.namaSiswa,
    required this.tanggal,
    required this.permasalahan,
  });

  factory SuratPanggilan.fromJson(Map<String, dynamic> json) {
    return SuratPanggilan(
      id: json['id'] ?? 0,
      noSurat: json['no_surat'] ?? '',
      idSiswa: json['id_siswa']?.toString() ?? '',
      namaSiswa: json['nama_siswa'] ?? json['siswa_nama'] ?? 'Siswa',
      tanggal: json['tanggal_panggilan'] ?? '',
      permasalahan: json['permasalahan'] ?? '',
    );
  }
}