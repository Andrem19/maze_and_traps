import 'package:flutter/material.dart';

class FacetedTile extends StatelessWidget {
  final double bevelSize;

  FacetedTile({super.key, this.bevelSize = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
    );
  }
}
