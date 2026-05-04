import 'package:flutter/material.dart';
import '../data/models/profil_models.dart';
import '../data/services/profil_service.dart';

enum LoadState { idle, loading, loaded, error }

class ProfilProvider extends ChangeNotifier {
  final _svc = ProfilService();

  LoadState state = LoadState.idle;
  String errorMsg = '';

  List<SejarahIdentitasModel> sejarahList = [];
  List<VisiMisiModel> visiMisiList = [];
  List<StrukturOrganisasiModel> strukturList = [];
  List<FasilitasModel> fasilitasList = [];
  List<PrestasiModel> prestasiList = [];
  List<ProgramKeahlianModel> programList = [];
  List<MitraKerjasamaModel> mitraList = [];

  VisiMisiModel? get visi {
    try { return visiMisiList.firstWhere((e) => e.tipe.toLowerCase() == 'visi'); }
    catch (_) { return null; }
  }

  List<VisiMisiModel> get misiList =>
      visiMisiList.where((e) => e.tipe.toLowerCase() == 'misi').toList();

  Future<void> loadAll() async {
    if (state == LoadState.loading) return;
    state = LoadState.loading;
    notifyListeners();
    try {
      final res = await Future.wait([
        _svc.getSejarahIdentitas(),
        _svc.getVisiMisi(),
        _svc.getStrukturOrganisasi(),
        _svc.getFasilitas(),
        _svc.getPrestasi(),
        _svc.getProgramKeahlian(),
        _svc.getMitraKerjasama(),
      ]);
      sejarahList   = res[0] as List<SejarahIdentitasModel>;
      visiMisiList  = res[1] as List<VisiMisiModel>;
      strukturList  = res[2] as List<StrukturOrganisasiModel>;
      fasilitasList = res[3] as List<FasilitasModel>;
      prestasiList  = res[4] as List<PrestasiModel>;
      programList   = res[5] as List<ProgramKeahlianModel>;
      mitraList     = res[6] as List<MitraKerjasamaModel>;
      state = LoadState.loaded;
    } catch (e) {
      errorMsg = e.toString();
      state = LoadState.error;
    }
    notifyListeners();
  }
}
