import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/database/objectbox/person_dao_objectbox.dart';
import 'package:flutter_sandbox/database/objectbox/person_model.dart';
import 'package:flutter_sandbox/database/sembast/model/person.dart';
import 'package:flutter_sandbox/database/sembast/person_dao_sembast_db.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class DatabasePage extends StatefulWidget {
  static const id = 'database_page';
  const DatabasePage({Key key}) : super(key: key);

  @override
  _DatabasePageState createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Tab> databaseTabs = <Tab>[
    Tab(text: 'Sembast'),
    Tab(text: 'Objectbox'),
  ];

  List<DataRow> sembastDataRow = [];
  List<PersonSembast> sembastPersonList = [];
  List<DataRow> objectboxDataRow = [];
  List<PersonObjectbox> objectboxPersonList = [];

  PersonDaoObjectboxDB _personDaoObjectboxDB;
  PersonDaoSembastDB _personDaoSembastDB;

  Function fabOnPressed = () {};

  void _setActiveTabIndex() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          fabOnPressed = () {
            addPersonSembastDB(_personDaoSembastDB);
          };
          break;
        case 1:
          fabOnPressed = () {
            addPersonObjectbox(_personDaoObjectboxDB);
          };
          break;
      }
    });
  }

  void addPersonObjectbox(PersonDaoObjectboxDB personDaoObjectboxDB) {
    PersonObjectbox insertPerson = PersonObjectbox(name: '', age: 0, role: '');
    personDaoObjectboxDB.insert(insertPerson);
  }

  void addPersonSembastDB(PersonDaoSembastDB personDaoSembastDB) {
    PersonSembast insertPerson = PersonSembast(name: '', age: 0, role: '');
    personDaoSembastDB.insert(insertPerson);
  }

  void addDataSembastDB(
      PersonDaoSembastDB personDao, AppLocalizations localizations) async {
    sembastPersonList = await personDao.getAllSortedByName();
    sembastDataRow.clear();
    for (int i = 0; i < personDao.getPersonsCount; i++) {
      sembastDataRow.add(
        DataRow(
          selected: false,
          key: Key(sembastPersonList[i].id.toString()),
          cells: <DataCell>[
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: localizations.dbName),
                initialValue: '${sembastPersonList[i].name}',
                keyboardType: TextInputType.name,
                onFieldSubmitted: (updatedName) {
                  personDao.update(
                    PersonSembast(
                      id: sembastPersonList[i].id,
                      name: updatedName,
                      age: sembastPersonList[i].age,
                      role: sembastPersonList[i].role,
                    ),
                  );
                },
              ),
            ),
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: localizations.dbAge),
                initialValue: '${sembastPersonList[i].age}',
                keyboardType: TextInputType.number,
                onFieldSubmitted: (updatedAge) {
                  personDao.update(
                    PersonSembast(
                      id: sembastPersonList[i].id,
                      name: sembastPersonList[i].name,
                      age: int.parse(updatedAge),
                      role: sembastPersonList[i].role,
                    ),
                  );
                },
              ),
            ),
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: localizations.dbRole),
                initialValue: '${sembastPersonList[i].role}',
                keyboardType: TextInputType.text,
                onFieldSubmitted: (updatedRole) {
                  personDao.update(
                    PersonSembast(
                      id: sembastPersonList[i].id,
                      name: sembastPersonList[i].name,
                      age: sembastPersonList[i].age,
                      role: updatedRole,
                    ),
                  );
                },
              ),
            ),
            DataCell(
              Icon(
                Icons.delete,
                size: 18.0,
              ),
              onTap: () {
                personDao.delete(sembastPersonList[i]);
              },
            ),
          ],
        ),
      );
    }
  }

  void addDataObjectboxDB(
      PersonDaoObjectboxDB personDao, AppLocalizations localizations) async {
    objectboxPersonList = await personDao.getAll();
    objectboxDataRow.clear();
    for (int i = 0; i < personDao.getPersonsCount; i++) {
      objectboxDataRow.add(
        DataRow(
          selected: false,
          key: Key(objectboxPersonList[i].id.toString()),
          cells: <DataCell>[
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: localizations.dbName),
                initialValue: '${objectboxPersonList[i].name}',
                keyboardType: TextInputType.name,
                onFieldSubmitted: (updatedName) {
                  personDao.update(
                    PersonObjectbox(
                      id: objectboxPersonList[i].id,
                      name: updatedName,
                      age: objectboxPersonList[i].age,
                      role: objectboxPersonList[i].role,
                    ),
                  );
                },
              ),
            ),
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: localizations.dbAge),
                initialValue: '${objectboxPersonList[i].age}',
                keyboardType: TextInputType.number,
                onFieldSubmitted: (updatedAge) {
                  personDao.update(
                    PersonObjectbox(
                      id: objectboxPersonList[i].id,
                      name: objectboxPersonList[i].name,
                      age: int.parse(updatedAge),
                      role: objectboxPersonList[i].role,
                    ),
                  );
                },
              ),
            ),
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: localizations.dbRole),
                initialValue: '${objectboxPersonList[i].role}',
                keyboardType: TextInputType.text,
                onFieldSubmitted: (updatedRole) {
                  personDao.update(
                    PersonObjectbox(
                      id: objectboxPersonList[i].id,
                      name: objectboxPersonList[i].name,
                      age: objectboxPersonList[i].age,
                      role: updatedRole,
                    ),
                  );
                },
              ),
            ),
            DataCell(
              Icon(
                Icons.delete,
                size: 18.0,
              ),
              onTap: () {
                personDao.delete(objectboxPersonList[i]);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: databaseTabs.length);
    _tabController.addListener(_setActiveTabIndex);
    _setActiveTabIndex();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget onSelectedWindow(int index, AppLocalizations localizations) {
    Widget indexedWidget;
    switch (index) {
      case 0:
        indexedWidget = SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    localizations.dbName,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    localizations.dbAge,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    localizations.dbRole,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(''),
                ),
              ],
              rows: sembastDataRow,
            ),
          ),
        );
        break;
      case 1:
        indexedWidget = SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    localizations.dbName,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    localizations.dbAge,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    localizations.dbRole,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(''),
                ),
              ],
              rows: objectboxDataRow,
            ),
          ),
        );
        break;
    }
    return indexedWidget;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'database_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Database');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    _personDaoSembastDB = Provider.of<PersonDaoSembastDB>(context);
    addDataSembastDB(_personDaoSembastDB, localizations);
    _personDaoObjectboxDB = Provider.of<PersonDaoObjectboxDB>(context);
    addDataObjectboxDB(_personDaoObjectboxDB, localizations);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey.shade50,
          isScrollable: true,
          tabs: databaseTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          onSelectedWindow(0, localizations),
          onSelectedWindow(1, localizations),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: fabOnPressed),
    );
  }
}
