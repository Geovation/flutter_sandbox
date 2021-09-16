import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'indicator.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key key}) : super(key: key);

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  int simplePieChartTouchedIndex = -1;

  LineChartData simpleLineChart(Orientation orientation, Size deviceSize) {
    final lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      colors: [
        Colors.tealAccent,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        Colors.purpleAccent,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        Colors.blueGrey.shade700,
      ]),
    );
    final lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Colors.lightBlueAccent,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    List<LineChartBarData> chartLines = [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3
    ];

    return LineChartData(
      lineBarsData: chartLines,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: (orientation == Orientation.landscape)
              ? deviceSize.height * 0.01
              : deviceSize.height * 0.02,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '1Q';
              case 7:
                return '2Q';
              case 12:
                return '3Q';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.brown,
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
    );
  }

  Widget simpleLineChartWidget(Size deviceSize, Orientation orientation) {
    return Container(
      width: deviceSize.width * 0.5,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'Line Chart',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize:
                            (orientation == Orientation.landscape) ? 22 : 32,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.02,
          ),
          SizedBox(
            width: (orientation == Orientation.landscape)
                ? deviceSize.width * 0.5
                : deviceSize.width * 0.9,
            height: (orientation == Orientation.landscape)
                ? deviceSize.height * 0.45
                : deviceSize.height * 0.3,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(simpleLineChart(orientation, deviceSize)),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> simplePieChartSectionData() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == simplePieChartTouchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: const Color(0xff13d38e).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }

  Widget simplePieChartWidget(Size deviceSize, Orientation orientation) {
    return Container(
      width: deviceSize.width * 0.5,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 12,
              ),
              child: Text(
                'Pie Chart',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize:
                            (orientation == Orientation.landscape) ? 22 : 32,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Indicator(
                color: const Color(0xff0293ee),
                text: 'One',
                isSquare: false,
                size: simplePieChartTouchedIndex == 0 ? 18 : 16,
                textColor: simplePieChartTouchedIndex == 0
                    ? Colors.black
                    : Colors.grey,
              ),
              Indicator(
                color: const Color(0xfff8b250),
                text: 'Two',
                isSquare: false,
                size: simplePieChartTouchedIndex == 1 ? 18 : 16,
                textColor: simplePieChartTouchedIndex == 1
                    ? Colors.black
                    : Colors.grey,
              ),
              Indicator(
                color: const Color(0xff845bef),
                text: 'Three',
                isSquare: false,
                size: simplePieChartTouchedIndex == 2 ? 18 : 16,
                textColor: simplePieChartTouchedIndex == 2
                    ? Colors.black
                    : Colors.grey,
              ),
              Indicator(
                color: const Color(0xff13d38e),
                text: 'Four',
                isSquare: false,
                size: simplePieChartTouchedIndex == 3 ? 18 : 16,
                textColor: simplePieChartTouchedIndex == 3
                    ? Colors.black
                    : Colors.grey,
              ),
            ],
          ),
          SizedBox(
            width: (orientation == Orientation.landscape)
                ? deviceSize.width * 0.5
                : deviceSize.width * 0.9,
            height: (orientation == Orientation.landscape)
                ? deviceSize.height * 0.50
                : deviceSize.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch =
                            pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                        if (desiredTouch &&
                            pieTouchResponse.touchedSection != null) {
                          simplePieChartTouchedIndex = pieTouchResponse
                              .touchedSection.touchedSectionIndex;
                        } else {
                          simplePieChartTouchedIndex = -1;
                        }
                      });
                    }),
                    startDegreeOffset: 180,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 1,
                    centerSpaceRadius: 0,
                    sections: simplePieChartSectionData()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget simpleBarChartWidget(Size deviceSize, Orientation orientation) {
    List<BarChartGroupData> showingBarGroups;

    BarChartGroupData makeGroupData(int x, double y1, double y2) {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        BarChartRodData(
          y: y1,
          colors: [Colors.teal.shade600, Colors.greenAccent.shade400],
          width: 6,
        ),
        BarChartRodData(
          y: y2,
          colors: [Colors.orange.shade600, Colors.pinkAccent.shade400],
          width: 7,
        ),
      ]);
    }

    final barGroup1 = makeGroupData(0, 7, 12);
    final barGroup2 = makeGroupData(1, 8, 10);
    final barGroup3 = makeGroupData(2, 8, 4);
    final barGroup4 = makeGroupData(3, 16, 13);
    final barGroup5 = makeGroupData(4, 10, 0);
    final barGroup6 = makeGroupData(5, 5, 3.5);
    final barGroup7 = makeGroupData(6, 21, 4.5);

    showingBarGroups = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    return Container(
      width: deviceSize.width * 0.5,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'Bar Chart',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize:
                            (orientation == Orientation.landscape) ? 22 : 32,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          SizedBox(
            width: (orientation == Orientation.landscape)
                ? deviceSize.width * 0.5
                : deviceSize.width * 0.9,
            height: (orientation == Orientation.landscape)
                ? deviceSize.height * 0.45
                : deviceSize.height * 0.3,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    maxY: 20,
                    barTouchData: BarTouchData(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 20,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'Mon';
                            case 1:
                              return 'Tue';
                            case 2:
                              return 'Wed';
                            case 3:
                              return 'Thu';
                            case 4:
                              return 'Fri';
                            case 5:
                              return 'Sat';
                            case 6:
                              return 'Sun';
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 32,
                        reservedSize: 14,
                        getTitles: (value) {
                          if (value == 0) {
                            return '1K';
                          } else if (value == 10) {
                            return '5K';
                          } else if (value == 19) {
                            return '10K';
                          } else {
                            return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget simpleRadarChartWidget(Size deviceSize, Orientation orientation) {
    List<RadarDataSet> radarData = [
      RadarDataSet(
        fillColor: Colors.red.shade400.withOpacity(0.25),
        borderColor: Colors.red.shade400.withOpacity(0.3),
        entryRadius: 2,
        dataEntries: [
          RadarEntry(value: 300),
          RadarEntry(value: 50),
          RadarEntry(value: 200),
        ],
        borderWidth: 2,
      ),
      RadarDataSet(
        fillColor: Colors.blue.shade400.withOpacity(0.4),
        borderColor: Colors.blue.shade400.withOpacity(0.45),
        entryRadius: 2,
        dataEntries: [
          RadarEntry(value: 150),
          RadarEntry(value: 100),
          RadarEntry(value: 280),
        ],
        borderWidth: 2,
      )
    ];
    return Container(
      width: deviceSize.width * 0.5,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'Radar Chart',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize:
                            (orientation == Orientation.landscape) ? 22 : 32,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          SizedBox(
            width: (orientation == Orientation.landscape)
                ? deviceSize.width * 0.5
                : deviceSize.width * 0.9,
            height: (orientation == Orientation.landscape)
                ? deviceSize.height * 0.45
                : deviceSize.height * 0.3,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RadarChart(
                  RadarChartData(
                    dataSets: radarData,
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData:
                        const BorderSide(color: Colors.transparent),
                    gridBorderData:
                        const BorderSide(color: Colors.grey, width: 2),
                    titlePositionPercentageOffset: 0.2,
                    titleTextStyle: const TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 14),
                    getTitle: (index) {
                      switch (index) {
                        case 0:
                          return 'Angel Investor';
                        case 1:
                          return 'VC';
                        case 2:
                          return 'Accelerator';
                        default:
                          return '';
                      }
                    },
                    tickCount: 1,
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    ticksTextStyle: const TextStyle(
                        color: Colors.transparent, fontSize: 10),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<int> selectedSpots = [];

  Widget simpleScatterPlotWidget(Size deviceSize, Orientation orientation) {
    List<ScatterSpot> scatterChartData = [
      ScatterSpot(
        5,
        4,
        color: selectedSpots.contains(0) ? Colors.green : Colors.grey,
      ),
      ScatterSpot(
        6,
        5,
        color: selectedSpots.contains(1) ? Colors.yellow : Colors.grey,
        radius: 10,
      ),
      ScatterSpot(
        8,
        5,
        color: selectedSpots.contains(2) ? Colors.purpleAccent : Colors.grey,
        radius: 8,
      ),
      ScatterSpot(
        8,
        7,
        color: selectedSpots.contains(3) ? Colors.orange : Colors.grey,
        radius: 20,
      ),
      ScatterSpot(
        5,
        6,
        color: selectedSpots.contains(4) ? Colors.brown : Colors.grey,
        radius: 10,
      ),
      ScatterSpot(
        7,
        1,
        color:
            selectedSpots.contains(5) ? Colors.lightGreenAccent : Colors.grey,
        radius: 18,
      ),
      ScatterSpot(
        3,
        2,
        color: selectedSpots.contains(6) ? Colors.red : Colors.grey,
        radius: 36,
      ),
      ScatterSpot(
        2,
        8,
        color: selectedSpots.contains(7) ? Colors.tealAccent : Colors.grey,
        radius: 22,
      ),
    ];
    return Container(
      width: deviceSize.width * 0.5,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'Scatter Plot',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize:
                            (orientation == Orientation.landscape) ? 22 : 32,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          SizedBox(
            width: (orientation == Orientation.landscape)
                ? deviceSize.width * 0.5
                : deviceSize.width * 0.9,
            height: (orientation == Orientation.landscape)
                ? deviceSize.height * 0.6
                : deviceSize.height * 0.35,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ScatterChart(
                  ScatterChartData(
                    backgroundColor: Colors.blueGrey.shade800,
                    scatterSpots: scatterChartData,
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 10,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      show: false,
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      checkToShowHorizontalLine: (value) => true,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.white.withOpacity(0.1)),
                      drawVerticalLine: true,
                      checkToShowVerticalLine: (value) => true,
                      getDrawingVerticalLine: (value) =>
                          FlLine(color: Colors.white.withOpacity(0.1)),
                    ),
                    showingTooltipIndicators: selectedSpots,
                    scatterTouchData: ScatterTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchTooltipData: ScatterTouchTooltipData(
                        tooltipBgColor: Colors.black,
                        getTooltipItems: (ScatterSpot touchedBarSpot) {
                          return ScatterTooltipItem(
                            'X: ',
                            TextStyle(
                              height: 1.2,
                              color: Colors.grey[100],
                              fontStyle: FontStyle.italic,
                            ),
                            10,
                            children: [
                              TextSpan(
                                  text: '${touchedBarSpot.x.toInt()} \n',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              TextSpan(
                                text: 'Y: ',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  height: 1.2,
                                  color: Colors.grey[100],
                                  fontStyle: FontStyle.italic,
                                )),
                              ),
                              TextSpan(
                                text: touchedBarSpot.y.toInt().toString(),
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                            ],
                          );
                        },
                      ),
                      touchCallback: (ScatterTouchResponse touchResponse) {
                        if (touchResponse.clickHappened &&
                            touchResponse.touchedSpot != null) {
                          final sectionIndex =
                              touchResponse.touchedSpot.spotIndex;
                          // Tap happened
                          setState(() {
                            if (selectedSpots.contains(sectionIndex)) {
                              selectedSpots.remove(sectionIndex);
                            } else {
                              selectedSpots.add(sectionIndex);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'charts_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex('Charts');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    Size deviceSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          (deviceSize.width * 0.05), 20, (deviceSize.width * 0.05), 20),
      child: ListView(
        children: [
          simpleLineChartWidget(deviceSize, orientation),
          simplePieChartWidget(deviceSize, orientation),
          simpleBarChartWidget(deviceSize, orientation),
          simpleRadarChartWidget(deviceSize, orientation),
          simpleScatterPlotWidget(deviceSize, orientation),
        ],
      ),
    );
  }
}
