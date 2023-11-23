import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ImcGaugeRange extends GaugeRange {
  ImcGaugeRange(
      {super.key,
      required double start,
      required double end,
      required String label,
      required Color color})
      : super(
            startValue: start,
            endValue: end,
            label: label,
            sizeUnit: GaugeSizeUnit.factor,
            labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 12),
            startWidth: 0.65,
            endWidth: 0.65,
            color: color);
}
