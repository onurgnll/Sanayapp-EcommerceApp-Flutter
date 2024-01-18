import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayapp2/ApplicantPage.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/EditProductPage.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/HomePage.dart';
import 'package:sanayapp2/Notification/notification.dart';
import 'package:sanayapp2/PersonPage.dart';
import 'package:sanayapp2/helpers/ShowSnackBar.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class ProductDetailPage extends StatefulWidget {
  final String? email;
  final String? productname;
  final String? owner;

  ProductDetailPage(
      {required this.email, required this.owner, required this.productname});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var product;
  var user;
  var isApplicated = false;
  List applicants = [];
  var userToken;

  void getIsUserApplicated() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('applications')
        .where('owner', isEqualTo: widget.owner)
        .where('product', isEqualTo: widget.productname)
        .where('applicatorEmail', isEqualTo: widget.email)
        .where('approved', isEqualTo: "Belli Değil")
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      var data = documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        if (data.isNotEmpty) {
          isApplicated = true;
          print(isApplicated);
        }
      });
    }
  }

  void handleApplicate() async {
    if (isApplicated) {
      showSnackbar(context, "Ürün Başvurun İptal Edildi", snackBarDanger);
      setState(() {
        isApplicated = false;
      });
      QuerySnapshot querySnapshot = await firestore
          .collection('applications')
          .where('owner', isEqualTo: widget.owner)
          .where('product', isEqualTo: widget.productname)
          .where('applicatorEmail', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('applications')
            .doc(querySnapshot.docs.first.id)
            .delete();
      } else {
        print('Belirtilen okula sahip kullanıcı bulunamadı.');
      }
    } else {
      showSnackbar(context, "Ürün Başvurun Tamamlandı", snackBarSuccess);
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          user = data;
        });
      }
      await firestore.collection('applications').add({
        'applicatorEmail': widget.email,
        'applicatorName': user['name'],
        'product': product['name'],
        'owner': product['owner'],
        'approved': "Belli Değil",
        'readed': false
      });
      setState(() {
        isApplicated = true;
      });

      await firestore.collection('notifications').add({
        'content':
            '${user['name']} Paylaştığın ${product['name']} Ürününe Başvurdu',
        'owner': '${widget.owner}',
        'readed': false,
      });

      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection("usertokens")
          .where("email", isEqualTo: widget.owner)
          .get();

      setState(() {
        userToken = querySnapshot2.docs.first["token"];
      });
      String body =
          '${user['name']} ${product['name']} ürününe başvuruda bulundu';
      sendPushMessage(userToken, body, "Ürününe Başvuru Yapıldı");
    }
  }

  void getProductDetail() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('products')
          .where('owner', isEqualTo: widget.owner)
          .where('name', isEqualTo: widget.productname)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          var data = documentSnapshot.data() as Map<String, dynamic>;

          setState(() {
            product = data;
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

  void getApplications() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('applications')
          .where('owner', isEqualTo: widget.owner)
          .where('product', isEqualTo: widget.productname)
          .where('readed', isEqualTo: false)
          .get();

      List applications = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data() as Map<String, dynamic>;

        applications.add(data);
      }

      setState(() {
        applicants = applications;
        print(applications);
      });
    } catch (e) {
      print("Error getting categories: $e");
    }
  }

  void handleDeleteButton() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('products')
          .where('owner', isEqualTo: widget.email)
          .where('name', isEqualTo: widget.productname)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          // Delete the product
          await documentSnapshot.reference.delete();
          showSnackbar(context, "Ürün Başarıyla Silindi", snackBarDanger);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: widget.email,
            ),
          ),
        );
      } else {
        print("Product not found");
      }
    } catch (e) {
      // Handle any potential errors
      print("Error deleting product: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getApplications();
    getProductDetail();
    getIsUserApplicated();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWitdh = MediaQuery.of(context).size.width;
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?['name'] ?? "Yükleniyor...",
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                      Text(product?['category'] ?? "Yükleniyor...",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      SizedBox(
                        width: screenWitdh - 10,
                        child: Text(product?['description'] ?? "Yükleniyor...",
                            overflow: TextOverflow.clip,
                            maxLines: 16,
                            style: const TextStyle(
                                fontSize: 20, overflow: TextOverflow.ellipsis)),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Satıcı:",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            child: Text(product?['owner'] ?? "Yükleniyor...",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.blue)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonPage(
                                    email: widget.email,
                                    showingEmail: product?['owner'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.owner == widget.email)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.white),
                          onPressed: () {
                            handleDeleteButton();
                          },
                        ),
                      ),
                    if (widget.owner == widget.email)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(iconsColor),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductPage(
                                  email: widget.email,
                                  productname: widget.productname,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                if (widget.owner != widget.email)
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF7A600)),
                            onPressed: handleApplicate,
                            child: Text(
                              isApplicated ? "İptal Et" : "Başvur",
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.owner == widget.email)
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF7A600)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicantPage(
                                    email: widget.email,
                                    productname: widget.productname,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Başvurular",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
