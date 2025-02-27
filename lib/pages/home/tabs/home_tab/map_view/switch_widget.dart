import 'dart:ffi';

import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/app/features/pos/presentation/controllers/pos_list_controller.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Flutter code sample for [CupertinoSlidingSegmentedControl].

enum Sky { midnight, viridian, cerulean }

class DistanceSegmentedControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<POSListController>();
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...[5, 10, 20, 50].map((e) => InkWell(
                  onTap: () {
                    if (controller.selectedSegment.value == e) {
                      controller.selectedSegment.value = 0;
                    } else
                      controller.selectedSegment.value = e;
                    controller.fetchWithFilter(dist: e, pageNumber: 1);
                  },
                  child: FilterWidget(
                    isSelected: e == controller.selectedSegment.value,
                    text: e,
                  ),
                )),
          ].addSeparators(SizedBox(
            width: 12,
          )),
        ));
    /*  return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey,
          )),
      child: CupertinoSlidingSegmentedControl<Sky>(
        backgroundColor: Colors.grey.shade200,
        thumbColor: Colors.white,

        // This represents the currently selected segmented control.
        groupValue: _selectedSegment,
        // Callback that sets the selected segmented control.
        onValueChanged: (Sky value) {
          if (value != null) {
            setState(() {
              _selectedSegment = value;
            });
          }
        },
        children: const <Sky, Widget>{
          Sky.midnight: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '20 KM',
              style: TextStyle(),
            ),
          ),
          Sky.viridian: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '30 KM',
              style: TextStyle(),
            ),
          ),
        },
      ),
    );
  */
  }
}

class FilterWidget extends StatelessWidget {
  final bool isSelected;
  final void onSelected;
  final int text;
  const FilterWidget({
    Key key,
    this.isSelected = false,
    this.onSelected,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    POSListController controller = Get.find();
    return SizedBox(
      height: 35,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade200 : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            children: <Widget>[
              Text(
                '${text} ${context.translate.km_text}',
                style: context.text.labelMedium.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              if (isSelected)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.selectedSegment(0);
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                          ),
                          child: SizedBox(height: 14, width: 1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 4,
                        left: 8,
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 14,
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
