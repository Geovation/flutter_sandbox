import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
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

  final List<Tab> basicEffectTabs = <Tab>[
    Tab(text: 'Parallax'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: basicEffectTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget onSelectedWindow(int index) {
    Widget indexedWidget;
    switch (index) {
      case 0:
        indexedWidget = Column(
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

        break;
    }
    return indexedWidget;
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Basic Effects');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

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
          onSelectedWindow(0),
        ],
      ),
    );
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
