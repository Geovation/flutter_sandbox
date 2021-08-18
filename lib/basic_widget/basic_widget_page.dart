import 'package:date_format/date_format.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BasicWidgetsPage extends StatefulWidget {
  static const id = 'basic_widget_page';
  @override
  _BasicWidgetsPageState createState() => _BasicWidgetsPageState();
}

class _BasicWidgetsPageState extends State<BasicWidgetsPage>
    with SingleTickerProviderStateMixin {
  double currentSliderValueContinuous = 0;
  double currentSliderValueDiscrete = 0;
  double _height;
  double _width;
  List checkBoxValues = [false, false, false];
  bool isFABVisible = true;
  TabController _tabController;
  List<Item> _data = [
    Item(
      headerValue: 'Default value is 1',
      expandedValue: 'Default Index is 1',
    )
  ];

  String _setTime, _setDate;

  String _hour, _minute, _time;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_setActiveTabIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _data = generateItems(8, AppLocalizations.of(context));
    });
  }

  void _setActiveTabIndex() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          isFABVisible = true;
          break;
        case 1:
          isFABVisible = true;
          break;
        case 2:
          isFABVisible = true;
          break;
        case 3:
          isFABVisible = false;
          break;
      }
    });
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
        indexedWidget = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: _width,
              child: Semantics(
                slider: true,
                label: localizations.semBasicWidgetPgContinuousSliderLabel,
                value: currentSliderValueContinuous.toString(),
                child: Slider.adaptive(
                  key: Key('continuous_slider'),
                  activeColor: Theme.of(context).accentColor,
                  inactiveColor: Colors.red.shade100,
                  value: currentSliderValueContinuous,
                  onChanged: (double value) {
                    setState(() {
                      currentSliderValueContinuous = value;
                    });
                  },
                ),
              ),
            ),
            Text(
              currentSliderValueContinuous.toStringAsFixed(1),
              semanticsLabel:
                  '${localizations.semBasicWidgetPgContinuousSlider} ${currentSliderValueContinuous.toStringAsFixed(1)}',
              style: GoogleFonts.lato(),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              width: _width,
              child: Semantics(
                slider: true,
                label: localizations.semBasicWidgetPgDiscreteSliderLabel,
                value: currentSliderValueDiscrete.toString(),
                child: Slider.adaptive(
                  key: Key('discrete_slider'),
                  activeColor: Theme.of(context).accentColor,
                  inactiveColor: Colors.red.shade100,
                  value: currentSliderValueDiscrete,
                  min: 0,
                  max: 100,
                  divisions: 5,
                  label: currentSliderValueDiscrete.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      currentSliderValueDiscrete = value;
                    });
                  },
                ),
              ),
            ),
            Text(currentSliderValueDiscrete.round().toString(),
                style: GoogleFonts.lato(),
                semanticsLabel:
                    '${localizations.semBasicWidgetPgDiscreteSlider} ${currentSliderValueDiscrete.round().toString()}'),
          ],
        );
        break;
      case 1:
        indexedWidget = Container(
          width: _width,
          height: _height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    localizations.basicWidgetsChooseDate,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      width: _width / 1.7,
                      height: _height / 9,
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor),
                      child: TextFormField(
                        style: TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _dateController,
                        onSaved: (String val) {
                          _setDate = val;
                        },
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            // labelText: 'Time',
                            contentPadding: EdgeInsets.only(top: 0.0)),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    localizations.basicWidgetsChooseTime,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5)),
                  ),
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      width: _width / 1.7,
                      height: _height / 9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 40)),
                        textAlign: TextAlign.center,
                        onSaved: (String val) {
                          _setTime = val;
                        },
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _timeController,
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            // labelText: 'Time',
                            contentPadding: EdgeInsets.all(5)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        break;

      case 2:
        indexedWidget = Center(
          child: Container(
            width: _width,
            child: ListView(
              children: [
                Semantics(
                  checked: true,
                  label: localizations.basicWidgetsWakeUp,
                  value: checkBoxValues[0].toString(),
                  child: CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(
                      localizations.basicWidgetsWakeUp,
                      style: GoogleFonts.lato(),
                    ),
                    value: checkBoxValues[0],
                    onChanged: (bool value) {
                      setState(() {
                        checkBoxValues[0] = value;
                      });
                    },
                    secondary: ExcludeSemantics(
                      excluding: true,
                      child: Icon(
                        Icons.alarm,
                      ),
                    ),
                  ),
                ),
                Semantics(
                  checked: true,
                  label: localizations.basicWidgetsPutOnTheSuit,
                  value: checkBoxValues[1].toString(),
                  child: CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(localizations.basicWidgetsPutOnTheSuit,
                        style: GoogleFonts.lato()),
                    value: checkBoxValues[1],
                    onChanged: (bool value) {
                      setState(() {
                        checkBoxValues[1] = value;
                      });
                    },
                    secondary: ExcludeSemantics(
                        excluding: true, child: Icon(Icons.work)),
                  ),
                ),
                Semantics(
                  checked: true,
                  label: localizations.basicWidgetsBetheHero,
                  value: checkBoxValues[2].toString(),
                  child: CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(
                      localizations.basicWidgetsBetheHero,
                      style: GoogleFonts.lato(),
                    ),
                    value: checkBoxValues[2],
                    onChanged: (bool value) {
                      setState(() {
                        checkBoxValues[2] = value;
                      });
                    },
                    secondary: ExcludeSemantics(
                        excluding: true, child: Icon(Icons.engineering)),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 3:
        indexedWidget = SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _data[index].isExpanded = !isExpanded;
              });
            },
            children: _data.map<ExpansionPanel>((Item item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(
                      item.headerValue,
                      style: GoogleFonts.lato(),
                    ),
                  );
                },
                body: ListTile(
                    title: Text(
                      item.expandedValue,
                      style: GoogleFonts.lato(),
                    ),
                    subtitle: Text(
                      localizations.basicWidgetsExpansionPanelText,
                      style: GoogleFonts.lato(),
                    ),
                    trailing: Icon(
                      Icons.delete,
                      semanticLabel:
                          '${localizations.semBasicWidgetPgTrashButton}',
                    ),
                    onTap: () {
                      setState(() {
                        _data.removeWhere(
                            (Item currentItem) => item == currentItem);
                      });
                    }),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        );
        break;

      default:
        indexedWidget = Center(
          child: Text(
            localizations.basicWidgetsExpansionPanelDefaultText,
            style: GoogleFonts.lato(),
          ),
        );
        break;
    }
    return indexedWidget;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'basic_widget_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Basic Widgets');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    MediaQueryData deviceData = MediaQuery.of(context);

    final List<Tab> basicWidgetTabs = <Tab>[
      Tab(text: localizations.basicWidgetsSliderTitle),
      Tab(text: localizations.basicWidgetsDatePickerTitle),
      Tab(text: localizations.basicWidgetsCheckboxTitle),
      Tab(text: localizations.basicWidgetsExpansionListTitle),
    ];

    _height = deviceData.size.height;
    _width = (deviceData.orientation == Orientation.portrait)
        ? deviceData.size.width
        : deviceData.size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey.shade50,
          isScrollable: true,
          tabs: basicWidgetTabs,
          labelStyle: GoogleFonts.lato(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          onSelectedWindow(0, localizations),
          onSelectedWindow(1, localizations),
          onSelectedWindow(2, localizations),
          onSelectedWindow(3, localizations),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isFABVisible,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print('FAB pressed');
          },
        ),
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    @required this.expandedValue,
    @required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems, AppLocalizations localizations) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: '${localizations.basicWidgetsPanel} $index',
      expandedValue: '${localizations.basicWidgetsThisIsItemNumber} $index',
    );
  });
}
