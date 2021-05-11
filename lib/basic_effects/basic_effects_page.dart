import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/basic_effects/rive_refresh_view.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:provider/provider.dart';

class BasicEffectsPage extends StatefulWidget {
  static const id = 'basic_effects_page';
  @override
  _BasicEffectsPageState createState() => _BasicEffectsPageState();
}

class _BasicEffectsPageState extends State<BasicEffectsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Basic Effects');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    final List<Tab> basicEffectTabs = <Tab>[
      Tab(text: AppLocalizations.of(context).basicEffectsParallaxTitle),
      Tab(text: AppLocalizations.of(context).basicEffectsShimmerTitle),
      Tab(text: AppLocalizations.of(context).basicEffectsRiveRefreshTitle),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey.shade50,
          isScrollable: true,
          tabs: basicEffectTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ParallaxView(),
          ShimmerView(),
          RiveRefresh(),
        ],
      ),
    );
  }
}

class ShimmerView extends StatelessWidget {
  const ShimmerView({
    Key key,
  }) : super(key: key);

  Future<List<int>> _getResults() async {
    await Future.delayed(
      Duration(seconds: 7),
    );
    return List<int>.generate(10, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
        // perform the future delay to simulate request
        future: _getResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: 10,
              // Important code
              itemBuilder: (context, index) => GFShimmer(
                child: ShimmerListItem(
                  index: -1,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => ShimmerListItem(
              index: index + 1,
            ),
          );
        });
  }
}

class ParallaxView extends StatelessWidget {
  const ParallaxView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget landscapeView = Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          constraints: BoxConstraints(maxHeight: 200.0),
          child: ListView.builder(
            itemCount: locations.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return BuildCard(
                imageUrl: locations[index].imageUrl,
                title: locations[index].name,
                subtitle: locations[index].place,
                aspectRatio: 3 / 4,
                titleFontSize: 12.0,
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return BuildCard(
                imageUrl: locations[index].imageUrl,
                title: locations[index].name,
                subtitle: locations[index].place,
              );
            },
          ),
        ),
      ],
    );

    Widget portraitView = Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 200.0),
          child: ListView.builder(
            itemCount: locations.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return BuildCard(
                imageUrl: locations[index].imageUrl,
                title: locations[index].name,
                subtitle: locations[index].place,
                aspectRatio: 3 / 4,
                titleFontSize: 12.0,
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return BuildCard(
                imageUrl: locations[index].imageUrl,
                title: locations[index].name,
                subtitle: locations[index].place,
              );
            },
          ),
        ),
      ],
    );
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        return landscapeView;
      } else {
        return portraitView;
      }
    });
  }
}

class BuildCard extends StatelessWidget {
  const BuildCard({
    Key key,
    @required this.imageUrl,
    @required this.title,
    @required this.subtitle,
    this.aspectRatio = 16 / 9,
    this.titleFontSize = 16.0,
    this.subtitleFontSize = 14.0,
    this.titleColor = Colors.white,
    this.subtitleColor = Colors.white,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final double aspectRatio;
  final double titleFontSize;
  final double subtitleFontSize;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Card(
        color: Colors.orange.shade400,
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ParallaxImage(
            image: NetworkImage(imageUrl),
            extent: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.6, 0.95],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: subtitleColor,
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
    );
  }
}

class Location {
  const Location({
    @required this.name,
    @required this.place,
    @required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://flutter.dev/docs/cookbook/img-files/effects/parallax';
const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Supertree Grove',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(
    name: 'Cairo',
    place: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];

class ShimmerListItem extends StatelessWidget {
  ShimmerListItem({Key key, this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return index != -1
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context).basicEffectsIndexNumberOf} $index',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              '${AppLocalizations.of(context).basicEffectsIndex} $index ${AppLocalizations.of(context).basicEffectsIndexDescription}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.orange,
                  ),
                  right: BorderSide(
                    width: 1,
                    color: Colors.orange,
                  ),
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.orange,
                  ),
                  left: BorderSide(
                    width: 1,
                    color: Colors.orange,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            color: Colors.red,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 10,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
