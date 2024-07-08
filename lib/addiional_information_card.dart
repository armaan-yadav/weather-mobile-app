import "package:flutter/material.dart";

class AdditionalInformationCard extends StatelessWidget {
  const AdditionalInformationCard({
    required this.icon,
    required this.name,
    required this.value,
    super.key,
  });
  final IconData icon;
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                icon,
                size: 35,
              ),
              const SizedBox(height: 5),
              Text(name),
              const SizedBox(height: 5),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
