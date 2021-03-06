import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'edit_text_page.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl1 =
      'https://cdn.pixabay.com/photo/2021/01/11/13/28/cross-country-skiing-5908416_1280.jpg';
  String imageUrl2 =
      'https://cdn.pixabay.com/photo/2017/07/04/10/07/board-2470557__340.jpg';
  String imageUrl3 =
      'https://cdn.pixabay.com/photo/2017/07/20/03/53/homework-2521144_1280.jpg';
  //选择颜色
  Color selectColor = Colors.red;
  // 颜色列表
  List<Color> colorList = [
    Colors.red,
    Colors.white,
    Colors.black,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];
  //选择颜色
  double brushWidth = 2;
  // 笔刷粗细列表
  List<double> brushWidthList = [
    1,
    2,
    4,
    6,
    8,
  ];

  /// 旋转角度
  double rotation = 0.0;

  /// 绘制的key
  GlobalKey<FlutterPainterWidgetState> painterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Painter Demo'),
        ),
        body: Stack(
          children: [
            FlutterPainterWidget(
              key: painterKey,
              // height: 290,
              // width: 430,
              background: Center(
                child: Image.network(
                  imageUrl3,
                  fit: BoxFit.cover,
                ),
              ),
              onTapText: (item) {
                showEditTextDialog(drawText: item);
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 600),
                      opacity: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: colorList.map((color) {
                            return GestureDetector(
                              onTap: () {
                                selectColor = color;
                                // if (_tempText != null && _tempText.selected) {
                                //   _tempText.color = selectColor;
                                // }
                                setState(() {});
                                painterKey?.currentState?.setBrushColor(color);
                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                margin: EdgeInsets.all(6),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: selectColor == color ? 4 : 2,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      // opacity: boradMode == BoradMode.Draw ? 1 : 0,
                      opacity: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: brushWidthList.map((width) {
                            return GestureDetector(
                              onTap: () {
                                brushWidth = width;
                                setState(() {});
                                painterKey?.currentState?.setBrushWidth(width);
                              },
                              child: Container(
                                  height: 36,
                                  width: 36,
                                  margin: EdgeInsets.all(6),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: brushWidth == width
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.brush_rounded,
                                        size: 16,
                                        color: brushWidth == width
                                            ? selectColor
                                            : Colors.black54,
                                      ),
                                      Container(
                                        height: width,
                                        width: 18,
                                        decoration: BoxDecoration(
                                          color: brushWidth == width
                                              ? selectColor
                                              : Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(width),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          child: Icon(Icons.save_alt_rounded),
                          tooltip: '保存',
                          heroTag: 'save',
                          onPressed: () {
                            saveToImage();
                          },
                        ),
                        SizedBox(width: 2),
                        FloatingActionButton(
                          child: Icon(Icons.crop_rotate_rounded),
                          tooltip: '旋转',
                          heroTag: 'rotate',
                          onPressed: () {
                            painterKey?.currentState?.clearDraw();
                            rotation = rotation - pi / 2;
                            painterKey?.currentState
                                ?.setBackgroundRotation(rotation);
                          },
                        ),
                        SizedBox(width: 2),
                        FloatingActionButton(
                          child: Icon(Icons.undo_rounded),
                          tooltip: '回退',
                          heroTag: 'undo',
                          onPressed: () {
                            painterKey?.currentState?.undo();
                          },
                        ),
                        SizedBox(width: 2),
                        FloatingActionButton(
                          child: Icon(
                            Icons.clear,
                          ),
                          tooltip: '清空',
                          heroTag: 'clear',
                          onPressed: () {
                            painterKey?.currentState?.clearDraw();
                          },
                        ),
                        SizedBox(width: 2),
                        FloatingActionButton(
                          child: Icon(
                            Icons.text_fields_rounded,
                            color: selectColor,
                          ),
                          tooltip: '文本',
                          heroTag: 'text',
                          onPressed: () {
                            showEditTextDialog();
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  /// 现实文字输入框
  Future<void> showEditTextDialog({DrawText drawText}) async {
    //弹出文字输入框
    var result = await showDialog(
      context: context,
      builder: (context) {
        return EditTextPage(
          text: drawText?.text,
          color: drawText?.color,
        );
      },
    );
    // 获取文字结果
    if (result != null) {
      String text = result['text'];
      int colorValue = result['color'];
      debugPrint('showEditTextPage text:$text colorValue:$colorValue');
      Color textColor = Color(colorValue);
      if (drawText == null) {
        double padding = MediaQuery.of(context).padding.bottom;
        Offset center = Size(430, 290).center(Offset(0, padding));
        DrawText newDrawText = DrawText()
          ..text = text ?? ''
          ..drawSize = Size(0, 0)
          ..offset = center
          ..fontSize = 14
          ..color = textColor;
        painterKey?.currentState?.addText(newDrawText);
      } else {
        drawText
          ..text = text
          ..color = textColor;
      }

      setState(() {});
    }
  }

  // 保存为图片
  Future<void> saveToImage() async {
    Uint8List pngBytes = await painterKey?.currentState?.getImage();

    /// 显示图片
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('保存的图片'),
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Image.memory(pngBytes),
          ),
        );
      },
    );
  }
}
