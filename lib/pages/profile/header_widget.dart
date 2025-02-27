import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/presenters/profile_presenter.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/image_picker_service.dart';
import 'package:djibly/ui/components/placeholders/circle_avatar_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  double headerHeight;

  HeaderWidget({this.headerHeight});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "🟢🟢🟢 ############## header widget USER profilePresenter ${Provider.of<ProfilePresenter>(context, listen: true).user.profilePicture}");
    return Consumer<ProfilePresenter>(
      builder: (_, profilePresenter, ch) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.maxFinite,
          child: DecoratedBox(
            decoration: new BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _imageFile == null
                          ? CachedNetworkImage(
                              imageUrl:
                                  profilePresenter.user.profilePicture != null
                                      ? Network.storagePath +
                                          profilePresenter.user.profilePicture
                                      : '',
                              httpHeaders: Network.headersWithBearer,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: widget.headerHeight * 0.6,
                                height: widget.headerHeight * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          widget.headerHeight * 0.6)),
                                  border: Border.all(
                                      color: Color(0xffffffff), width: 3.0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => SizedBox(
                                width: widget.headerHeight * 0.6,
                                height: widget.headerHeight * 0.6,
                                child: CircleAvatarPlaceholder(),
                              ),
                              placeholder: (context, url) => SizedBox(
                                width: widget.headerHeight * 0.6,
                                height: widget.headerHeight * 0.6,
                                child: CircleAvatarPlaceholder(),
                              ),
                            )
                          : Container(
                              width: widget.headerHeight * 0.6,
                              height: widget.headerHeight * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: FileImage(_imageFile),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(widget.headerHeight * 0.6)),
                                border: Border.all(
                                  color: Colors.grey[400],
                                  width: 4.0,
                                ),
                              ),
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey[200],
                          ),
                          width: 44,
                          height: 44,
                          child: IconButton(
                              onPressed: () async {
                                _pickImage();
                              },
                              icon: Icon(
                                Icons.photo_camera,
                                size: 22,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _pickImage() async {
    final pickedImage = await ImagePickerService.getImageFromGallery();

    _imageFile = pickedImage != null
        ? await ImagePickerService.cropImage(pickedImage.path)
        : null;
    if (_imageFile != null) {
      setState(() {});
      _updateProfilePicture();
    }
  }

  _updateProfilePicture() async {
    Loader.show(
      context,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.black),
        strokeWidth: 2.0,
      ),
    );

    bool response = await Provider.of<ProfilePresenter>(context, listen: false)
        .updateProfilePicture(_imageFile.path);
    if (response) {
      setState(() {
        _imageFile = null;
      });
    }
    Loader.hide();
  }
}
