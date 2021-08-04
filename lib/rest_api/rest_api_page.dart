import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_sandbox/rest_api/album.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RestApiPage extends StatefulWidget {
  static const id = 'rest_ap_page';

  const RestApiPage({Key key}) : super(key: key);

  @override
  _RestApiPageState createState() => _RestApiPageState();
}

class _RestApiPageState extends State<RestApiPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget albumTitleCard(String title, int userId) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        title: Text(title),
        trailing: Text('$userId'),
      ),
    );
  }

  void pushAlbum(BuildContext context, AppLocalizations localizations) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      body: jsonEncode({"userId": 2, "title": "New Album addition"}),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      CoolAlert.show(
        width: double.infinity,
        context: context,
        type: CoolAlertType.success,
        title: 'Fake insertion to server',
        text: response.body.substring(1, 61),
      );
    } else {
      throw Exception('Failed to push new album');
    }
  }

  void onFABPressed(BuildContext context, AppLocalizations localizations) {
    switch (_tabController.index) {
      case 0:
        pushAlbum(context, localizations);
        break;
    }
  }

  List<Album> parseAlbums(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Album>((json) => Album.fromJson(json)).toList();
  }

  Future<List<Album>> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      return parseAlbums(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Widget onSelectedWindow(int index, AppLocalizations localizations) {
    Widget indexedWidget;
    switch (index) {
      case 0:
        indexedWidget = FutureBuilder<List<Album>>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Album> albums = snapshot.data;
              return ListView.builder(
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    return albumTitleCard(
                        albums[index].title, albums[index].userId);
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return SizedBox(
                width: 50,
                height: 50,
                child: Center(child: const CircularProgressIndicator()));
          },
        );
        break;
    }
    return indexedWidget;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'rest_api_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Rest API');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    final List<Tab> basicWidgetTabs = <Tab>[
      Tab(text: 'http'),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey.shade50,
          isScrollable: true,
          tabs: basicWidgetTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          onSelectedWindow(0, localizations),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          onFABPressed(context, localizations);
        },
      ),
    );
  }
}
