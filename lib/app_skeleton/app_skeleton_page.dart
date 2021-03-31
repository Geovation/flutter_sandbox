import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppSkeletonPage extends StatefulWidget {
  static const id = 'app_skeleton_page';
  @override
  _AppSkeletonPageState createState() => _AppSkeletonPageState();
}

class _AppSkeletonPageState extends State<AppSkeletonPage> {
  int _selectedIndex = 0;
  double currentSliderValueContinuous = 0;
  double currentSliderValueDiscrete = 0;
  double _height;
  double _width;
  List checkBoxValues = [false, false, false];
  final List<Item> _data = generateItems(8);
  bool isFABVisible = true;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  Widget onSelectedWindow(int index) {
    Widget indexedWidget;
    switch (index) {
      case 0:
        indexedWidget = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Slider.adaptive(
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
        setState(() {
          isFABVisible = true;
        });
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
        setState(() {
          isFABVisible = true;
        });
        break;

      case 2:
        indexedWidget = Center(
          child: ListView(
            children: [
              CheckboxListTile(
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
        setState(() {
          isFABVisible = true;
        });
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
        setState(() {
          isFABVisible = false;
        });
        break;

      default:
        print('default');
        break;
    }
    return indexedWidget;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('App Skeleton'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Drawer Header',
                style: TextStyle(fontSize: 30),
              ),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
      body: Center(
        child: onSelectedWindow(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.remove),
            label: 'Slider',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: 'Date/Time Picker',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Checkbox',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.expand),
            label: 'Expansion Panel',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
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
