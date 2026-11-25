import 'package:cloud_firestore/cloud_firestore.dart';

class Biodata{
  String id;
  String name;
  int age;
  String address;

  Biodata(
    {required this.id,
     required this.name,
      required this.age,
      required this.address});

  factory Biodata.fromDocument(DocumentSnapshot doc) {
    return Biodata(
      id: doc.id,
      name: doc['name'],
      age: doc['age'],
      address: doc['address'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'age': age,
      'address': address,
    };
  }
}