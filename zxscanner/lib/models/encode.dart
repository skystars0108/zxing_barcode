import 'dart:typed_data';

import 'package:flutter_zxing/flutter_zxing.dart' as zxing;
import 'package:hive_flutter/hive_flutter.dart';

part 'encode.g.dart';

@HiveType(typeId: 1)
class Encode extends HiveObject {
  Encode();

  Encode.fromEncodeResult(zxing.Encode result, Uint8List? bytes) {
    isValid = result.isValid;
    format = result.format;
    text = result.text;
    data = bytes;
    length = result.length;
  }
  @HiveField(0)
  bool? isValid;

  @HiveField(1)
  int? format;

  @HiveField(2)
  String? text;

  @HiveField(3)
  Uint8List? data;

  @HiveField(4)
  int? length;

  String get formatName => zxing.zx.barcodeFormatName(format ?? 0);
}
