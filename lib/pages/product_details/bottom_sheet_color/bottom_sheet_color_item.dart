import '../../../../app/core/extensions/theme_eextensions.dart';
import '../../../../utilities/constants.dart';
import 'package:flutter/material.dart';

class BottomSheetColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const BottomSheetColorItem({Key key, this.color, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: color,
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 22.0,
                      color: context.colorScheme.onPrimary,
                    )
                  : Container(),
            ),
          ),
          if (isSelected)
            Container(
              height: 40,
              width: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: context.colorScheme.primary.withOpacity(.2),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 22.0,
                        color: context.colorScheme.primary,
                      )
                    : Container(),
              ),
            ),
        ],
      ),
    );
  }
}
