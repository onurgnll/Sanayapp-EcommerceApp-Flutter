import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/HomePage.dart';
import 'package:sanayapp2/helpers/ShowSnackBar.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

List<String> list = <String>['Makine Sektörü'];

class EditProductPage extends StatefulWidget {
  final String? email;
  final String? productname;

  EditProductPage({required this.email, this.productname});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var product;
  String dropdownValue = list.first;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('categories').get();

      List<String> categoryNames = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        var categoryName = data['name'];
        categoryNames.add(categoryName);
      }

      getProductDetail();
      setState(() {
        list = categoryNames;
      });
    } catch (e) {
      print("Error getting categories: $e");
    }
  }

  void getProductDetail() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('products')
          .where('owner', isEqualTo: widget.email)
          .where('name', isEqualTo: widget.productname)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          var data = documentSnapshot.data() as Map<String, dynamic>;

          setState(() {
            product = data;
            _nameController.text = product['name'];
            _descriptionController.text = product['description'];

            dropdownValue = product['category'];
          });
        }
      } else {
        print("Product not found");
      }
    } catch (e) {
      // Handle any potential errors
      print("Error fetching product details: $e");
    }
  }

  void handleSaveButton() async {
    try {
      await firestore
          .collection('products')
          .where('owner', isEqualTo: widget.email)
          .where('name', isEqualTo: widget.productname)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            var productId = documentSnapshot.id;

            // Update the product details
            firestore.collection('products').doc(productId).update({
              'name': _nameController.text,
              'description': _descriptionController.text,
              'category': dropdownValue,
              // Add other fields as needed
            });

            showSnackbar(context, "Ürün Başarıyla Kaydedildi", snackBarSuccess);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  email: widget.email,
                ),
              ),
            );
          }
        } else {
          print("Product not found");
        }
      });
    } catch (e) {
      print("Error updating product details: $e");
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
    double screenHeight = MediaQuery.of(context).size.height;
    double halfScreenHeight = screenHeight / 2;
    return Scaffold(
      bottomNavigationBar: BtmAppBar(
        email: widget.email,
      ),
      floatingActionButton: FltngActionButton(
        email: widget.email,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        children: [
          SizedBox(
            height: halfScreenHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(product?['imageUrl'] ??
                    "https://paperconcept.pl/128905-home_default/keaykolour-paper-120g-pure-white-a5-20-sheets.jpg"),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none, // Kenar yarıçapı
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: SizedBox(
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
                      items: list.map<DropdownMenuItem<String>>((String value) {
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
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    maxLines: 4,
                    minLines: 3,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15, right: 20),
                    width: 130,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(iconsColor),
                      ),
                      onPressed: handleSaveButton,
                      child: const Text(
                        "KAYDET",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
