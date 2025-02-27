import 'package:flutter/material.dart';

class OrderStatusWidget extends StatefulWidget {
  String state;
  Color color;

  OrderStatusWidget({this.state,this.color});
  @override
  _OrderStatusWidgetState createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: widget.color.withOpacity(0.2),
      ),
      height: 40.0,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: Text(
          widget.state,
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.normal),
          //textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
