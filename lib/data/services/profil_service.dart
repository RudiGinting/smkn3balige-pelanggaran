import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profil_models.dart';
import '../../core/constants/api_constants.dart';

class ProfilService {
  static final _client = http.Client();

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

  Future<List<SejarahIdentitasModel>> getSejarahIdentitas() =>
      _get(ApiConstants.sejarahIdentitas, SejarahIdentitasModel.fromJson);

  Future<List<VisiMisiModel>> getVisiMisi() =>
      _get(ApiConstants.visiMisi, VisiMisiModel.fromJson);

  Future<List<StrukturOrganisasiModel>> getStrukturOrganisasi() =>
      _get(ApiConstants.strukturOrganisasi, StrukturOrganisasiModel.fromJson);

  Future<List<FasilitasModel>> getFasilitas() =>
      _get(ApiConstants.fasilitas, FasilitasModel.fromJson);

  Future<List<PrestasiModel>> getPrestasi() =>
      _get(ApiConstants.prestasi, PrestasiModel.fromJson);

  Future<List<ProgramKeahlianModel>> getProgramKeahlian() =>
      _get(ApiConstants.programKeahlian, ProgramKeahlianModel.fromJson);

  Future<List<MitraKerjasamaModel>> getMitraKerjasama() =>
      _get(ApiConstants.mitraKerjasama, MitraKerjasamaModel.fromJson);
}
