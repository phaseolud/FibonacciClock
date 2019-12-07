// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'fibonacci_blocks.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
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
  void didUpdateWidget(DigitalClock oldWidget) {
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
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      print('updated1');
      // Update once per minute. If you want to update every second, use the
      // following code.
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
    return Container(
      child: Center(
        child: Text(_dateTime.toString()),
      ),
      // color: colors[_Element.background],
      // child: Center(
      //   child: DefaultTextStyle(
      //     style: defaultStyle,
      //     child: Stack(
      //       children: <Widget>[
      //         Positioned(left: offset, top: offset, child: Text(hour)),
      //         Positioned(right: offset, bottom: offset, child: Text(minute)),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
