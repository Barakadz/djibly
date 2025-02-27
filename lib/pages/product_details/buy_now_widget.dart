import 'package:flutter/material.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/utilities/common_styles.dart';

class BuyNowWidget extends StatefulWidget {
  final PosProduct product;
  BuyNowWidget({this.product});
  @override
  _BuyNowWidgetState createState() => _BuyNowWidgetState();
}

class _BuyNowWidgetState extends State<BuyNowWidget> {
  bool isLoading = false;
  final _quantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantity..text = '1';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: Network.storagePath + widget.product.picture,
                    httpHeaders: Network.headersWithBearer,
                    height: 150.0,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Row(
                    children: [
                      TextButton(
                        // color: Colors.grey,
                        onPressed: () {
                          int newQuantity = int.parse(_quantity.text);
                          if(newQuantity > 1){
                            setState(() {
                              newQuantity --;
                              _quantity..text = newQuantity.toString();
                            });
                          }
                        },
                        // height: 40.0,
                        // minWidth: 40.0,
                        child: Icon(
                          FontAwesomeIcons.minus,
                          size: 15.0,
                          color: Colors.black54,
                        ),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(80.0)),
                      ),
                      Expanded(
                        child: Container(
                          height: 60.0,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              readOnly: true,
                              controller: _quantity,
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                height: 2,
                              ),
                              decoration: CommonStyles.textFormFieldStyle(''),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        // color: Colors.grey,
                        // height: 40.0,
                        // minWidth: 40.0,
                        onPressed: () {
                          int newQuantity = int.parse(_quantity.text);
                          if(newQuantity< widget.product.quantity){
                            setState(() {
                              newQuantity ++;
                              _quantity..text = newQuantity.toString();
                            });
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.plus,
                          size: 15.0,
                          color: Colors.black54,
                        ),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(80.0)),
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 10.0, bottom: 10),
            child: ElevatedButton(
              onPressed: () async {
                //
              },
              // color: Color(0xFFe31D1A),
              // disabledColor: Color(0xFFe31d1a),
              child: !isLoading
                  ? Text(
                "Acheter maintenantr".toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              )
                  : SizedBox(
                height: 15.0,
                width: 15.0,
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 2.0,
                ),
              ),
              // padding:
              // EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(80.0)),
            ),
          )
        ],
      ),
    );
  }
}
