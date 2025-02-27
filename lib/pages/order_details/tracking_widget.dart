import '../../app/core/extensions/theme_eextensions.dart';
import '../../helpers/string_helper.dart';
import '../../models/delivery_state.dart';
import '../../models/order.dart';
import '../../presenters/order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackingWidget extends StatefulWidget {
  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            /*   Stepper(
              currentStep: 1,
              steps: <Step>[
                Step(
                    title: const Text('Step 1 title'),
                    content: SizedBox(width: 0.0, height: 0.0)),
                const Step(
                  title: Text('Step 2 title'),
                  content: SizedBox(width: 0.0, height: 0.0),
                ),
              ],
            ), */

            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                width: 10,
                color: _getStateColor(context, Order.STATUS_PENDING),
                padding: EdgeInsets.all(0),
              ),
              endChild: _RightChild(
                asset: 'assets/images/delivery/order_placed.png',
                title: AppLocalizations.of(context).created_text,
                message: getState(context, Order.STATUS_PENDING) != null
                    ? "${getState(context, Order.STATUS_PENDING).date.toDateTimeFormat()}"
                    : '',
              ),
              beforeLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_PENDING),
              ),
              afterLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_PENDING),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle: IndicatorStyle(
                width: 10,
                color: _getStateColor(context, Order.STATUS_VALIDATED),
                padding: EdgeInsets.all(6),
              ),
              endChild: _RightChild(
                asset: 'assets/images/delivery/order_confirmed.png',
                title: AppLocalizations.of(context).confirmed_text,
                message: getState(context, Order.STATUS_VALIDATED) != null
                    ? "${getState(context, Order.STATUS_VALIDATED).date.toDateTimeFormat()}"
                    : '',
              ),
              beforeLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_PENDING),
              ),
              afterLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_VALIDATED),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle: IndicatorStyle(
                width: 10,
                color: _getStateColor(context, Order.STATUS_DELIVERING),
                padding: EdgeInsets.all(6),
              ),
              endChild: _RightChild(
                asset: 'assets/images/delivery/order_processed.png',
                title: AppLocalizations.of(context).on_delivery_text,
                message: getState(context, Order.STATUS_DELIVERING) != null
                    ? "${getState(context, Order.STATUS_DELIVERING).date.toDateTimeFormat()}"
                    : '',
              ),
              beforeLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_VALIDATED),
              ),
              afterLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_DELIVERING),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                width: 10,
                color: _getStateColor(context, Order.STATUS_FINISHED),
                padding: EdgeInsets.all(6),
              ),
              endChild: _RightChild(
                disabled: true,
                asset: 'assets/images/delivery/ready_to_pickup.png',
                title: AppLocalizations.of(context).delivered_text,
                message: getState(context, Order.STATUS_FINISHED) != null
                    ? "${getState(context, Order.STATUS_FINISHED).date.toDateTimeFormat()}"
                    : '',
              ),
              beforeLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_DELIVERING),
              ),
              afterLineStyle: LineStyle(
                color: _getStateColor(context, Order.STATUS_FINISHED),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStateColor(context, String state) {
    return Provider.of<OrderPresenter>(context, listen: false)
            .isStateExist(state)
        ? Color(0xFF007D32)
        : Color(0xFFDADADA);
  }

  DeliveryState getState(context, String state) {
    return Provider.of<OrderPresenter>(context, listen: false).getState(state);
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          /*
          
            Opacity(
            child: Image.asset(asset, height: 18),
            opacity: disabled ? 0.5 : 1,
          ), 
          
          */

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: context.text.labelLarge,
              ),
              const SizedBox(height: 6),
              Text(
                message,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
