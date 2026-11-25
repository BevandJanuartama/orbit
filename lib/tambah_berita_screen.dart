import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'biodata_list_screen.dart';

class TambahEditBeritaScreen extends StatefulWidget {
  final DocumentSnapshot? beritaDoc;

  const TambahEditBeritaScreen({super.key, this.beritaDoc});

  @override
  State<TambahEditBeritaScreen> createState() => _TambahEditBeritaScreenState();
}

class _TambahEditBeritaScreenState extends State<TambahEditBeritaScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _urlGambarController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.beritaDoc != null) {
      final data = widget.beritaDoc!.data() as Map<String, dynamic>;
      _judulController.text = data['judul'] ?? '';
      _isiController.text = data['isi'] ?? '';
      _urlGambarController.text = data['gambarUrl'] ?? '';
    }
  }

  Future<void> _submitBerita() async {
    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();
    final gambarUrl = _urlGambarController.text.trim();

    if (judul.isEmpty || isi.isEmpty || gambarUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul, isi, dan URL gambar tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
  if (widget.beritaDoc == null) {
    // Tambah baru
    await FirebaseFirestore.instance.collection('berita').add({
      'judul': judul,
      'isi': isi,
      'gambarUrl': gambarUrl,
      'timestamp': Timestamp.now(),
    });
  } else {
    // Edit
    await widget.beritaDoc!.reference.update({
      'judul': judul,
      'isi': isi,
      'gambarUrl': gambarUrl,
    });
  }

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Berhasil"),
      content: Text(widget.beritaDoc == null
          ? "Berita berhasil ditambahkan"
          : "Berita berhasil diperbarui"),
      actions: [
        TextButton(
  onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog terlebih dahulu
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BiodataListScreen()),
                );
              },

  child: const Text("OK"),
),

      ],
    ),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Gagal menyimpan berita: $e")),
  );
} finally {
  setState(() => _isLoading = false);
}
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.beritaDoc != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Berita" : "Tambah Berita"),
        backgroundColor: const Color(0xFF0E1B2C),
      ),
      backgroundColor: const Color(0xFF0E1B2C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Judul Berita"),
            _buildTextField(_judulController, "Masukkan Judul"),

            const SizedBox(height: 16),
            _buildLabel("Isi Berita"),
            _buildTextField(_isiController, "Masukkan Isi Berita", maxLines: 8),

            const SizedBox(height: 16),
            _buildLabel("URL Gambar"),
            _buildTextField(_urlGambarController, "https://example.com/gambar.jpg"),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitBerita,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                minimumSize: const Size.fromHeight(50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isEdit ? "Simpan Perubahan" : "Upload Berita"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.blueGrey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
