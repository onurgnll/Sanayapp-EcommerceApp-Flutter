import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/ApplicantPage.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class ApplicationsPage extends StatefulWidget {
  final String? email;

  ApplicationsPage({required this.email});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List products = [];

  void getAppliedProducts() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('applications')
          .where('owner', isEqualTo: widget.email)
          .where('readed', isEqualTo: false)
          .get();

      List categoryNames = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        var productname = data['product'];

        QuerySnapshot querySnapshot = await firestore
            .collection('products')
            .where('owner', isEqualTo: widget.email)
            .where('name', isEqualTo: productname)
            .get();

        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          categoryNames.add(data);
        }
      }

      setState(() {
        products = categoryNames;
      });
    } catch (e) {
      print("Error getting categories: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppliedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(primaryColor),
        title: const Text(
          "BAŞVURULAR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(2.0),
        ),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                "Ürünlerinize Henüz Başvuru Yapılmamış.",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Container(
              color: Colors.white,
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.dstATop),
                          image: NetworkImage(products[index]['imageUrl']!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            child: Container(
                              margin: const EdgeInsets.only(top: 40.0),
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white54.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "${products[index]['name']}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 20),
                                backgroundColor:
                                    Colors.white54.withOpacity(0.4),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ApplicantPage(
                                      email: widget.email,
                                      productname: products[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('BAŞVURANLAR',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BtmAppBar(email: widget.email),
      floatingActionButton: FltngActionButton(email: widget.email),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
