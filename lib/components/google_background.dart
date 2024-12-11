import 'package:flutter/material.dart';

class GABackground extends StatelessWidget {
  const GABackground({super.key,required this.stringPath});
  final String stringPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white
      ),
      child: Image.asset(stringPath,height: 60,),
    );
  }
}


