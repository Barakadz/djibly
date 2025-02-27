import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_clip_path_container.dart';

class CustomModel {
  final String title;
  final String subTitle;
  final Widget child;
  final String iconPath;
  final List<Widget> actions;
  final BuildContext context;

  const CustomModel(
      {Key key,
      this.subTitle,
      this.iconPath,
      this.context,
      this.title,
      this.actions,
      this.child});

  showSimpleCustomDialog() {
    Dialog simpleDialog = Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipPath(
                  clipper: CustomClipPathContainer(),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xFF4d9cf3)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 8.0),
                      child: Container(
                        height: 180.0,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                110,
                                        child: Text(
                                          this.title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                110,
                                        child: Text(
                                          this.subTitle,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.white),
                                  child: Center(
                                    child: Image.asset(
                                      this.iconPath,
                                      width: 50.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                  child: this.child,
                ),
              ],
            ),
          )),
        );
      }),
    );
    showDialog(
        context: this.context, builder: (BuildContext context) => simpleDialog);
  }
}
