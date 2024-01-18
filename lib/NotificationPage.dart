import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayapp2/BtmAppBar.dart';
import 'package:sanayapp2/FltngActionBtn.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class NotificationPage extends StatefulWidget {
  final String? email;

  NotificationPage({required this.email});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notifications = [];
  void getNotifications() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('notifications')
          .where('owner', isEqualTo: widget.email)
          .where('readed', isEqualTo: false)
          .get();
      List notification = [];
      notification.clear();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data() as Map<String, dynamic>;

        notification.add(data);
      }

      setState(() {
        notifications = notification;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(primaryColor),
        title: const Text(
          "BİLDİRİMLER",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.grey,
            height: 2.0, // Çizgi kalınlığı
          ),
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "Bildiriminiz bulunmamaktadır.",
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
              itemCount: notifications.length,
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
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.announcement,
                            size: 40,
                            color: Color(0xFFF7A600),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "${notifications[index]['content']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BtmAppBar(
        email: widget.email,
      ),
      floatingActionButton: FltngActionButton(
        email: widget.email,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
