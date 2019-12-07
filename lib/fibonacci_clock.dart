import 'dart:async';
import 'dart:math';

import 'package:digital_clock/fibonacci_blocks.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

enum _BlockColors {
  noColor,
  hourColor,
  minuteColor,
  combinedColor,
}

final _basictheme = {
  _BlockColors.noColor: Colors.white,
  _BlockColors.hourColor: Colors.red[400],
  _BlockColors.minuteColor: Colors.green[400],
  _BlockColors.combinedColor: Colors.blue[400],
};
Map<String, Color> circleColors = {
  'nocolor': Colors.transparent,
  'black': Colors.black,
  'white': Colors.white
};

const List<int> fibList = [1, 1, 2, 3, 5];

class FibonacciClock extends StatefulWidget {
  const FibonacciClock(this.model);
  final ClockModel model;

  @override
  _FibonacciClockState createState() => _FibonacciClockState();
}

class _FibonacciClockState extends State<FibonacciClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(FibonacciClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      print('updated1');
// update every minute
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // added a scaling factor of 1.008 else it would not be fully on the screen :(
    final width = MediaQuery.of(context).size.width / 1.008;
    final double minWidth = width / 8;
    // aspect ratio of 5/3
    final double minHeight = width * (3.0 / 5) / 5.0;
    const List<int> fibList = [1, 1, 2, 3, 5];
    // determine positions of the blocks
    final List<Offset> positions = [
      Offset(2.5 * minWidth, 0.5 * minHeight),
      Offset(2.5 * minWidth, 1.5 * minHeight),
      Offset(minWidth, minHeight),
      Offset(1.5 * minWidth, 3.5 * minHeight),
      Offset(5.5 * minWidth, 2.5 * minHeight)
    ];

    // place minute indicator in topleft corner
    final List<Offset> minutePositions = new List(5);
    for (var i = 0; i < positions.length; i++) {
      // determine left corner
      Offset leftCorner = Offset(positions[i].dx - minWidth * fibList[i] / 2,
          positions[i].dy - minHeight * fibList[i] / 2);
      minutePositions[i] = leftCorner + Offset(10, 10);
    }
    final List<Color> color = timeToColor(_dateTime);
    // enable minutecircles
    const bool drawMinuteCircle = true;
    final List<Color> minuteColor = minuteToColor(_dateTime, color);

    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            // fibonacci blocks
            for (var i = 0; i < fibList.length; i++)
              FibonacciBlock(
                color: color[i],
                position: positions[i],
                width: minWidth * fibList[i],
                height: minHeight * fibList[i],
              ),
            // minute circles

            if (drawMinuteCircle)
              for (var i = 0; i < fibList.length; i++)
                if (minuteColor[i] != circleColors['nocolor'])
                  MinuteCircle(
                      color: minuteColor[i], position: minutePositions[i]),

            // block lines
            for (var i = 0; i < fibList.length; i++)
              FibonacciLines(
                position: positions[i],
                width: minWidth * fibList[i],
                height: minHeight * fibList[i],
              )
          ],
        ),
      ),
      // child: FibonacciBlocks(),
    );
  }

  List<Color> minuteToColor(DateTime time, List<Color> blockColors) {
    List<bool> black = blockColors
        .map((value) => _basictheme[_BlockColors.noColor] == value)
        .toList();
    // the 5 block is never needed as then the block colours will update.
    // transparent just to check if it should render, black dots if white block and white dots if coloured blocks
    List<Color> colors = new List.filled(5, circleColors['nocolor']);
    final int minutes = time.minute % 5;
    List<List<int>> possibleCombinations = [];
    subsetSum(fibList, minutes, possibleCombinations, []);
    final Random rnd = new Random();

    List<int> minuteColor =
        possibleCombinations[rnd.nextInt(possibleCombinations.length)];
    for (var i = 0; i < fibList.length; i++) {
      if (minuteColor.contains(fibList[i])) {
        colors[i] = black[i] ? circleColors['black'] : circleColors['white'];
        minuteColor.remove(fibList[i]);
      }
    }
    return colors;
  }

  List<Color> timeToColor(DateTime time) {
    List<Color> colors = new List(5);

    final int hourTarget = ((time.hour - 1) % 12) + 1;
    final int minuteTarget = time.minute ~/ 5;

    List<List<int>> possibleCombinationsHours = [];
    List<List<int>> possibleCombinationsMinutes = [];

    subsetSum(fibList, hourTarget, possibleCombinationsHours, []);
    subsetSum(fibList, minuteTarget, possibleCombinationsMinutes, []);

    final Random rnd = new Random();

    // okay the idea is here to make the clock not always show the same, but at some randomness
    // however some will count double as the 1 is double in the fibonacci list.
    List<int> hourColor = possibleCombinationsHours[
        rnd.nextInt(possibleCombinationsHours.length)];
    List<int> minuteColor = possibleCombinationsMinutes[
        rnd.nextInt(possibleCombinationsMinutes.length)];
    List<int> colorList = new List.filled(5, 0);
    // map the minutes to two, and the hours to 1
    for (var i = 0; i < fibList.length; i++) {
      if (hourColor.contains(fibList[i])) {
        colorList[i] += 1;
        hourColor.remove(fibList[i]);
      }

      if (minuteColor.contains(fibList[i])) {
        colorList[i] += 2;
        minuteColor.remove(fibList[i]);
      }
    }
    colors = colorList
        .map((value) => _basictheme[_BlockColors.values[value]])
        .toList();
    return colors;
  }

// straight from stackoverflow source: https://stackoverflow.com/questions/4632322/finding-all-possible-combinations-of-numbers-to-reach-a-given-sum
  void subsetSum(List<int> numbers, int target, List<List<int>> combinations,
      List<int> partial) {
    int sum = partial.isNotEmpty ? partial.reduce((a, b) => a + b) : 0;

    if (sum == target) {
      combinations.add(partial);
    }
    if (sum >= target) {
      return;
    }
    int n;
    List<int> remaining;
    for (var i = 0; i < numbers.length; i++) {
      n = numbers[i];
      remaining = numbers.sublist(i + 1);
      subsetSum(remaining, target, combinations, partial + [n]);
    }
  }
}
