import 'package:awesome_select/awesome_select.dart';
import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app/features/pos/presentation/controllers/pos_list_controller.dart';
import '../switch_widget.dart';

class FilterWidget extends StatelessWidget {
  FilterWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    POSListController controller = Get.find();
    controller.getWilayas();
    return SizedBox(
      height: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.translate.filters_text,
                        style: context.textTheme.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          FeatherIcons.x,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          context.translate.distance_text,
                          style: context.textTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        DistanceSegmentedControlWidget(),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          context.translate.wilaya_text,
                          style: context.text.titleMedium.copyWith(),
                        ),
                        Obx(
                          () => DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4)),
                            child: SmartSelect<String>.single(
                              groupHeaderBuilder:
                                  (context, value, anotherValue) =>
                                      const Text('text'),
                              tileBuilder: (context, state) {
                                return S2Tile.fromState(
                                  state,
                                  isLoading: controller.isLoadingWilaya.value,
                                  isTwoLine: false,
                                  dense: true,
                                  trailing: controller.wilayaID == 0
                                      ? null
                                      : GestureDetector(
                                          onTap: () {
                                            controller.wilayaID(0);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                border: Border.all(
                                                  color: Colors.red.shade600,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 14,
                                                  color: Colors.red.shade600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              },
                              modalFilter: true,
                              placeholder: "",
                              modalConfig: S2ModalConfig(
                                useHeader: true,
                                headerStyle: S2ModalHeaderStyle(
                                  textStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                style:
                                    S2ModalStyle(backgroundColor: Colors.white),
                                type: S2ModalType.bottomSheet,
                              ),
                              title: controller.wilayaID.value != 0
                                  ? controller.wilayaText.value
                                  : context.translate.select_text,
                              choiceLayout: S2ChoiceLayout.list,
                              choiceItems: controller.willayList.value,
                              onChange: controller.onsWillayaChange,
                            ),
                          ),
                        ),
                        Text(
                          context.translate.commune_text,
                          style: context.text.titleMedium.copyWith(),
                        ),
                        Obx(
                          () => DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4)),
                            child: SmartSelect<String>.single(
                              choiceActiveStyle: S2ChoiceStyle(
                                showCheckmark: true,
                              ),
                              tileBuilder: (context, state) {
                                return S2Tile.fromState(
                                  state,
                                  dense: true,
                                  isLoading: controller.isLoadingCommune.isTrue,
                                  isTwoLine: false,
                                  trailing: controller.communeID == 0
                                      ? null
                                      : GestureDetector(
                                          onTap: () {
                                            controller.communeID(0);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                border: Border.all(
                                                  color: Colors.red.shade600,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 14,
                                                  color: Colors.red.shade600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  loadingMessage: SizedBox(),
                                );
                              },
                              placeholder: "",
                              modalFilter: true,
                              modalConfig: S2ModalConfig(
                                useHeader: true,
                                headerStyle: S2ModalHeaderStyle(
                                  textStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                style:
                                    S2ModalStyle(backgroundColor: Colors.white),
                                type: S2ModalType.bottomSheet,
                              ),
                              title: controller.communeID.value > 0
                                  ? controller.communeText.value
                                  : context.translate.select_text,
                              choiceLayout: S2ChoiceLayout.list,
                              choiceItems: controller.communeList.value,
                              onChange: controller.onsCommuneChange,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),
                        // *** Commune
                      ].addSeparators(
                        SizedBox(height: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              16.0,
                            ),
                            child: Center(
                                child: Text(
                              context.translate.apply,
                              style: context.textTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onPrimary,
                              ),
                            )),
                          )),
                    ),
                  ),
                )
              ].addSeparators(
                SizedBox(
                  height: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
