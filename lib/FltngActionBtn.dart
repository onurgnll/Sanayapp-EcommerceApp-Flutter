import 'package:flutter/material.dart';
import 'package:sanayapp2/CreateProductPage.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';

class FltngActionButton extends StatefulWidget {
  final String? email;

  FltngActionButton({required this.email});
  @override
  State<FltngActionButton> createState() => _FltngActionButtonState();
}

class _FltngActionButtonState extends State<FltngActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(email: widget.email),
            ),
          );
        },
        backgroundColor: Color(backGroundColor),
        elevation: 6.0,
        mini: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90.0),
        ),
        child: Icon(
          Icons.add,
          size: 80,
          color: Color(iconsColor),
        ),
      ),
    );
  }
}
