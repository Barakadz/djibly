// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PosWidget extends StatelessWidget {
  final Pos pos;

  const PosWidget({key, this.pos});

  double _getPosWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.8 * 0.6;
  }

  double _getAvatarWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.8 * 0.6 * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                placeholderFadeInDuration: Duration(seconds: 0),
                fadeInDuration: Duration(seconds: 0),
                fadeOutDuration: Duration(seconds: 0),
                imageUrl: Network.storagePath + pos.picture,
                httpHeaders: Network.headersWithBearer,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Color(0xffffffff), width: 3.0),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Image.asset("assets/images/user-avatar.png");
                },
                placeholder: (context, url) {
                  return Image.asset("assets/images/user-avatar.png");
                },
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pos.name,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  pos.address,
                  // oerflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium,
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${pos.lat},${pos.lon}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pin_drop_outlined,
                                size: 18,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                context.translate.open_map,
                                style: context.text.labelLarge,
                              ),
                            ],
                          )),
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
