import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/constants.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
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
  final List<Item> _data = generateItems(8);
  bool isFABVisible = true;
  TabController _tabController;
  final List<Tab> basicWidgetTabs = <Tab>[
    Tab(text: 'Slider'),
    Tab(text: 'Date picker'),
    Tab(text: 'Checkbox'),
    Tab(text: 'Expansion List'),
  ];

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

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
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _tabController = TabController(vsync: this, length: basicWidgetTabs.length);
    _tabController.addListener(_setActiveTabIndex);
    super.initState();
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

  Widget onSelectedWindow(int index) {
    Widget indexedWidget;
    switch (index) {
      case 0:
        indexedWidget = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Slider.adaptive(
              activeColor: Theme.of(context).accentColor,
              inactiveColor: kSliderInActiveColor,
              value: currentSliderValueContinuous,
              onChanged: (double value) {
                setState(() {
                  currentSliderValueContinuous = value;
                });
              },
            ),
            Text(currentSliderValueContinuous.toStringAsFixed(1)),
            SizedBox(
              height: 3,
            ),
            Slider.adaptive(
              activeColor: Theme.of(context).accentColor,
              inactiveColor: kSliderInActiveColor,
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
            Text(currentSliderValueDiscrete.round().toString()),
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
                    'Choose Date',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
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
                      decoration: BoxDecoration(color: Colors.grey[200]),
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
                    'Choose Time',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
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
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: TextFormField(
                        style: TextStyle(fontSize: 40),
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
          child: ListView(
            children: [
              CheckboxListTile(
                activeColor: kPrimary,
                title: Text('Wake up'),
                value: checkBoxValues[0],
                onChanged: (bool value) {
                  setState(() {
                    checkBoxValues[0] = value;
                  });
                },
                secondary: Icon(Icons.alarm),
              ),
              CheckboxListTile(
                activeColor: kPrimary,
                title: Text('Put on the suit'),
                value: checkBoxValues[1],
                onChanged: (bool value) {
                  setState(() {
                    checkBoxValues[1] = value;
                  });
                },
                secondary: Icon(Icons.work),
              ),
              CheckboxListTile(
                activeColor: kPrimary,
                title: Text('Be the Hero'),
                value: checkBoxValues[2],
                onChanged: (bool value) {
                  setState(() {
                    checkBoxValues[2] = value;
                  });
                },
                secondary: Icon(Icons.engineering),
              ),
            ],
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
                    title: Text(item.headerValue),
                  );
                },
                body: ListTile(
                    title: Text(item.expandedValue),
                    subtitle: const Text(
                        'To delete this panel, tap the trash can icon'),
                    trailing: const Icon(Icons.delete),
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
        print('default');
        break;
    }
    return indexedWidget;
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Basic Widgets');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

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
          onSelectedWindow(0),
          onSelectedWindow(1),
          onSelectedWindow(2),
          onSelectedWindow(3),
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

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
