import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import '../../../../../models/ads.dart';
import '../../../../../presenters/home_presenter.dart';
import '../../../../../services/http_services/api_http.dart';
import '../../../../../ui/components/placeholders/home_carousel_placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utilities/routes.dart';

class HomeCarouselWidget extends StatefulWidget {
  final List<Ads> ads;

  const HomeCarouselWidget({Key key, this.ads}) : super(key: key);

  @override
  State<HomeCarouselWidget> createState() => _HomeCarouselWidgetState();
}

class _HomeCarouselWidgetState extends State<HomeCarouselWidget> {
  int _selectedSlide = 0;

  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 180,
                    viewportFraction: .85,
                    initialPage: 4,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 1500),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _selectedSlide = index;
                      });
                    }),
                items: widget.ads.map((ad) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: InkWell(
                            onTap: () async {
                              switch (ad.redirectType) {
                                case Ads.URL_REDIRECT_CODE:
                                  try {
                                    launchUrl(Uri.parse(ad.redirectTo),
                                        mode: LaunchMode.externalApplication);
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                  break;
                                case Ads.TAB_REDIRECT_CODE:
                                  Provider.of<HomePresenter>(context,
                                          listen: false)
                                      .setSelectedTabByTagName(ad.redirectTo);
                                  break;
                                case Ads.PAGE_REDIRECT_CODE:
                                  if (routes.containsKey(ad.redirectTo))
                                    Navigator.of(context)
                                        .pushNamed(ad.redirectTo);
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: CachedNetworkImage(
                              imageUrl: Network.storagePath + ad.picture,
                              httpHeaders: Network.headersWithBearer,
                              imageBuilder: (context, imageProvider) => Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  HomeCarouselPlaceholder(),
                              placeholder: (context, url) =>
                                  HomeCarouselPlaceholder(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 20 * widget.ads.length.toDouble(),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ...Iterable<int>.generate(widget.ads.length).map(
                              (int pageIndex) => Container(
                                width: 5.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _selectedSlide == pageIndex
                                      ? context.colorScheme.primary
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
