import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String degree;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.degree,
    required this.icon});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 100,
      decoration:  const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all( 8.0),
          child: Column(
            children: [
              Text( maxLines: 1, overflow: TextOverflow.fade, time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              const SizedBox(height: 8,),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(height: 8,),
              Text("$degree°C", style: const TextStyle(fontSize: 13,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}