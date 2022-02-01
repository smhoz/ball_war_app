import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  double get lowHeight => height * 0.01;
  double get mediumHeight => height * 0.02;
  double get highHeight => height * 0.04;
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(lowHeight);
  EdgeInsets get paddingMedium => EdgeInsets.all(mediumHeight);
  EdgeInsets get paddingGridView => const EdgeInsets.all(2);
  EdgeInsets get paddingHigh => EdgeInsets.all(highHeight);
}
