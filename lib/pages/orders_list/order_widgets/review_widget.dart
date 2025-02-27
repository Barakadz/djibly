import 'package:djibly/presenters/order_presenter.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatefulWidget {
  int orderItemID ;
  ReviewWidget({Key key, this.orderItemID}) : super(key: key);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {

  TextEditingController commentController = new TextEditingController();
  double rating = 1;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 250 + MediaQuery.of(context).viewInsets.bottom,
          color: Colors.white,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Quel est votre évaluation ?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RatingBar(
                      initialRating: 1,
                      minRating: 1,
                      maxRating: 5,
                      allowHalfRating: false,
                      itemSize: 40.0,
                      ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.yellow),
                        half: const Icon(Icons.star_half, color: Colors.yellow),
                        empty:
                        const Icon(Icons.star_border, color: Colors.yellow),
                      ),
                      onRatingUpdate: (rating) {
                        this.rating = rating;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
                    child: TextField(
                      controller: commentController,
                      maxLines: 1,
                      decoration: InputDecoration.collapsed(
                          hintText: "Comment ...", fillColor: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      child: CustomRoundedElevatedButton(
                        onPressed: () async {
                          if(isLoading)
                            return;
                          setState(() {
                            isLoading = true;
                          });

                          final data = {
                            "rating":rating,
                            "comment":commentController.text
                          };

                          bool response = await Provider.of<OrderPresenter>(context,listen: false).postReview(widget.orderItemID, data);
                          setState(() {
                            isLoading = false;
                          });
                          if(response)
                            Navigator.of(context).pop();
                        },
                        buttonColor: DjiblyColor,
                        isDisabled: isLoading,
                        child: isLoading ? CircularProgressIndicator(
                          strokeWidth: 2,
                        ) : Text(
                          'Envoyer'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
