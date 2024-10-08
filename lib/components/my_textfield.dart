import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData? icon;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    this.icon
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {

  bool _showHint = true;

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(255, 135, 181, 136)),
                  borderRadius: BorderRadius.circular(18)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(255, 51, 132, 53)),
                  borderRadius: BorderRadius.circular(18)
                ),
                hintText: _showHint ? widget.hintText : null,
                hintStyle: const TextStyle(color: Colors.grey),
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                /*prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.lightGreen) : null*/
              ),
              onTap: () {
                setState(() {
                  _showHint = false;
                });
              },
              /*onChanged: (value) {
                setState(() {
                  _showHint = value.isEmpty;
                });
              },*/
            )
          ],
        ),
      ),
    );
  }
}