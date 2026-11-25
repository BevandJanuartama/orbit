import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'biodata_model.dart';

class AddEditBiodataScreen extends StatefulWidget {
  final Biodata? biodata;

  const AddEditBiodataScreen({super.key, this.biodata});

  @override
  // ignore: library_private_types_in_public_api
  AddEditBiodataScreenState createState() => AddEditBiodataScreenState();
}

class AddEditBiodataScreenState extends State<AddEditBiodataScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _age;
  late String _address;

  @override
  void initState() {
    super.initState();
    if (widget.biodata != null) {
      _name = widget.biodata!.name;
      _age = widget.biodata!.age;
      _address = widget.biodata!.address;
    } else {
      _name = '';
      _age = 0;
      _address = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.biodata != null ? 'Edit Biodata' : 'Add Biodata'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
                onSaved: (value) => _age = int.parse(value!),
              ),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    
    CollectionReference biodataCollection = 
    FirebaseFirestore.instance.collection('biodata');

    try {
      if (widget.biodata != null) {
        // Update
        await biodataCollection.doc(widget.biodata!.id).update({
          'name': _name,
          'age': _age,
          'address': _address,
        });
      } else {
        // Create
        await biodataCollection.add({
          'name': _name,
          'age': _age,
          'address': _address,
        });
      }
      // Success: navigate back
      Navigator.pop(context);
    } catch (e) {
      // Handle error here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save biodata: $e'))
      );
    }
  }
},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
