import 'dart:io';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/app/features/pos/presentation/controllers/pos_list_controller.dart';
import 'package:djibly/presenters/local_controller.dart';
import 'package:djibly/presenters/local_presenter.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:djibly/models/language.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class LanguageButton extends StatefulWidget {
  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.find();
    var languageCode2 = controller.locale.value.languageCode;
    final posController = Get.put(POSListController());

    void refreshPosList() async {
      posController.list.clear();
      posController.wilayaID(0);
      posController.communeID(0);
      posController.getWilayas();
      posController.getCommune();
      final listData = await posController.fetchNearbyPos(
        dist: posController.selectedSegment.value,
        pageNumber: posController.currentPage.value,
      );

      posController.list.addAll(listData);
      posController.list.refresh();
    }

    return Column(
      children: [
        InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return SizedBox(
                height: 280,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          color: Colors.white),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16),
                          child: Column(
                            children: <Widget>[
                              ...Language.languageList().map((e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        controller.setLocale(
                                            new Locale(e.languageCode));

                                        refreshPosList();

                                        Navigator.of(context).pop();

                                        /*    if (Platform.isIOS)
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/",
                                              (Route<dynamic> route) => false); */
                                      },
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: languageCode2 ==
                                                      e.languageCode
                                                  ? Colors.blue
                                                  : Colors.transparent),
                                          color: languageCode2 == e.languageCode
                                              ? Colors.blue.shade50
                                              : Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(children: <Widget>[
                                            Expanded(
                                              child: Text(e.name,
                                                  style: context
                                                      .text.titleMedium
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: languageCode2 ==
                                                                  e.languageCode
                                                              ? Colors.blue
                                                              : Colors.black)),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ))),
                ),
              );
            },
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
              12,
            )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Row(
                children: <Widget>[
                  Icon(Icons.language),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(Language.languageList()
                        .firstWhere((element) =>
                            element.languageCode ==
                            controller.locale.value.languageCode)
                        .name),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
        ),
        /*    Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            alignment: Alignment.center,
            decoration: InputDecoration(
              prefix: SizedBox(height:40,child:  Icon(Icons.language)),
              suffixIcon: Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 12),
              filled: true,
              fillColor: Colors.white,
              
              border:OutlineInputBorder(gapPadding: 12,borderSide: BorderSide(color: Colors.transparent),),
              enabledBorder:OutlineInputBorder(gapPadding: 16,borderSide: BorderSide(color: Colors.transparent))
            ),
            icon: SizedBox(width: 0.0, height: 0.0),
           
            dropdownColor: Colors.white,
            value: Provider.of<LocalePresenter>(context,listen: false).locale.languageCode,
            onChanged: (String langCode) {
              Provider.of<LocalePresenter>(context,listen: false).setLocale(new Locale(langCode));
              Navigator.of(context).pop();
              Restart.restartApp();
              if(Platform.isIOS)
                Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
        
            },
            items: Language.languageList()
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                value: e.languageCode,
                child: Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: Text(
                    e.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
      */
      ],
    );
  }
}
