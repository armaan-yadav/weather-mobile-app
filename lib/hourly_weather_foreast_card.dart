import "package:flutter/material.dart";

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard(
      {super.key, required this.icon, required this.time, required this.value});

  final IconData icon;
  final String time;
  final String value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Icon(
                icon,
                size: 35,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
