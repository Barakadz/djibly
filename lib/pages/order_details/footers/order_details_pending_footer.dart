import 'package:djibly/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsPendingFooter extends StatefulWidget {

  @override
  _OrderDetailsPendingFooterState createState() => _OrderDetailsPendingFooterState();
}

class _OrderDetailsPendingFooterState extends State<OrderDetailsPendingFooter> {

  bool _isRejectedLoading = false;
  bool _isAcceptedLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Order>(
        builder: (_, orderProvider, ch) =>Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isRejectedLoading = true;
                    });
                    await Provider.of<Order>(context,listen: false).rejectOrder(orderProvider.selectedOrder.id);
                    setState(() {
                      _isRejectedLoading = false;
                    });
                  },
                  // color: Color(0xFFe31D1A),
                  // disabledColor: Color(0xFFe31D1A),
                  child: _isRejectedLoading ? SizedBox(
                    height: 15.0,
                    width: 15.0,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 2.0,
                    ),
                  ): Text(
                    "non disponible".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: 30, vertical: 12),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius:
                  //     BorderRadius.circular(80.0)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isAcceptedLoading = true;
                    });
                    // await Provider.of<Order>(context,listen: false).acceptOrder(orderProvider.selectedOrder.id);
                    setState(() {
                      _isAcceptedLoading = false;
                    });
                    Navigator.of(context).pop(Order.STATUS_VALIDATED);
                  },
                  // color: Colors.lightGreen,
                  // disabledColor: Colors.lightGreen,
                  child: !_isAcceptedLoading
                      ? Text(
                    "confirmer".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                        FontWeight.normal),
                  )
                      : SizedBox(
                    height: 15.0,
                    width: 15.0,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation(
                          Colors.white),
                      strokeWidth: 2.0,
                    ),
                  ),
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: 30, vertical: 12),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius:
                  //     BorderRadius.circular(80.0)),
                ),
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }
}
