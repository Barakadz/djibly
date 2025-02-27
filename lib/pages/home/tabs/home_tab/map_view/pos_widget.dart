import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/ui/components/placeholders/circle_avatar_placeholder.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:djibly/pages/pos/pos_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PosWidget extends StatefulWidget {
  Pos pos;

  PosWidget({this.pos});

  @override
  _PosWidgetState createState() => _PosWidgetState();
}

class _PosWidgetState extends State<PosWidget> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ]),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 60,
                height: 60,
                child: CachedNetworkImage(
                  imageUrl: Network.storagePath + widget.pos.picture,
                  httpHeaders: Network.headersWithBearer,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Container(height: 60.0, child: CircleAvatarPlaceholder()),
                  placeholder: (context, url) =>
                      Container(height: 60.0, child: CircleAvatarPlaceholder()),
                  // Image.network(
                  //     Network.host + widget.pos.picture,
                  //     fit: BoxFit.cover)
                ),
              ), // first widget
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.pos.name,
                            style: TextStyle(
                                //color: currentlySelectedPin.labelColor
                                )),
                        Text('${widget.pos.address}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 20,
                              offset: Offset.zero,
                              color: Colors.grey.withOpacity(0.5))
                        ]),
                    child: CustomElevatedButton(
                      isDisabled: false,
                      buttonColor: DjiblyColor,
                      onPressed: () async {
                        Navigator.of(context).pushNamed(PosPage.routeName,
                            arguments: {
                              'name': widget.pos.name,
                              'id': widget.pos.id
                            });
                      },
                      // color: Color(0xFFe31D1A),
                      child: Text(
                        'Acceder'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )) // third widget
            ]));
  }
}
