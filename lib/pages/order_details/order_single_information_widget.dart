import 'package:flutter/material.dart';

class OrderSingleInformation extends StatefulWidget {
  String information;
  IconData icon;

  OrderSingleInformation({this.information, this.icon});

  @override
  _OrderSingleInformationState createState() =>
      _OrderSingleInformationState();
}

class _OrderSingleInformationState extends State<OrderSingleInformation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    widget.icon,
                    size: 22.0,
                    color: Color(0xFFe31D1A),
                  ),
                ),
              ),
              TextSpan(
                text: widget.information,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
