import 'package:cloud_firestore/cloud_firestore.dart';

class Berita {
  final String id;
  final String judul;
  final String isi;
  final String gambarUrl;
  final Timestamp timestamp;

  Berita({
    required this.id,
    required this.judul,
    required this.isi,
    required this.gambarUrl,
    required this.timestamp,
  });

  factory Berita.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Berita(
      id: doc.id,
      judul: data['judul'] ?? '',
      isi: data['isi'] ?? '',
      gambarUrl: data['gambarUrl'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
