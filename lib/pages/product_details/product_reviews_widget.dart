import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductReviewsWidget extends StatefulWidget {
  @override
  _ProductReviewsWidgetState createState() => _ProductReviewsWidgetState();
}

class _ProductReviewsWidgetState extends State<ProductReviewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('BOUGUERA Ibrahim',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    Text('01/03/2021')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    initialRating: 5,
                    itemSize: 15.0,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                ),
                Text(
                  'Nice Phone, i recommend it',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('BOUGUERA Ibrahim',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    Text('01/03/2021')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    initialRating: 5,
                    itemSize: 15.0,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                ),
                Text(
                  'Nice Phone, i recommend it',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('BOUGUERA Ibrahim',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    Text('01/03/2021')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    initialRating: 5,
                    itemSize: 15.0,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                ),
                Text(
                  'Nice Phone, i recommend it',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('BOUGUERA Ibrahim',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    Text('01/03/2021')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    initialRating: 5,
                    itemSize: 15.0,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                ),
                Text(
                  'Nice Phone, i recommend it',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('BOUGUERA Ibrahim',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    Text('01/03/2021')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    initialRating: 5,
                    itemSize: 15.0,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                ),
                Text(
                  'Nice Phone, i recommend it',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
