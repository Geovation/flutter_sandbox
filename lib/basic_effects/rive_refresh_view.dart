import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sandbox/basic_effects/rive_refresh_controller.dart';
import 'package:rive/rive.dart';

class RiveRefresh extends StatefulWidget {
  @override
  _RiveRefreshState createState() => _RiveRefreshState();
}

class _RiveRefreshState extends State<RiveRefresh> {
  Artboard _artboard;
  RefreshController _controller;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  /// Loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/rive/rocket_reload_run7.riv');
    final file = RiveFile.import(bytes);
    if (file != null) {
      setState(() {
        _artboard = file.mainArtboard;
        _artboard.addController(_controller = RefreshController());
      });
    }
  }

  Widget buildRefreshWidget(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent) {
    _controller.refreshState = refreshState;
    _controller.pulledExtent = pulledExtent;
    _controller.triggerThreshold = refreshTriggerPullDistance;
    _controller.refreshIndicatorExtent = refreshIndicatorExtent;

    return _artboard != null
        ? Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Rive(
                artboard: _artboard,
                fit: BoxFit.cover,
                alignment: Alignment.center),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF342472),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              _controller.reset();
            }
            return true;
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 170.0,
                refreshIndicatorExtent: 170.0,
                builder: buildRefreshWidget,
                onRefresh: () {
                  return Future<void>.delayed(const Duration(seconds: 5))
                    ..then<void>((_) {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                },
              ),
              SliverSafeArea(
                top: false, // Top safe area is consumed by the navigation bar.
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SizedBox(
                          height: 150,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                                color: Color(0xFF4A3F8A),
                                borderRadius: BorderRadius.circular(5)),
                          ));
                    },
                    childCount: 10,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
