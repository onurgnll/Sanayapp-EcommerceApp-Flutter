import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/ProductDetailPage.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class HomePage extends StatefulWidget {
  final String? email;
  //final String? password;

  HomePage({required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = ["Makine Sektörü", "Kimya Sektörü"];
  final searchController = TextEditingController();
  List products = [];

  String? selectedCategory;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getProducts(String query, String category) async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('products').get();

      setState(() {
        products.clear();

        querySnapshot.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> productData =
              document.data() as Map<String, dynamic>;

          print(category);
          if (category == "Tüm Sektörler") {
            print("girdii");
            String productName =
                productData['name']?.toString().toLowerCase() ?? '';
            String lowercaseQuery = query.toLowerCase();

            if (productName.contains(lowercaseQuery)) {
              products.add(productData);
            }
          } else {
            String productName =
                productData['name']?.toString().toLowerCase() ?? '';
            String lowercaseQuery = query.toLowerCase();

            String categoryName =
                productData['category']?.toString().toLowerCase() ?? '';
            String lowercaseCategory = category.toLowerCase();

            if (productName.contains(lowercaseQuery) &&
                categoryName == lowercaseCategory) {
              products.add(productData);
            }
          }
        });
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

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

      setState(() {
        categories = categoryNames;
      });
    } catch (e) {
      print("Error getting categories: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts("", "Tüm Sektörler");
    getCategories();
    selectedCategory = "Tüm Sektörler";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(iconsColor), size: 40),
        toolbarHeight: 65.0,
        backgroundColor: Color(primaryColor),
        title: Container(
          height: 40,
          width: 310,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TextFormField(
            controller: searchController,
            onChanged: (value) {
              getProducts(searchController.text, selectedCategory.toString());
            },
            decoration: InputDecoration(
              hintText: 'Ürün Ara',
              labelStyle: const TextStyle(fontFamily: 'Arial', fontSize: 18),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: Color(iconsColor),
                size: 35,
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 115,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(primaryColor),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Kategoriler",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Tüm Sektörler",
                style: TextStyle(
                  fontSize: 20,
                  color: "Tüm Sektörler" == selectedCategory
                      ? Color(iconsColor)
                      : Colors.black,
                  // Customize the appearance based on selection
                ),
              ),
              onTap: () {
                setState(() {
                  selectedCategory = "Tüm Sektörler";
                  getProducts(searchController.text, "Tüm Sektörler");
                });
              },
            ),
            for (String category in categories)
              ListTile(
                title: Text(
                  category,
                  style: TextStyle(
                    fontSize: 20,
                    color: category == selectedCategory
                        ? Color(iconsColor)
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                    getProducts(searchController.text, category);
                  });
                },
              ),
          ],
        ),
      ),
      body: Container(
        color: Color(backGroundColor),
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
              onTap: () {
                print('Tapped on ${products[index]['name']}');
              },
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
                          backgroundColor: Colors.white54.withOpacity(0.4),
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
                        child: const Text('İNCELE',
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
      bottomNavigationBar: BtmAppBar(email: widget.email),
      floatingActionButton: FltngActionButton(email: widget.email),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
