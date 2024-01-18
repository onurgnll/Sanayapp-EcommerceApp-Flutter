import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/PersonPage.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class ApplicantPage extends StatefulWidget {
  final String? email;
  final String? productname;

  ApplicantPage({required this.email, required this.productname});

  @override
  State<ApplicantPage> createState() => _ApplicantPageState();
}

class _ApplicantPageState extends State<ApplicantPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List applicants = [];

  void getApplicants() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('applications')
          .where('owner', isEqualTo: widget.email)
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
      });
    } catch (e) {
      print("Error getting categories: $e");
    }
  }

  void approveApplication(
      String productName, String owner, String applicatorEmail) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference applicationsCollection =
          firestore.collection('applications');

      QuerySnapshot applicationQuery = await applicationsCollection
          .where('product', isEqualTo: productName)
          .where('owner', isEqualTo: owner)
          .limit(1)
          .get();

      if (applicationQuery.docs.isNotEmpty) {
        DocumentSnapshot applicationSnapshot = applicationQuery.docs.first;
        await applicationSnapshot.reference
            .update({'readed': true, 'approved': "Onaylandı"});
        getApplicants();
      } else {
        print('Belge bulunamadı');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  void denyApplication(
      String productName, String owner, String applicatorEmail) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference applicationsCollection =
          firestore.collection('applications');

      QuerySnapshot applicationQuery = await applicationsCollection
          .where('product', isEqualTo: productName)
          .where('owner', isEqualTo: owner)
          .limit(1)
          .get();

      if (applicationQuery.docs.isNotEmpty) {
        DocumentSnapshot applicationSnapshot = applicationQuery.docs.first;
        await applicationSnapshot.reference
            .update({'readed': true, 'approved': "Reddedildi"});
        getApplicants();
      } else {
        print('Belge bulunamadı');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(primaryColor),
        title: const Text(
          "BAŞVURANLAR",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 2.0,
          ),
          preferredSize: const Size.fromHeight(2.0),
        ),
      ),
      body: applicants.isEmpty
          ? const Center(
              child: Text(
                "Ürüne Başvuran bulunmamaktadır.",
                style: TextStyle(fontSize: 20),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 5,
              ),
              itemCount: applicants.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFFD9D9D9),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/1870/1870038.png"),
                              radius: 25,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextButton(
                            child: Text(
                              "${applicants[index]['applicatorName']}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonPage(
                                    email: widget.email,
                                    showingEmail: applicants[index]
                                        ['applicatorEmail'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            approveApplication(
                                applicants[index]['product'],
                                applicants[index]['owner'],
                                applicants[index]['applicatorEmail']);
                          },
                          child: const Text('KABUL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              denyApplication(
                                  applicants[index]['product'],
                                  applicants[index]['owner'],
                                  applicants[index]['applicatorEmail']);
                            },
                            child: const Text('RED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BtmAppBar(email: widget.email),
      floatingActionButton: FltngActionButton(
        email: widget.email,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
