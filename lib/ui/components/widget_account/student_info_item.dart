import 'package:flutter/material.dart';

class StudentInfoItem extends StatelessWidget {
  const StudentInfoItem({
    super.key,
    required this.name,
    required this.value,
  });

  final String? name;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? "(unknown)",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              value ?? "(unknown)",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
