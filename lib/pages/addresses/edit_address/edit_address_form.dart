import 'package:awesome_select/awesome_select.dart';
import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/models/commune.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/models/wilaya.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:djibly/utilities/validate.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/styles.dart';
import '../../../services/toast_service.dart';

class EditAddressFrom extends StatefulWidget {
  final String addressId;
  const EditAddressFrom({Key key, this.addressId}) : super(key: key);

  @override
  _EditAddressFromState createState() => _EditAddressFromState();
}

class _EditAddressFromState extends State<EditAddressFrom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _wilayaId = TextEditingController();
  final _communeId = TextEditingController();
  bool _isDefault = false;

  editAddress(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate() && _communeId != null && _wilayaId != null) {
      String phone = _phone.text;
      if (phone.length == 10) phone = removeFirstDigit(phone);
      Map<String, dynamic> data = {
        "first_name": _firstName.text,
        "last_name": _lastName.text,
        "address": _address.text,
        "phone": phone,
        "default": _isDefault,
        "commune_id": _communeId.text
      };
      Loader.show(
        context,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.black),
          strokeWidth: 2.0,
        ),
      );
      await Provider.of<UserAddress>(context, listen: false)
          .editAddress(data, widget.addressId);
      Loader.hide();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<Wilaya>(context, listen: false)
            .setSelectedWilaya(_wilayaId.text));
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<Commune>(context, listen: false)
            .setSelectedCommune(_communeId.text));
  }

  String removeFirstDigit(String phoneNumber) {
    if (phoneNumber.isNotEmpty) {
      return phoneNumber.substring(1);
    } else {
      return phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UserAddress>(context, listen: false)
            .getAddress(widget.addressId),
        builder: (BuildContext context, AsyncSnapshot<UserAddress> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              Loader.show(
                context,
                progressIndicator: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                  strokeWidth: 2.0,
                ),
              );
              return Container();
            default:
              Loader.hide();
              if (snapshot.hasError) {
                return Center(
                    child: CommonStyles.errorConnectionWidget(context));
              } else {
                _firstName..text = snapshot.data.firstName;
                _lastName..text = snapshot.data.lastName;
                _phone..text = snapshot.data.phone;
                _address..text = snapshot.data.address;
                _wilayaId..text = snapshot.data.wilayaId.toString();
                _communeId..text = snapshot.data.communeId.toString();
                _isDefault = snapshot.data.isDefault;
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                context.translate.first_name_text,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _firstName,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecorationStyle(
                                  prefixIcon: FeatherIcons.user),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context
                                      .translate.first_name_empty_error;
                                }
                                if (!nameRegex.hasMatch(value)) {
                                  return context
                                      .translate.first_name_not_valid_error;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                context.translate.name_text,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _lastName,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecorationStyle(
                                  prefixIcon: FeatherIcons.user),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context
                                      .translate.last_name_empty_error;
                                }
                                if (!nameRegex.hasMatch(value)) {
                                  return context
                                      .translate.last_name_not_valid_error;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                context.translate.phone_number_text,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phone,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecorationStyle(
                                prefixIcon: Icons.phone,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context
                                      .translate.phone_number_empty_error;
                                }
                                if (!algerianPhoneRegex.hasMatch(value)) {
                                  return context
                                      .translate.phone_number_not_valid_error;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                context.translate.address_text,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextFormField(
                                controller: _address,
                                textInputAction: TextInputAction.next,
                                decoration: inputDecorationStyle(
                                  prefixIcon: Icons.pin_drop_outlined,
                                ),
                                validator: (value) {
                                  _address..text = value.trim();
                                  if (value == null || value.isEmpty) {
                                    return context
                                        .translate.address_empty_error;
                                  }
                                  if (!addressRegex.hasMatch(value)) {
                                    return 'Please enter a valid address';
                                  }
                                  return null;
                                }),
                          ],
                        ),
                        Text(
                          context.translate.wilaya_text,
                          style: context.text.titleMedium.copyWith(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FutureBuilder<List<S2Choice<String>>>(
                                  initialData: [],
                                  future: Provider.of<Wilaya>(context,
                                          listen: false)
                                      .getWilayas(),
                                  builder: (context, snapshot) {
                                    return Consumer<Wilaya>(
                                      builder: (_, wilayaProvider, ch) =>
                                          SmartSelect<String>.single(
                                        tileBuilder: (context, state) {
                                          return S2Tile.fromState(
                                            state,
                                            isLoading:
                                                ConnectionState.waiting ==
                                                        snapshot.connectionState
                                                    ? true
                                                    : false,
                                            isTwoLine: false,
                                          );
                                        },
                                        modalFilter: true,
                                        modalConfig: S2ModalConfig(
                                          useHeader: false,
                                          title: '',
                                          style: S2ModalStyle(
                                              backgroundColor: Colors.white),
                                          type: S2ModalType.bottomSheet,
                                        ),
                                        choiceConfig: S2ChoiceConfig(
                                          useDivider: true,
                                          style: S2ChoiceStyle(
                                            color: Colors.black,
                                            titleStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        placeholder:
                                            AppLocalizations.of(context)
                                                .select_text,
                                        selectedValue: _wilayaId.text,
                                        choiceItems: snapshot.data,
                                        onChange: (state) {
                                          if (state.value != _wilayaId) {
                                            _wilayaId..text = state.value;
                                            _communeId..text = '';
                                            Provider.of<Wilaya>(context,
                                                    listen: false)
                                                .setSelectedWilaya(
                                                    _wilayaId.text);
                                            Provider.of<Commune>(context,
                                                    listen: false)
                                                .setSelectedCommune(null);
                                          }
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            Consumer<Wilaya>(
                              builder: (_, wilayaProvider, ch) =>
                                  wilayaProvider.getGelectedWilaya() == null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8.0),
                                          child: Text(
                                            context
                                                .translate.wilaya_empty_error,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFFe31D1A),
                                                fontSize: 12.0),
                                          ),
                                        )
                                      : Container(),
                            )
                          ],
                        ),
                        Text(
                          context.translate.commune_text,
                          style: context.text.titleMedium.copyWith(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Consumer<Wilaya>(
                                builder: (_, wilayaProvider, ch) =>
                                    FutureBuilder<List<S2Choice<String>>>(
                                        initialData: [],
                                        future: _wilayaId.text == ''
                                            ? null
                                            : Commune.getCommunes(
                                                _wilayaId.text),
                                        builder: (context, snapshot) {
                                          return SmartSelect<String>.single(
                                            tileBuilder: (context, state) {
                                              return S2Tile.fromState(
                                                state,
                                                isLoading: ConnectionState
                                                            .waiting ==
                                                        snapshot.connectionState
                                                    ? true
                                                    : false,
                                                title: Text(
                                                  wilayaProvider
                                                              .getGelectedWilaya() !=
                                                          null
                                                      ? ""
                                                      : context.translate
                                                          .select_text,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0),
                                                ),
                                                //padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                                                isTwoLine: false,
                                              );
                                            },
                                            modalFilter: true,
                                            modalConfig: S2ModalConfig(
                                              //useHeader: false,
                                              title: _communeId != null
                                                  ? _communeId.text
                                                  : context
                                                      .translate.select_text,

                                              style: S2ModalStyle(
                                                  backgroundColor:
                                                      Colors.white),
                                              type: S2ModalType.bottomSheet,
                                            ),
                                            choiceConfig: S2ChoiceConfig(
                                              useDivider: true,
                                              style: S2ChoiceStyle(
                                                color: Colors.black,
                                                titleStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            selectedValue: _communeId.text,
                                            placeholder:
                                                AppLocalizations.of(context)
                                                    .select_text,
                                            choiceItems: snapshot.data,
                                            onChange: (state) {
                                              _communeId..text = state.value;
                                              Provider.of<Commune>(context,
                                                      listen: false)
                                                  .setSelectedCommune(
                                                      _communeId.text);
                                            },
                                          );
                                        }),
                              ),
                            ),
                            Consumer<Commune>(
                              builder: (_, communeProvider, ch) =>
                                  communeProvider.getGelectedCommune() == null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8.0),
                                          child: Text(
                                            context
                                                .translate.commune_empty_error,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFFe31D1A),
                                                fontSize: 12.0),
                                          ),
                                        )
                                      : Container(),
                            )
                          ],
                        ),
                        StatefulBuilder(
                          builder: (context, setState) => Container(
                            height: 50.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      context.translate.set_default_address,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _isDefault,
                                  onChanged: (bool isOn) {
                                    setState(() {
                                      _isDefault = isOn;
                                    });
                                  },
                                  activeColor: Color(0xFFe31D1A),
                                  activeTrackColor: Color(0xFFe31D1A),
                                  inactiveTrackColor: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: CustomElevatedButton(
                                  isDisabled: false,
                                  buttonColor: DjiblyColor,
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await editAddress(context);
                                    ToastService.showSuccessToast(context
                                        .translate
                                        .edit_address_successfully_text);

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  // color: Color(0xFFe31D1A),
                                  child: !isLoading
                                      ? Text(
                                          context.translate.edit_text,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          );
                        }),
                      ].addSeparators(SizedBox(
                        height: 16,
                      )),
                    ),
                  ),
                );
              }
          }
        });
  }
}
