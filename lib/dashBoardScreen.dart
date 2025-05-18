import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlowItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  FlowItem({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
