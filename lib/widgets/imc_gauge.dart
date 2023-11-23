import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'imc_gauge_range.dart';

/// isso é o medidor
/// gauge = medidor

class ImcGauge extends StatelessWidget {
  final double imc;

  const ImcGauge({super.key, required this.imc});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          showLabels: false,
          showAxisLine: false,
          showTicks: false,
          minimum: 12.5,
          maximum: 47.9,
          ranges: [
            ImcGaugeRange(
              start: 12.5,
              end: 18.5,
              label: 'MAGREZA',
              color: Colors.blue,
            ),
            ImcGaugeRange(
              start: 18.5,
              end: 24.5,
              label: 'NORMAL',
              color: Colors.green,
            ),
            ImcGaugeRange(
              start: 24.5,
              end: 29.9,
              label: 'SOBREPESO',
              color: Colors.yellow[600]!,
            ),
            ImcGaugeRange(
              start: 29.9,
              end: 39.9,
              label: 'OBESIDADE',
              color: Colors.red[500]!,
            ),
            ImcGaugeRange(
              start: 39.9,
              end: 47.9,
              label: 'OBESIDADE',
              color: Colors.red[900]!,
            ),
          ],
          pointers: [
            NeedlePointer(
              value: imc,
              enableAnimation: true,
            )
          ],
        )
      ],
    );
  }
}
