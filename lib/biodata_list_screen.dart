import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tambah_berita_screen.dart';

class BiodataListScreen extends StatefulWidget {
  const BiodataListScreen({Key? key}) : super(key: key);

  @override
  State<BiodataListScreen> createState() => _BiodataListScreenState();
}

class _BiodataListScreenState extends State<BiodataListScreen> {
  final CollectionReference biodataCollection = 
      FirebaseFirestore.instance.collection('biodata');

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text(
          'Biodata & Berita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            const Divider(color: Colors.white54),
            const SizedBox(height: 8),
            _buildNewsTitle(),
            const SizedBox(height: 8),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF415A77),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.white70),
          hintText: 'Search Biodata',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildNewsTitle() {
    return const Text(
      'Berita Terbaru',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNewsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('berita')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada berita.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildNewsTile(data, doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildNewsTile(Map<String, dynamic> data, DocumentSnapshot doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: _buildLeadingImage(data['gambarUrl']),
        title: Text(
          data['judul'] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          data['isi'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: _buildTrailingButtons(doc),
      ),
    );
  }

  Widget _buildLeadingImage(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        : const Icon(Icons.image, color: Colors.white38);
  }

  Widget _buildTrailingButtons(DocumentSnapshot doc) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.lightBlueAccent),
          tooltip: 'Edit Berita',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahEditBeritaScreen(beritaDoc: doc),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          tooltip: 'Hapus Berita',
          onPressed: () => _showDeleteBeritaConfirmation(context, doc.id),
        ),
      ],
    );
  }

  void _showDeleteBeritaConfirmation(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus berita ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _deleteBerita(docId);
                Navigator.of(context).pop();
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  void _deleteBerita(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('berita').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita berhasil dihapus.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus berita.')),
      );
    }
  }
}