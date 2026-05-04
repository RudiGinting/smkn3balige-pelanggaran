import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/surat_panggilan.dart';

class SuratPanggilanService {
  final http.Client _client = http.Client();

  String get _baseUrl =>
      '${ApiConstants.baseUrl}${ApiConstants.suratPanggilan}';

  // ================= GET =================
  Future<List<SuratPanggilan>> getAll() async {
    final response = await _client.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        final List list = jsonData['data'];
        return list.map((e) => SuratPanggilan.fromJson(e)).toList();
      }
    }

    throw Exception('Gagal load data');
  }

  // ================= CREATE =================
  Future<void> create(Map<String, dynamic> data) async {
    final res = await _client.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Gagal tambah data");
    }
  }

  // ================= UPDATE =================
  Future<void> update(int id, Map<String, dynamic> data) async {
    final res = await _client.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal update");
    }
  }

  // ================= DELETE =================
  Future<void> delete(int id) async {
    final res = await _client.delete(Uri.parse('$_baseUrl/$id'));

    if (res.statusCode != 200) {
      throw Exception("Gagal hapus");
    }
  }

  // ================= PDF =================
  String getPdfUrl(int id) => '$_baseUrl/$id/pdf';

  // ================= WHATSAPP =================
  Future<String> getWhatsappLink(int id) async {
    final res = await _client.get(Uri.parse('$_baseUrl/$id/whatsapp'));

    final jsonData = jsonDecode(res.body);

    if (jsonData['status'] == 'success') {
      return jsonData['data']['link_whatsapp'];
    }

    throw Exception("Gagal ambil WA");
  }
}