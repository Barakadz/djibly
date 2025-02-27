import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/app/features/pos/presentation/controllers/pos_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedFIlterWidget extends StatelessWidget {
  const SelectedFIlterWidget({
    Key key,
    this.filterName,
    this.filterValue,
    this.onClose,
  }) : super(key: key);

  final String filterName;
  final String filterValue;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    POSListController controller = Get.find();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(
          4,
        ),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Text(
            filterName,
            style: context.text.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: SizedBox(
                width: 1,
                height: 30,
              )),
          Text(
            context.translate.is_text,
            style: context.text.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: SizedBox(
                width: 1,
                height: 30,
              )),
          Text(
            filterValue,
            style: context.text.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            enableFeedback: true,
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.clear,
                size: 16,
              ),
            ),
          )
        ].addSeparators(
          SizedBox(
            width: 6,
          ),
        ),
      ),
    );
  }
}
