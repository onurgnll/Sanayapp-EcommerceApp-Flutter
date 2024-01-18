import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sanayapp2/HomePage.dart';
import 'package:sanayapp2/helpers/ShowSnackBar.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class AddProductPage extends StatefulWidget {
  final String? email;

  AddProductPage({required this.email});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _AddProductPageState extends State<AddProductPage> {
  final storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String dropdownValue = list.first;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  XFile? file;

  void onPressed() async {
    ImagePicker _picker = ImagePicker();
    XFile? filee = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = filee;
    });
  }

  void shareButtonHandle() async {
    try {
      var productRef = FirebaseStorage.instance
          .ref("products/" + _nameController.text + widget.email.toString());

      var task = productRef.putFile(
          File(file!.path),
          SettableMetadata(
            contentType: "image/jpeg",
          ));

      task.whenComplete(() async {
        var url = await productRef.getDownloadURL();
        await firestore.collection('products').add({
          'description': _descriptionController.text,
          'imageUrl': url,
          'name': _nameController.text,
          'owner': widget.email,
          'category': dropdownValue
        });
      });
      showSnackbar(context, "Ürün başarıyla eklendi.", snackBarSuccess);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            email: widget.email,
          ),
        ),
      );
    } catch (e) {
      showSnackbar(context, "Ürün Oluştururken Hata Oluştu.", snackBarDanger);
    }
  }

  void getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();

      List<String> categoryNames = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        var categoryName = data['name'];
        categoryNames.add(categoryName);
      }

      setState(() {
        list = categoryNames;
        dropdownValue = list.first;
      });
    } catch (e) {
      print("Error getting categories: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BtmAppBar(email: widget.email),
      floatingActionButton: FltngActionButton(email: widget.email),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9D9D9),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: (file != null
                        ? DecorationImage(image: FileImage(File(file!.path)))
                        : null),
                  ),
                  width: 100,
                  height: 85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 45,
                      ),
                      Text(
                        file?.name ?? "Fotoğraf Ekle",
                        style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    "Tedarik İsmi",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      width: 250,
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelStyle:
                                  TextStyle(fontFamily: 'Arial', fontSize: 20),
                              border: InputBorder.none,
                            ),
                          )))
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Tedarik Kategorisi",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 250,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        value: dropdownValue,
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Tedarik Açıklaması",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      width: 250,
                      height: 120,
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 15,
                            decoration: const InputDecoration(
                              labelStyle:
                                  TextStyle(fontFamily: 'Arial', fontSize: 20),
                              border: InputBorder.none,
                            ),
                          ))),
                ],
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(175, 45),
                      backgroundColor: Color(iconsColor)),
                  onPressed: shareButtonHandle,
                  child: const Text(
                    "Paylaş",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ))
        ],
      ),
      appBar: AppBar(
        backgroundColor: Color(primaryColor),
        title: const Text(
          "Ürün Oluştur",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.grey,
            height: 2.0,
          ),
        ),
      ),
    );
  }
}
