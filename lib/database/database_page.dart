import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/database/sembast/model/person_sembast.dart';
import 'package:flutter_sandbox/database/sembast/person_dao_sembast.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import 'moor/moor_database.dart';

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
    Tab(text: 'Sqlite (Moor)'),
  ];

  List<DataRow> sembastDataRow = [];
  List<PersonSembast> sembastPersonList = [];
  List<DataRow> moorDataRow = [];
  List<PersonsMoorData> moorPersonList = [];

  PersonDaoSembast _personDaoSembast;
  PersonDaoMoor _personDaoMoor;

  Function fabOnPressed = () {};

  void _setActiveTabIndex() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          fabOnPressed = () {
            addPersonSembastDB(_personDaoSembast);
          };
          break;
        case 1:
          fabOnPressed = () {
            if (!kIsWeb) {
              addPersonMoorDB(_personDaoMoor);
            }
          };
          break;
      }
    });
  }

  void addPersonSembastDB(PersonDaoSembast personDaoSembast) {
    PersonSembast insertPerson = PersonSembast(name: '', age: 0, role: '');
    personDaoSembast.insert(insertPerson);
  }

  void addPersonMoorDB(PersonDaoMoor personDaoMoor) {
    PersonsMoorCompanion insertPerson =
        PersonsMoorCompanion(name: Value(''), age: Value(0), role: Value(''));
    personDaoMoor.insertPerson(insertPerson);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: databaseTabs.length);
    _tabController.addListener(_setActiveTabIndex);
    _setActiveTabIndex();
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
            child: StreamBuilder(
              stream: _personDaoSembast.watch().asBroadcastStream(),
              builder: (context, AsyncSnapshot<List<PersonSembast>> snapshot) {
                final persons = snapshot.data ?? [];
                return DataTable(
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        localizations.dbName,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        localizations.dbAge,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        localizations.dbRole,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '',
                        style: GoogleFonts.lato(),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    persons.length,
                    (index) => DataRow(
                      selected: false,
                      key: Key(persons[index].id.toString()),
                      cells: <DataCell>[
                        DataCell(
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: localizations.dbName),
                            initialValue: '${persons[index].name}',
                            keyboardType: TextInputType.name,
                            onFieldSubmitted: (updatedName) {
                              _personDaoSembast.update(
                                PersonSembast(
                                  id: persons[index].id,
                                  name: updatedName,
                                  age: persons[index].age,
                                  role: persons[index].role,
                                ),
                              );
                            },
                          ),
                        ),
                        DataCell(
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: localizations.dbAge),
                            initialValue: '${persons[index].age}',
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (updatedAge) {
                              _personDaoSembast.update(
                                PersonSembast(
                                  id: persons[index].id,
                                  name: persons[index].name,
                                  age: int.parse(updatedAge),
                                  role: persons[index].role,
                                ),
                              );
                            },
                          ),
                        ),
                        DataCell(
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: localizations.dbRole),
                            initialValue: '${persons[index].role}',
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (updatedRole) {
                              _personDaoSembast.update(
                                PersonSembast(
                                  id: persons[index].id,
                                  name: persons[index].name,
                                  age: persons[index].age,
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
                            _personDaoSembast.delete(persons[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
        break;
      case 1:
        indexedWidget = (kIsWeb)
            ? Center(
                child: Text(
                  'Not yet supported on this platform',
                  style: GoogleFonts.lato(),
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: _personDaoMoor.watchAllPersons(),
                    builder: (context,
                        AsyncSnapshot<List<PersonsMoorData>> snapshot) {
                      final persons = snapshot.data ?? [];
                      return DataTable(
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              localizations.dbName,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              localizations.dbAge,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              localizations.dbRole,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '',
                              style: GoogleFonts.lato(),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          persons.length,
                          (index) => DataRow(
                            selected: false,
                            key: Key(persons[index].id.toString()),
                            cells: <DataCell>[
                              DataCell(
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: localizations.dbName),
                                  initialValue: '${persons[index].name}',
                                  keyboardType: TextInputType.name,
                                  onFieldSubmitted: (updatedName) {
                                    _personDaoMoor.updatePerson(
                                      PersonsMoorCompanion(
                                        id: Value(persons[index].id),
                                        name: Value(updatedName),
                                        age: Value(persons[index].age),
                                        role: Value(persons[index].role),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: localizations.dbAge),
                                  initialValue: '${persons[index].age}',
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (updatedAge) {
                                    _personDaoMoor.updatePerson(
                                      PersonsMoorCompanion(
                                        id: Value(persons[index].id),
                                        name: Value(persons[index].name),
                                        age: Value(int.parse(updatedAge)),
                                        role: Value(persons[index].role),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: localizations.dbRole),
                                  initialValue: '${persons[index].role}',
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (updatedRole) {
                                    _personDaoMoor.updatePerson(
                                      PersonsMoorCompanion(
                                        id: Value(persons[index].id),
                                        name: Value(persons[index].name),
                                        age: Value(persons[index].age),
                                        role: Value(updatedRole),
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
                                  _personDaoMoor.deletePerson(persons[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

    _personDaoSembast = Provider.of<PersonDaoSembast>(context);

    if (!kIsWeb) {
      _personDaoMoor = Provider.of<PersonDaoMoor>(context);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey.shade50,
          isScrollable: true,
          tabs: databaseTabs,
          labelStyle: GoogleFonts.lato(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          onSelectedWindow(0, localizations),
          onSelectedWindow(1, localizations),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: fabOnPressed,
      ),
    );
  }
}
