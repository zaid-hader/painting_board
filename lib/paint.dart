import 'dart:ui';

import 'package:flutter/material.dart';
class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.blue,
    Colors.white,
    Colors.green,
  ];
    int counter=0;
   List imglists=["outlinefish",
   "oulinetree",
   "outlinebear",
   "outlineflower"
   ]; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
               //add photo widget here ...

            child: Image.asset("images/${imglists[counter%imglists.length]}.png"),
          ),
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                drawingPoints.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {              
                drawingPoints.add(
                  DrawingPoint(
                    
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanEnd: (details) {
              setState(() {
                drawingPoints.add(DrawingPoint(Offset.infinite, Paint()));
              });
            },
            child: CustomPaint(
              painter: _DrawingPainter(drawingPoints.where((point) => point != null).cast<DrawingPoint>().toList()),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            left: 10,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(onPressed: (){
                    setState(() {
                      counter+=1;
                      drawingPoints = [];
                    });
                  }, child:const Text("change photo")),
                ),
                Expanded(
                  flex: 1,
                  child: Slider(
                    
                    min: 0,
                    max: 20,
                    value: strokeWidth,
                    onChanged: (val) => setState(() => strokeWidth = val),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => drawingPoints = []),
                    icon: const Icon(Icons.clear),
                    label: const Text("clear"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              colors.length,
              (index) => _buildColorChose(colors[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      // ignore: unnecessary_null_comparison
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i].offset, drawingPoints[i + 1].offset,
            drawingPoints[i].paint
            );
      // ignore: unnecessary_null_comparison
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i].offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}