
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/widgets/CustomsPainters/custom_marker.dart';

class WidgetMarker extends StatelessWidget {

  GlobalKey globalKey = GlobalKey();

  final String name;
  final String type;
  final String count;

  WidgetMarker({
     required this.name, 
    required this.type, 
    required this.count
    });

  @override
  Widget build(BuildContext context) {

        return Container(
          width: 330,
          height: 200,
          color: Colors.red,
          child: CustomPaint(
            painter: CustomMarker(
              name: 'Restaurante el canalete',
              type: 'Restaurante'
              
            ),
          ),
        );

  }


}

