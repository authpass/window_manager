import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preference_list/preference_list.dart';
import 'package:window_manager/window_manager.dart';

const _kSizes = [
  Size(400, 400),
  Size(600, 600),
  Size(800, 800),
];

const _kMinSizes = [
  Size(400, 400),
  Size(600, 600),
];

const _kMaxSizes = [
  Size(600, 600),
  Size(800, 800),
];

final windowManager = WindowManager.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  Size _size = _kSizes.first;
  Size? _minSize;
  Size? _maxSize;
  bool _isFullScreen = false;
  bool _isResizable = true;
  bool _isMovable = true;
  bool _isMinimizable = true;
  bool _isClosable = true;
  bool _isAlwaysOnTop = false;
  bool _hasShadow = true;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            windowManager.startDragging();
          },
          onDoubleTap: () async {
            bool isMaximized = await windowManager.isMaximized();
            if (!isMaximized) {
              windowManager.maximize();
            } else {
              windowManager.unmaximize();
            }
          },
          child: Container(
            width: double.infinity,
            height: 54,
            color: Colors.grey.withOpacity(0.3),
            child: Center(
              child: Text('DragToMoveArea'),
            ),
          ),
        ),
        PreferenceListSection(
          children: [
            PreferenceListItem(
              title: Text('focus / blur'),
              onTap: () async {
                windowManager.blur();
                await Future.delayed(Duration(seconds: 2));
                windowManager.focus();
              },
            ),
            PreferenceListItem(
              title: Text('show / hide'),
              onTap: () async {
                windowManager.hide();
                await Future.delayed(Duration(seconds: 2));
                windowManager.show();
              },
            ),
            PreferenceListItem(
              title: Text('isVisible'),
              onTap: () async {
                bool isVisible = await windowManager.isVisible();
                BotToast.showText(
                  text: 'isVisible: $isVisible',
                );

                await Future.delayed(Duration(seconds: 2));
                windowManager.hide();
                isVisible = await windowManager.isVisible();
                print('isVisible: $isVisible');
                await Future.delayed(Duration(seconds: 2));
                windowManager.show();
              },
            ),
            PreferenceListItem(
              title: Text('isMaximized'),
              onTap: () async {
                bool isMaximized = await windowManager.isMaximized();
                BotToast.showText(
                  text: 'isMaximized: $isMaximized',
                );
              },
            ),
            PreferenceListItem(
              title: Text('maximize / unmaximize'),
              onTap: () async {
                windowManager.maximize();
                await Future.delayed(Duration(seconds: 2));
                windowManager.unmaximize();
              },
            ),
            PreferenceListItem(
              title: Text('isMinimized'),
              onTap: () async {
                bool isMinimized = await windowManager.isMinimized();
                BotToast.showText(
                  text: 'isMinimized: $isMinimized',
                );

                await Future.delayed(Duration(seconds: 2));
                windowManager.minimize();
                await Future.delayed(Duration(seconds: 2));
                isMinimized = await windowManager.isMinimized();
                print('isMinimized: $isMinimized');
                windowManager.restore();
              },
            ),
            PreferenceListItem(
              title: Text('minimize / restore'),
              onTap: () async {
                windowManager.minimize();
                await Future.delayed(Duration(seconds: 2));
                windowManager.restore();
              },
            ),
            PreferenceListItem(
              title: Text('isFullScreen / setFullScreen'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _isFullScreen = !_isFullScreen;
                  windowManager.setFullScreen(_isFullScreen);
                  setState(() {});
                },
                isSelected: [_isFullScreen, !_isFullScreen],
              ),
              onTap: () async {
                bool isFullScreen = await windowManager.isFullScreen();
                BotToast.showText(text: 'isFullScreen: $isFullScreen');
              },
            ),
            PreferenceListItem(
              title: Text('setBounds / setBounds'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  for (var size in _kSizes)
                    Text(' ${size.width.toInt()}x${size.height.toInt()} '),
                ],
                onPressed: (int index) async {
                  _size = _kSizes[index];
                  Rect bounds = await windowManager.getBounds();
                  windowManager.setBounds(
                    Rect.fromLTWH(
                      bounds.left,
                      bounds.top,
                      _size.width,
                      _size.height,
                    ),
                  );
                  setState(() {});
                },
                isSelected: _kSizes.map((e) => e == _size).toList(),
              ),
              onTap: () async {
                Rect bounds = await windowManager.getBounds();
                Size size = bounds.size;
                Offset origin = bounds.topLeft;
                BotToast.showText(
                  text: '${size.toString()}\n${origin.toString()}',
                );
              },
            ),
            PreferenceListItem(
              title: Text('getPosition / setPosition'),
              accessoryView: Row(
                children: [
                  CupertinoButton(
                    child: Text('xy>zero'),
                    onPressed: () async {
                      windowManager.setPosition(Offset(0, 0));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('x+20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx + 20, p.dy));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('x-20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx - 20, p.dy));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('y+20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx, p.dy + 20));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('y-20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx, p.dy - 20));
                      setState(() {});
                    },
                  ),
                ],
              ),
              onTap: () async {
                Offset position = await windowManager.getPosition();
                BotToast.showText(
                  text: '${position.toString()}',
                );
              },
            ),
            PreferenceListItem(
              title: Text('getSize / setSize'),
              accessoryView: CupertinoButton(
                child: Text('Set'),
                onPressed: () async {
                  Size size = await windowManager.getSize();
                  windowManager.setSize(
                    Size(size.width + 100, size.height + 100),
                  );
                  setState(() {});
                },
              ),
              onTap: () async {
                Offset position = await windowManager.getPosition();
                BotToast.showText(
                  text: '${position.toString()}',
                );
              },
            ),
            PreferenceListItem(
              title: Text('getMinimumSize / setMinimumSize'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  for (var size in _kMinSizes)
                    Text(' ${size.width.toInt()}x${size.height.toInt()} '),
                ],
                onPressed: (int index) {
                  _minSize = _kMinSizes[index];
                  windowManager.setMinimumSize(_minSize!);
                  setState(() {});
                },
                isSelected: _kMinSizes.map((e) => e == _minSize).toList(),
              ),
            ),
            PreferenceListItem(
              title: Text('getMaximumSize / setMaximumSize'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  for (var size in _kMaxSizes)
                    Text(' ${size.width.toInt()}x${size.height.toInt()} '),
                ],
                onPressed: (int index) {
                  _maxSize = _kMaxSizes[index];
                  windowManager.setMaximumSize(_maxSize!);
                  setState(() {});
                },
                isSelected: _kMaxSizes.map((e) => e == _maxSize).toList(),
              ),
            ),
            PreferenceListItem(
              title: Text('isResizable / setResizable'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _isResizable = !_isResizable;
                  windowManager.setResizable(_isResizable);
                  setState(() {});
                },
                isSelected: [_isResizable, !_isResizable],
              ),
              onTap: () async {
                bool isResizable = await windowManager.isResizable();
                BotToast.showText(text: 'isResizable: $isResizable');
              },
            ),
            PreferenceListItem(
              title: Text('isMovable / setMovable'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _isMovable = !_isMovable;
                  windowManager.setMovable(_isMovable);
                  setState(() {});
                },
                isSelected: [_isMovable, !_isMovable],
              ),
              onTap: () async {
                bool isMovable = await windowManager.isMovable();
                BotToast.showText(text: 'isMovable: $isMovable');
              },
            ),
            PreferenceListItem(
              title: Text('isMinimizable / setMinimizable'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _isMinimizable = !_isMinimizable;
                  windowManager.setMinimizable(_isMinimizable);
                  setState(() {});
                },
                isSelected: [_isMinimizable, !_isMinimizable],
              ),
              onTap: () async {
                bool isClosable = await windowManager.isClosable();
                BotToast.showText(text: 'isMinimizable: $isClosable');
              },
            ),
            PreferenceListItem(
              title: Text('isClosable / setClosable'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _isClosable = !_isClosable;
                  windowManager.setClosable(_isClosable);
                  setState(() {});
                },
                isSelected: [_isClosable, !_isClosable],
              ),
              onTap: () async {
                bool isClosable = await windowManager.isClosable();
                BotToast.showText(text: 'isClosable: $isClosable');
              },
            ),
            PreferenceListItem(
              title: Text('isAlwaysOnTop / setAlwaysOnTop'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _isAlwaysOnTop = !_isAlwaysOnTop;
                  windowManager.setAlwaysOnTop(_isAlwaysOnTop);
                  setState(() {});
                },
                isSelected: [_isAlwaysOnTop, !_isAlwaysOnTop],
              ),
              onTap: () async {
                bool isAlwaysOnTop = await windowManager.isAlwaysOnTop();
                BotToast.showText(text: 'isAlwaysOnTop: $isAlwaysOnTop');
              },
            ),
            PreferenceListItem(
              title: Text('getTitle / setTitle'),
              onTap: () async {
                String title = await windowManager.getTitle();
                BotToast.showText(
                  text: '${title.toString()}',
                );
                title =
                    'window_manager_example - ${DateTime.now().millisecondsSinceEpoch}';
                await windowManager.setTitle(title);
              },
            ),
            PreferenceListItem(
              title: Text('hasShadow / setHasShadow'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  Text('YES'),
                  Text('NO'),
                ],
                onPressed: (int index) {
                  _hasShadow = !_hasShadow;
                  windowManager.setHasShadow(_hasShadow);
                  setState(() {});
                },
                isSelected: [_hasShadow, !_hasShadow],
              ),
              onTap: () async {
                bool hasShadow = await windowManager.hasShadow();
                BotToast.showText(
                  text: 'hasShadow: $hasShadow',
                );
              },
            ),
            PreferenceListItem(
              title: Text('terminate'),
              onTap: () async {
                await windowManager.terminate();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Started"),
      ),
      body: _buildBody(context),
    );
  }

  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
  }
}
