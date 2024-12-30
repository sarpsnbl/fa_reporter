import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:fa_reporter/main.dart';
import 'package:fa_reporter/utils/previous_id.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'coordinates_translator.dart';

class TextRecognizerPainter extends CustomPainter {
  TextRecognizerPainter(
    this.recognizedText,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
    this.showDetectedIDDialog,
    this.isDetectedIDDialogShown,
  );

  final RecognizedText recognizedText;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final Function(String) showDetectedIDDialog;
  bool isDetectedIDDialogShown;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = corpYellow;

    final Paint background = Paint()..color = const Color(0x99000000);

    for (final textBlock in recognizedText.blocks) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: corpYellow, background: background));
      builder.addText(textBlock.text);
      builder.pop();

      final left = translateX(
        textBlock.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        textBlock.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        textBlock.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      // final bottom = translateY(
      //   textBlock.boundingBox.bottom,
      //   size,
      //   imageSize,
      //   rotation,
      //   cameraLensDirection,
      // );
      //
      // canvas.drawRect(
      //   Rect.fromLTRB(left, top, right, bottom),
      //   paint,
      // );

      final List<Offset> cornerPoints = <Offset>[];
      for (final point in textBlock.cornerPoints) {
        double x = translateX(
          point.x.toDouble(),
          size,
          imageSize,
          rotation,
          cameraLensDirection,
        );
        double y = translateY(
          point.y.toDouble(),
          size,
          imageSize,
          rotation,
          cameraLensDirection,
        );

        if (Platform.isAndroid) {
          switch (cameraLensDirection) {
            case CameraLensDirection.front:
              switch (rotation) {
                case InputImageRotation.rotation0deg:
                case InputImageRotation.rotation90deg:
                  break;
                case InputImageRotation.rotation180deg:
                  x = size.width - x;
                  y = size.height - y;
                  break;
                case InputImageRotation.rotation270deg:
                  x = translateX(
                    point.y.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  );
                  y = size.height -
                      translateY(
                        point.x.toDouble(),
                        size,
                        imageSize,
                        rotation,
                        cameraLensDirection,
                      );
                  break;
              }
              break;
            case CameraLensDirection.back:
              switch (rotation) {
                case InputImageRotation.rotation0deg:
                case InputImageRotation.rotation270deg:
                  break;
                case InputImageRotation.rotation180deg:
                  x = size.width - x;
                  y = size.height - y;
                  break;
                case InputImageRotation.rotation90deg:
                  x = size.width -
                      translateX(
                        point.y.toDouble(),
                        size,
                        imageSize,
                        rotation,
                        cameraLensDirection,
                      );
                  y = translateY(
                    point.x.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  );
                  break;
              }
              break;
            case CameraLensDirection.external:
              break;
          }
        }

        cornerPoints.add(Offset(x, y));
      }

      // Add the first point to close the polygon
      cornerPoints.add(cornerPoints.first);
      canvas.drawPoints(PointMode.polygon, cornerPoints, paint);

      canvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: (right - left).abs(),
          )),
        Offset(
            Platform.isAndroid &&
                    cameraLensDirection == CameraLensDirection.front
                ? right
                : left,
            top),
      );
    }

    String recognizedID = idDetected(recognizedText);
    if (!(recognizedID == getPreviousID())) {
      if (recognizedID != "-1" && !isDetectedIDDialogShown) {
        setPreviousID(recognizedID);
        print(recognizedID);
        Future.delayed(Duration.zero, () {
          showDetectedIDDialog(recognizedID);
        });
      }
    }
  }

  @override
  bool shouldRepaint(TextRecognizerPainter oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }

  //returns -1 if no id is recognized. Returns the 10-digit ID of the fixed asset otherwise.
  String idDetected(RecognizedText recognizedText) {
    // List of regular expressions to match various ID formats
    final regexes = [
      RegExp(r'\b\d{9}\b'),               // NNNNNNNNN
      RegExp(r'\b\d{10}\b'),              // NNNNNNNNNN
      RegExp(r'\*\*\s*'),                 // **
      RegExp(r'\b\d{8}[A-Za-z]\b'),       // NNNNNNNNNL
      RegExp(r'\b[A-Za-z]{3}-\d{4}\b'),   // LLL-NNNN
      RegExp(r'\b[A-Za-z]{6}-\d{3}\b'),   // LLLLLL-NNN
    ];

    // Iterate through the regexes and find the first match
    for (final regex in regexes) {
      final match = regex.firstMatch(recognizedText.text);
      if (match != null) {
        return match.group(0)!; // Return the matched ID
      }
    }

    // If no match is found, return "-1"
    return "-1";
  }

}
