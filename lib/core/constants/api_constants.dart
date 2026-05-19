class ApiConstants {
  // ============================================================
  // Gunakan 'localhost' jika di Web, atau sesuaikan dengan IP Docker/Nginx Anda.
  // Port disesuaikan dengan API Gateway / Nginx Anda yaitu 6766.
  static const String _host = 'localhost';
  static const String _port = '6766';

  static String get baseUrl => 'http://$_host:$_port/api';
  static String get uploadsUrl => 'http://$_host:$_port/uploads';

  // Sesuai dengan const PREFIX = '/profile' di Axios Web Anda
  static const String _profilePrefix = '/profile';

  // Endpoints profil sekolah (Otomatis menggabungkan prefix /profile)
  static const String sejarahIdentitas = '$_profilePrefix/sejarah-identitas';
  static const String visiMisi = '$_profilePrefix/visi-misi';
  static const String strukturOrganisasi = '$_profilePrefix/struktur-organisasi';
  static const String fasilitas = '$_profilePrefix/fasilitas';
  static const String prestasi = '$_profilePrefix/prestasi';
  static const String programKeahlian = '$_profilePrefix/program-keahlian';
  static const String mitraKerjasama = '$_profilePrefix/mitra-kerjasama';

  // Endpoint surat panggilan (Sesuaikan jika memiliki prefix rute berbeda)
  static const String suratPanggilan = '/surat-panggilan';
}