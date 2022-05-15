import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool isFilled;

  const CustomOutlinedButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color = const Color(0xFF5BB7F0),
      this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        backgroundColor: MaterialStateProperty.all(
            isFilled ? color.withOpacity(0.3) : Colors.transparent),
      ),
      onPressed: () => this.onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          this.text,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
