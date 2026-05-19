import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// Import ApiConstants agar IP & Port selalu sinkron dengan fitur lainnya
import '../../core/constants/api_constants.dart';

class PelanggaranScreen extends StatefulWidget {
  const PelanggaranScreen({super.key});

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  // Menggunakan baseUrl pusat dari ApiConstants agar terhubung ke BE yang benar
  final String baseUrl = "${ApiConstants.baseUrl}${ApiConstants.suratPanggilan}";

  List<dynamic> data = [];
  bool loading = false;

  final noSuratController = TextEditingController();
  final tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ================= GET DATA =================
  Future<void> fetchData() async {
    setState(() => loading = true);

    try {
      final res = await http.get(Uri.parse(baseUrl));
      final jsonData = json.decode(res.body);

      if (jsonData['status'] == 'success') {
        setState(() => data = jsonData['data']);
      }
    } catch (e) {
      debugPrint("Error Fetch Data: $e");
    }

    setState(() => loading = false);
  }

  // ================= DELETE =================
  Future<void> deleteData(int id) async {
    try {
      await http.delete(Uri.parse("$baseUrl/$id"));
      fetchData();
    } catch (e) {
      debugPrint("Error Delete: $e");
    }
  }

  // ================= CREATE =================
  Future<void> createData() async {
    final payload = {
      "no_surat": noSuratController.text,
      "tanggal_panggilan": tanggalController.text,
    };

    try {
      await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      Navigator.pop(context);
      fetchData();
    } catch (e) {
      debugPrint("Error Create: $e");
    }
  }

  // ================= PDF =================
  void openPdf(int id) async {
    final url = "$baseUrl/$id/pdf";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  // ================= WA (FIXED ERROR SUBTYPE) =================
  Future<void> sendWA(int id) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/$id/whatsapp"));

      if (res.statusCode == 200) {
        // PERBAIKAN: Karena BE mengembalikan String teks link langsung,
        // kita tidak perlu menggunakan json.decode(). Cukup bersihkan tanda petik jika ada.
        final link = res.body.replaceAll('"', '').trim();

        if (link.isNotEmpty) {
          await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
        } else {
          debugPrint("Link WhatsApp kosong");
        }
      } else {
        debugPrint("Gagal mengambil link WA, Status Code: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error WA: $e");
    }
  }

  // ================= MODAL =================
  void openAddDialog() {
    noSuratController.clear();
    tanggalController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Surat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noSuratController,
              decoration: const InputDecoration(labelText: "No Surat"),
            ),
            TextField(
              controller: tanggalController,
              decoration:
              const InputDecoration(labelText: "Tanggal (YYYY-MM-DD)"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: createData,
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pelanggaran & Surat"),
        backgroundColor: const Color(0xFF1A237E),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        onPressed: openAddDialog,
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: fetchData,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : data.isEmpty
            ? const Center(child: Text("Tidak ada data"))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['no_surat'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    Text(item['nama_siswa'] ?? ''),
                    Text(item['tanggal_panggilan'] ?? ''),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              openPdf(item['id']),
                          child: const Text("📄 PDF"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () =>
                              sendWA(item['id']),
                          child: const Text("💬 WA"),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () =>
                              deleteData(item['id']),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}