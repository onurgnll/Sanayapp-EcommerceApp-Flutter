import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/ProductDetailPage.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class PersonPage extends StatefulWidget {
  final String? email;
  final String? showingEmail;

  PersonPage({required this.email, required this.showingEmail});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  String name = "";
  List products = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getUserDetails() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: widget.showingEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userName = querySnapshot.docs[0]['name'];

        setState(() {
          name = userName;
        });
      } else {
        print("User not found");
      }
      QuerySnapshot querySnapshot2 = await firestore
          .collection('products')
          .where('owner', isEqualTo: widget.showingEmail)
          .get();

      if (querySnapshot2.docs.isNotEmpty) {
        List prods = [];
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot2.docs) {
          var data = documentSnapshot.data() as Map<String, dynamic>;

          prods.add(data);
        }

        setState(() {
          products = prods;
        });
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                height: 160,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(
                    left: 25, right: 25, top: 35, bottom: 25),
                decoration: BoxDecoration(
                  color: Color(primaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/1870/1870038.png"),
                          radius: 40,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: Container(
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
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop),
                            image: NetworkImage(products[index]['imageUrl']),
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
                                      builder: (context) => ProductDetailPage(
                                        email: widget.email,
                                        owner: products[index]['owner'],
                                        productname: products[index]['name'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("İNCELE",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BtmAppBar(email: widget.email),
      floatingActionButton: FltngActionButton(
        email: widget.email,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
