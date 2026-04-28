class ApiConstants {
  // ============================================================
  static const String _host = '10.214.176.188';
  static const String _port = '3000';

  static String get baseUrl => 'http://$_host:$_port/api';
  static String get uploadsUrl => 'http://$_host:$_port/uploads';

  // Endpoints profil sekolah
  static const String sejarahIdentitas = '/sejarah-identitas';
  static const String visiMisi = '/visi-misi';
  static const String strukturOrganisasi = '/struktur-organisasi';
  static const String fasilitas = '/fasilitas';
  static const String prestasi = '/prestasi';
  static const String programKeahlian = '/program-keahlian';
  static const String mitraKerjasama = '/mitra-kerjasama';
}
