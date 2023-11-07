import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Signature canvas. Controller is required, other parameters are optional. It expands by default.
/// This behaviour can be overridden using width and/or height parameters.
class Signature extends StatefulWidget {
  const Signature({
    Key? key,
    required this.controller,
    this.backgroundColor = Colors.grey,
    this.backgroundImage,
    this.backgroundImageUrl,
    this.backgroundImagePackage,
    this.width,
    this.height,
    this.screenCapGlobalKey,
  })  : assert(controller != null),
        super(key: key);

  final SignatureController controller;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Uint8List? backgroundImage;
  final String? backgroundImageUrl;
  final String? backgroundImagePackage;
  final GlobalKey? screenCapGlobalKey;

  @override
  State createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  /// Helper variable indicating that user has left the canvas so we can prevent linking next point
  /// with straight line.
  bool _isOutsideDrawField = false;

  DecorationImage? getImage() {
    if (widget.backgroundImage == null && widget.backgroundImageUrl == null) {
      return null;
    }
    if (widget.backgroundImage != null) {
      return DecorationImage(
          image: MemoryImage(
            widget.backgroundImage!,
          ),
          fit: BoxFit.fitWidth);
    }
    return DecorationImage(
        image: ExactAssetImage(widget.backgroundImageUrl!,
            package: widget.backgroundImagePackage),
        scale: 1,
        fit: BoxFit.fitWidth);
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = widget.width ?? double.infinity;
    final maxHeight = widget.height ?? double.infinity;
    print('maxWidth:$maxWidth');
    print('maxHeight:$maxHeight');
    final signatureCanvas = GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        //NO-OP
      },
      child: RepaintBoundary(
        key: widget.screenCapGlobalKey,
        child: Container(
          decoration:
              BoxDecoration(color: widget.backgroundColor, image: getImage()),
          child: Listener(
            onPointerDown: (event) => _addPoint(event, PointType.tap),
            onPointerUp: (event) => _addPoint(event, PointType.tap),
            onPointerMove: (event) => _addPoint(event, PointType.move),
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _SignaturePainter(widget.controller),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: maxWidth,
                      minHeight: maxHeight,
                      maxWidth: maxWidth,
                      maxHeight: maxHeight),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.width != null || widget.height != null) {
      //IF DOUNDARIES ARE DEFINED, USE LIMITED BOX
      return Align(
          alignment: Alignment.topCenter,
          child: LimitedBox(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              child: signatureCanvas));
    } else {
      //IF NO BOUNDARIES ARE DEFINED, USE EXPANDED
      return Expanded(child: signatureCanvas);
    }
  }

  void _addPoint(PointerEvent event, PointType type) {
    final o = event.localPosition;
    //SAVE POINT ONLY IF IT IS IN THE SPECIFIED BOUNDARIES
    if ((widget.width == null || o.dx > 0 && o.dx < widget.width!) &&
        (widget.height == null || o.dy > 0 && o.dy < widget.height!)) {
      // IF USER LEFT THE BOUNDARY AND AND ALSO RETURNED BACK
      // IN ONE MOVE, RETYPE IT AS TAP, AS WE DO NOT WANT TO
      // LINK IT WITH PREVIOUS POINT
      if (_isOutsideDrawField) {
        type = PointType.tap;
      }
      setState(() {
        //IF USER WAS OUTSIDE OF CANVAS WE WILL RESET THE HELPER VARIABLE AS HE HAS RETURNED
        _isOutsideDrawField = false;
        widget.controller.addPoint(Point(o, type));
      });
    } else {
      //NOTE: USER LEFT THE CANVAS!!! WE WILL SET HELPER VARIABLE
      //WE ARE NOT UPDATING IN setState METHOD BECAUSE WE DO NOT NEED TO RUN BUILD METHOD
      _isOutsideDrawField = true;
    }
  }
}

enum PointType { tap, move }

class Point {
  Point(this.offset, this.type);
  Offset offset;
  PointType type;
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this._controller) : super(repaint: _controller) {
    _penStyle = Paint()
      ..color = _controller.penColor
      ..strokeWidth = _controller.penStrokeWidth
      ..strokeCap = StrokeCap.round;
  }
  final SignatureController _controller;
  late Paint _penStyle;

  @override
  void paint(Canvas canvas, Size? size) {
    final points = _controller.value;
    if (points == null || points.isEmpty) return;
    for (var i = 0; i < (points.length - 1); i++) {
      if (points[i + 1].type == PointType.move) {
        canvas.drawLine(
          points[i].offset,
          points[i + 1].offset,
          _penStyle,
        );
      } else {
        canvas.drawCircle(
          points[i].offset,
          2,
          _penStyle,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter other) => true;
}

class SignatureController extends ValueNotifier<List<Point>> {
  SignatureController(
      {List<Point>? points,
      this.penColor = Colors.black,
      this.penStrokeWidth = 3.0,
      this.exportBackgroundColor})
      : super(points ?? []);
  final Color penColor;
  final double penStrokeWidth;
  final Color? exportBackgroundColor;

  List<Point> get points => value;

  set points(List<Point> value) {
    value = value.toList();
  }

  addPoint(Point point) {
    value.add(point);
    notifyListeners();
  }

  bool get isEmpty {
    return value.isEmpty;
  }

  bool get isNotEmpty {
    return value.isNotEmpty;
  }

  clear() {
    value = <Point>[];
  }

  Future<ui.Image?> toImage() async {
    if (isEmpty) return null;

    double minX = double.infinity, minY = double.infinity;
    double maxX = 0, maxY = 0;
    for (var point in points) {
      if (point.offset.dx < minX) minX = point.offset.dx;
      if (point.offset.dy < minY) minY = point.offset.dy;
      if (point.offset.dx > maxX) maxX = point.offset.dx;
      if (point.offset.dy > maxY) maxY = point.offset.dy;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.translate(-(minX - penStrokeWidth), -(minY - penStrokeWidth));
    if (exportBackgroundColor != null) {
      final paint = Paint();
      paint.color = exportBackgroundColor!;
      canvas.drawPaint(paint);
    }
    _SignaturePainter(this).paint(canvas, null);
    final picture = recorder.endRecording();
    return picture.toImage((maxX - minX + penStrokeWidth * 2).toInt(),
        (maxY - minY + penStrokeWidth * 2).toInt());
  }

  Future<Uint8List?> _getScreenCapBytes(GlobalKey screenCapGlobalKey) async {
    final boundary = screenCapGlobalKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();
    return bytes;
  }

  Future<Uint8List?> toPngBytes({GlobalKey? screenCapGlobalKey}) async {
    if (screenCapGlobalKey != null) {
      return await _getScreenCapBytes(screenCapGlobalKey);
    }
    final image = await toImage();
    if (image == null) {
      return null;
    }

    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes?.buffer.asUint8List();
  }
}
