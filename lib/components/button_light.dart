import 'package:flutter/material.dart';

class LightButton extends StatelessWidget {
  const LightButton({super.key,required this.onTap,required this.text});
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Theme.of(context).colorScheme.secondary
            ),
            child: Center(
              child: Text(text,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary),),
            ),
          ),
        )
    );
  }
}
