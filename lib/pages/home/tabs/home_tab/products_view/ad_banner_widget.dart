import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/models/ads.dart';
import 'package:djibly/presenters/home_presenter.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/ui/components/placeholders/home_carousel_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:djibly/utilities/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AdBannerWidget extends StatefulWidget {
  final Ads ad;

  const AdBannerWidget({Key key, this.ad}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.ad != null) {
          switch (widget.ad.redirectType) {
            case Ads.URL_REDIRECT_CODE:
              try {
                await launchUrl(Uri.parse(widget.ad.redirectTo));
              } catch (exception) {}
              break;
            case Ads.TAB_REDIRECT_CODE:
              Provider.of<HomePresenter>(context, listen: false)
                  .setSelectedTabByTagName(widget.ad.redirectTo);
              break;
            case Ads.PAGE_REDIRECT_CODE:
              if (routes.containsKey(widget.ad.redirectTo))
                Navigator.of(context).pushNamed(widget.ad.redirectTo);
              break;
            default:
              break;
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          right: 16,
        ),
        child: widget.ad != null
            ? CachedNetworkImage(
                imageUrl: Network.storagePath + widget.ad.picture,
                httpHeaders: Network.headersWithBearer,
                imageBuilder: (context, imageProvider) => Container(
                  height: MediaQuery.of(context).size.width <= 500 ? 140 : 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Container(height: 140.0, child: HomeCarouselPlaceholder()),
                placeholder: (context, url) =>
                    Container(height: 140.0, child: HomeCarouselPlaceholder()),
              )
            : Container(),
      ),
    );
  }
}
