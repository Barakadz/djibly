import 'package:djibly/models/color.dart';

class Review {
  int id;
  int review;
  String comment;



  Review({this.id, this.review, this.comment});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'],
        review: int.parse(json['review'].toString()),
        comment: json['comment']);
  }
}
