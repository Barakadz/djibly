class Ads {

  static const URL_REDIRECT_CODE = 'url';
  static const TAB_REDIRECT_CODE = 'tab';
  static const PAGE_REDIRECT_CODE = 'page';
  static const NONE_REDIRECT_CODE = 'none';

  String app;
  String type;
  String redirectType;
  String redirectTo;
  String picture;

  Ads({this.app, this.type, this.redirectTo, this.redirectType, this.picture});

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
        app: json['app'],
        type: json['type'],
        redirectType: json['redirect_type'],
        redirectTo: json['redirect_to'],
        picture: json['picture']);
  }
}