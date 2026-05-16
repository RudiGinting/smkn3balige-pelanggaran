import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profil_models.dart';
import '../../core/constants/api_constants.dart';

class ProfilService {
  static final _client = http.Client();

  // ── GET helper ───────────────────────────────────────────
  static Future<List<T>> _get<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final res = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List list = decoded is List ? decoded : (decoded['data'] ?? []);
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('HTTP ${res.statusCode}: $endpoint');
  }

  // ── JSON helper (POST/PUT tanpa file) ────────────────────
  static Future<Map<String, dynamic>> _sendJson(
      String method,
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = {'Content-Type': 'application/json'};
    final encoded = jsonEncode(body);

    final http.Response res;
    switch (method) {
      case 'POST':
        res = await _client
            .post(uri, headers: headers, body: encoded)
            .timeout(const Duration(seconds: 15));
        break;
      case 'PUT':
        res = await _client
            .put(uri, headers: headers, body: encoded)
            .timeout(const Duration(seconds: 15));
        break;
      default:
        throw Exception('Method tidak didukung: $method');
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    final err = jsonDecode(res.body);
    throw Exception(err['message'] ?? 'HTTP ${res.statusCode}: $endpoint');
  }

  // ── Multipart helper pakai baseUrl ───────────────────────
  // Semua upload file hit ke /api/... sesuai controller NestJS
  static Future<Map<String, dynamic>> _sendMultipartBase(
      String method,
      String endpoint, {
        Map<String, String> fields = const {},
        Map<String, XFile> files = const {},
      }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final req = http.MultipartRequest(method, uri);
    req.fields.addAll(fields);

    for (final entry in files.entries) {
      final xfile = entry.value;
      final bytes = await xfile.readAsBytes();
      final mimeType =
          lookupMimeType(xfile.name) ?? 'application/octet-stream';
      final mediaParts = mimeType.split('/');
      req.files.add(http.MultipartFile.fromBytes(
        entry.key,
        bytes,
        filename: xfile.name,
        contentType: MediaType(mediaParts[0], mediaParts[1]),
      ));
    }

    final streamed = await req.send().timeout(const Duration(seconds: 30));
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
      return jsonDecode(body);
    }
    final err = jsonDecode(body);
    throw Exception(err['message'] ?? 'HTTP ${streamed.statusCode}: $endpoint');
  }

  // ── DELETE helper ────────────────────────────────────────
  static Future<void> _delete(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final res =
    await _client.delete(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final err = jsonDecode(res.body);
      throw Exception(err['message'] ?? 'HTTP ${res.statusCode}: $endpoint');
    }
  }

  // ════════════════════════════════════════════════════════
  // SEJARAH & IDENTITAS
  // ════════════════════════════════════════════════════════
  Future<List<SejarahIdentitasModel>> getSejarahIdentitas() =>
      _get(ApiConstants.sejarahIdentitas, SejarahIdentitasModel.fromJson);

  Future<void> createSejarahIdentitas(String tahunBerdiri, String deskripsi) =>
      _sendJson('POST', ApiConstants.sejarahIdentitas, {
        'tahun_berdiri': tahunBerdiri,
        'deskripsi': deskripsi,
      });

  Future<void> updateSejarahIdentitas(
      String id, String tahunBerdiri, String deskripsi) =>
      _sendJson('PUT', '${ApiConstants.sejarahIdentitas}/$id', {
        'tahun_berdiri': tahunBerdiri,
        'deskripsi': deskripsi,
      });

  Future<void> deleteSejarahIdentitas(String id) =>
      _delete('${ApiConstants.sejarahIdentitas}/$id');

  // ════════════════════════════════════════════════════════
  // VISI & MISI
  // ════════════════════════════════════════════════════════
  Future<List<VisiMisiModel>> getVisiMisi() =>
      _get(ApiConstants.visiMisi, VisiMisiModel.fromJson);

  Future<void> createVisiMisi(String tipe, String deskripsi) =>
      _sendJson('POST', ApiConstants.visiMisi, {
        'tipe': tipe,
        'deskripsi': deskripsi,
      });

  Future<void> updateVisiMisi(String id, String tipe, String deskripsi) =>
      _sendJson('PUT', '${ApiConstants.visiMisi}/$id', {
        'tipe': tipe,
        'deskripsi': deskripsi,
      });

  Future<void> deleteVisiMisi(String id) =>
      _delete('${ApiConstants.visiMisi}/$id');

  // ════════════════════════════════════════════════════════
  // STRUKTUR ORGANISASI  ← pakai _sendMultipartBase
  // ════════════════════════════════════════════════════════
  Future<List<StrukturOrganisasiModel>> getStrukturOrganisasi() =>
      _get(ApiConstants.strukturOrganisasi, StrukturOrganisasiModel.fromJson);

  Future<void> createStrukturOrganisasi(XFile gambar) =>
      _sendMultipartBase('POST', ApiConstants.strukturOrganisasi,
          files: {'gambar': gambar});

  Future<void> updateStrukturOrganisasi(String id, XFile gambar) =>
      _sendMultipartBase('PUT', '${ApiConstants.strukturOrganisasi}/$id',
          files: {'gambar': gambar});

  Future<void> deleteStrukturOrganisasi(String id) =>
      _delete('${ApiConstants.strukturOrganisasi}/$id');

  // ════════════════════════════════════════════════════════
  // FASILITAS  ← pakai _sendMultipartBase
  // ════════════════════════════════════════════════════════
  Future<List<FasilitasModel>> getFasilitas() =>
      _get(ApiConstants.fasilitas, FasilitasModel.fromJson);

  Future<void> createFasilitas(String nama, String? deskripsi,
      {XFile? foto}) =>
      _sendMultipartBase('POST', ApiConstants.fasilitas,
          fields: {
            'nama_fasilitas': nama,
            if (deskripsi != null) 'deskripsi': deskripsi,
          },
          files: {
            if (foto != null) 'foto': foto,
          });

  Future<void> updateFasilitas(String id, String nama, String? deskripsi,
      {XFile? foto}) =>
      _sendMultipartBase('PUT', '${ApiConstants.fasilitas}/$id',
          fields: {
            'nama_fasilitas': nama,
            if (deskripsi != null) 'deskripsi': deskripsi,
          },
          files: {
            if (foto != null) 'foto': foto,
          });

  Future<void> deleteFasilitas(String id) =>
      _delete('${ApiConstants.fasilitas}/$id');

  // ════════════════════════════════════════════════════════
  // PRESTASI
  // ════════════════════════════════════════════════════════
  Future<List<PrestasiModel>> getPrestasi() =>
      _get(ApiConstants.prestasi, PrestasiModel.fromJson);

  Future<void> createPrestasi(
      String judul, String tingkat, String tahun, String? keterangan) =>
      _sendJson('POST', ApiConstants.prestasi, {
        'judul': judul,
        'tingkat': tingkat,
        'tahun': tahun,
        if (keterangan != null && keterangan.isNotEmpty)
          'keterangan': keterangan,
      });

  Future<void> updatePrestasi(String id, String judul, String tingkat,
      String tahun, String? keterangan) =>
      _sendJson('PUT', '${ApiConstants.prestasi}/$id', {
        'judul': judul,
        'tingkat': tingkat,
        'tahun': tahun,
        if (keterangan != null && keterangan.isNotEmpty)
          'keterangan': keterangan,
      });

  Future<void> deletePrestasi(String id) =>
      _delete('${ApiConstants.prestasi}/$id');

  // ════════════════════════════════════════════════════════
  // PROGRAM KEAHLIAN
  // ════════════════════════════════════════════════════════
  Future<List<ProgramKeahlianModel>> getProgramKeahlian() =>
      _get(ApiConstants.programKeahlian, ProgramKeahlianModel.fromJson);

  Future<void> createProgramKeahlian(
      String nama, String? deskripsi, String? icon) =>
      _sendJson('POST', ApiConstants.programKeahlian, {
        'nama_jurusan': nama,
        if (deskripsi != null) 'deskripsi': deskripsi,
        if (icon != null) 'icon': icon,
      });

  Future<void> updateProgramKeahlian(
      String id, String nama, String? deskripsi, String? icon) =>
      _sendJson('PUT', '${ApiConstants.programKeahlian}/$id', {
        'nama_jurusan': nama,
        if (deskripsi != null) 'deskripsi': deskripsi,
        if (icon != null) 'icon': icon,
      });

  Future<void> deleteProgramKeahlian(String id) =>
      _delete('${ApiConstants.programKeahlian}/$id');

  // ════════════════════════════════════════════════════════
  // MITRA KERJASAMA  ← pakai _sendMultipartBase
  // ════════════════════════════════════════════════════════
  Future<List<MitraKerjasamaModel>> getMitraKerjasama() =>
      _get(ApiConstants.mitraKerjasama, MitraKerjasamaModel.fromJson);

  Future<void> createMitraKerjasama(String nama, String? deskripsi,
      {XFile? logo}) =>
      _sendMultipartBase('POST', ApiConstants.mitraKerjasama,
          fields: {
            'nama_mitra': nama,
            if (deskripsi != null) 'deskripsi': deskripsi,
          },
          files: {
            if (logo != null) 'logo': logo,
          });

  Future<void> updateMitraKerjasama(String id, String nama, String? deskripsi,
      {XFile? logo}) =>
      _sendMultipartBase('PUT', '${ApiConstants.mitraKerjasama}/$id',
          fields: {
            'nama_mitra': nama,
            if (deskripsi != null) 'deskripsi': deskripsi,
          },
          files: {
            if (logo != null) 'logo': logo,
          });

  Future<void> deleteMitraKerjasama(String id) =>
      _delete('${ApiConstants.mitraKerjasama}/$id');
}