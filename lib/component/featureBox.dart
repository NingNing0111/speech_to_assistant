import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {

  final String headerText;
  final String descriptionText;
  final Color backgroundColor;

  const FeatureBox({
    super.key,
    required this.headerText,
    required this.descriptionText,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: backgroundColor
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(headerText, style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
              ),),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                descriptionText,
                style: const TextStyle(
                  fontSize: 16
                ),
              ),
            )
          ],
        )
      ),
    );
  }

}