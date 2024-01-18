import 'package:flutter/material.dart';
import 'package:sanayapp2/ApplicationsPage.dart';
import 'package:sanayapp2/NotificationPage.dart';
import 'package:sanayapp2/PersonPage.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';
import 'package:sanayapp2/HomePage.dart';

class BtmAppBar extends StatefulWidget {
  final String? email;

  BtmAppBar({required this.email});

  @override
  State<BtmAppBar> createState() => _BtmAppBarState();
}

class _BtmAppBarState extends State<BtmAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 65,
      shape: const CircularNotchedRectangle(),
      color: Color(primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              size: 40,
              color: Color(iconsColor),
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    email: widget.email,
                  ),
                ),
              );
            },
            splashColor: Colors.grey,
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              size: 40,
              color: Color(iconsColor),
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonPage(
                    email: widget.email,
                    showingEmail: widget.email,
                  ),
                ),
              );
            },
            splashColor: Colors.grey,
          ),
          const SizedBox(width: 60),
          IconButton(
            icon: Icon(
              Icons.request_page,
              size: 40,
              color: Color(iconsColor),
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicationsPage(email: widget.email),
                ),
              );
            },
            splashColor: Colors.grey,
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              size: 40,
              color: Color(iconsColor),
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(email: widget.email),
                ),
              );
            },
            splashColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
