import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita App',
      theme: ThemeData.dark(),
      home: NewsDetailPage(),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekomendasi Berita'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mencermati Politik PSU di Banjarmaru, Cara Soft Power Justru Cara yang Bijak',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '7 April 2025 12:09 WITA',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage('assets/news_image.jpg'), // Ganti dengan path gambar Anda
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Dinamika politik pemungutan suara ulang (PSU) di Banjarmaru menarik untuk dicermati dibandingkan dengan PSU di kabupaten/kota lain di Indonesia.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Seb Sebab, rata-rata PSU terkait soal selisih hitungan suara antara paslon menjelang PSU terlihat berlangsungan dari saling merebut simpati.',
                style: TextStyle(fontSize: 16),
              ),
              // Tambahkan isi berita lebih lanjut di sini
            ],
          ),
        ),
      ),
    );
  }
}