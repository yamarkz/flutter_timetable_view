# Flutter Timetable View

Timetable Widget Package for Flutter

# Features

## Image

<img src="art/app_image_1.png" width="200" />

## Video Recording

<img src="art/video_1.gif" height="440" />  <img src="art/video_2.gif" height="440" />

# Install

https://pub.dev/packages/flutter_timetable_view#install

# Usage

## Basic

```
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TimetableView(
        laneEventsList: [
          LaneEvents(
            lane: Lane(
              name: 'Track A',
            ),
            events: [
              TableEvent(
                title: 'An event 1',
                description: 'An event 1',
                start: TableEventTime(hour: 10, minute: 0),
                end: TableEventTime(hour: 11, minute: 20),
              ),
            ]
          ),
        ],
      ),
    );
  }
}
```

## Customized

```
todo
```

# Contributing

1. Fork it
2. Create your feature branch (git checkout -b new_feature_branch)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin new_feature_branch)
5. Create new Pull Request

# License

```
MIT License

Copyright (c) 2020 Kazuki Yamaguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
