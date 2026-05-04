import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PelanggaranScreen extends StatefulWidget {
  const PelanggaranScreen({super.key});

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  static const String baseUrl =
      "http://10.0.2.2:3001/api/surat-panggilan";

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
      debugPrint("Error: $e");
    }

    setState(() => loading = false);
  }

  // ================= DELETE =================
  Future<void> deleteData(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
    fetchData();
  }

  // ================= CREATE =================
  Future<void> createData() async {
    final payload = {
      "no_surat": noSuratController.text,
      "tanggal_panggilan": tanggalController.text,
    };

    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );

    Navigator.pop(context);
    fetchData();
  }

  // ================= PDF =================
  void openPdf(int id) async {
    final url = "$baseUrl/$id/pdf";
    await launchUrl(Uri.parse(url));
  }

  // ================= WA =================
  Future<void> sendWA(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id/whatsapp"));
    final jsonData = json.decode(res.body);

    if (jsonData['status'] == 'success') {
      final link = jsonData['data']['link_whatsapp'];
      await launchUrl(Uri.parse(link));
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