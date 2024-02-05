// ignore_for_file: library_private_types_in_public_api
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:azkar/controller/controllers/app_controller.dart';
import 'package:azkar/controller/utils/themedata.dart';
import 'package:azkar/controller/utils/loading_indicator.dart';
import 'package:azkar/view/qibla/location_error_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QiblahCompass extends StatefulWidget {
  const QiblahCompass({Key? key}) : super(key: key);

  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  // ignore: prefer_typing_uninitialized_variables
  var futureAlbum;
  @override
  void initState() {
    futureAlbum = Provider.of<AppController>(context, listen: false)
        .checkLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: Provider.of<AppController>(context, listen: false).stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          if (snapshot.data!.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return QiblahCompassWidget();

              case LocationPermission.denied:
                return LocationErrorWidget(
                  error: "Location service permission denied",
                  callback: () async {
                    await futureAlbum;
                  },
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error: "Location service Denied Forever !",
                  callback: () async {
                    await futureAlbum;
                  },
                );
              default:
                return Container();
            }
          } else {
            return LocationErrorWidget(
              error: "Please enable Location service",
              callback: () async {
                await futureAlbum;
              },            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterQiblah().dispose();
  }
}

class QiblahCompassWidget extends StatelessWidget {
  final _compassSvg = SvgPicture.asset(
    'assets/images/compass.svg',
    color: ThemeDataProvider.mainAppColor,
  );
  final _needleSvg = SvgPicture.asset(
    'assets/images/needle.svg',
    fit: BoxFit.contain,
    height: 300,
    alignment: Alignment.center,
  );

  QiblahCompassWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        final qiblahDirection = snapshot.data!;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: (qiblahDirection.direction * (pi / 180) * -1),
              child: _compassSvg,
            ),
            Transform.rotate(
              angle: (qiblahDirection.qiblah * (pi / 180) * -1),
              alignment: Alignment.center,
              child: _needleSvg,
            ),
            Positioned(
              bottom: 8,
              child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
            )
          ],
        );
      },
    );
  }
}
