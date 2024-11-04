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
        padding: const EdgeInsets.only(top: 7, bottom: 9, left: 12, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
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
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.copy),
            ),
          ],
        ),
      ),
    );
  }
}
