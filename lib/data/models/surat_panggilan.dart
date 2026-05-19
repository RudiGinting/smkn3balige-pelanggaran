class SuratPanggilan {
  final int id;
  final String noSurat;
  final String idSiswa;
  final String? namaSiswa; // Menampung hasil join nama_siswa
  final String? permasalahan;
  final String tanggalPanggilan;
  final String? waktuPanggilan;
  final String? tempat;
  final List<dynamic>? idPenandatangan;

  SuratPanggilan({
    required this.id,
    required this.noSurat,
    required this.idSiswa,
    this.namaSiswa,
    this.permasalahan,
    required this.tanggalPanggilan,
    this.waktuPanggilan,
    this.tempat,
    this.idPenandatangan,
  });

  factory SuratPanggilan.fromJson(Map<String, dynamic> json) {
    return SuratPanggilan(
      id: json['id'],
      noSurat: json['no_surat'] ?? '',
      idSiswa: json['id_siswa']?.toString() ?? '',
      namaSiswa: json['nama_siswa'], // Diambil jika backend melakukan join tabel
      permasalahan: json['permasalahan'],
      tanggalPanggilan: json['tanggal_panggilan'] ?? '',
      waktuPanggilan: json['waktu_panggilan'],
      tempat: json['tempat'],
      idPenandatangan: json['id_penandatangan'] is List ? json['id_penandatangan'] : [],
    );
  }
}