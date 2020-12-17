import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'ColorPalette.dart';
import 'CustomTween.dart';

class BarChart {
  final List<Bar> bars;

  BarChart(this.bars);

  factory BarChart.empty(Size size) {
    return BarChart(<Bar>[]);
  }

  factory BarChart.random(Size size, Random random) {
    var barWidthFraction = 0.75;
    var ranks = selectRanks(random, ColorPalette.primary.length);
    var barCount = ranks.length;
    var barDistance = size.width / (1 + barCount);
    var barWidth = barDistance * barWidthFraction;
    var startX = barDistance - barWidth / 2;

    final bars = List.generate(
        barCount,
        (i) => Bar(
              ranks[i],
              startX + i * barDistance,
              barWidth,
              random.nextDouble() * size.height,
              ColorPalette.primary[ranks[i]],
            ));
    return BarChart(bars);
  }

  static List<int> selectRanks(Random random, int cap) {
    var ranks = <int>[];
    var rank = 0;
    while (true) {
      if (random.nextDouble() < 0.2) rank++;
      if (cap <= rank) break;
      ranks.add(rank);
      rank++;
    }
    return ranks;
  }
}

class BarChartTween extends Tween<BarChart> {
  final MergeTween _barsTween;

  BarChartTween(BarChart begin, BarChart end)
      : _barsTween = MergeTween(begin.bars, end.bars),
        super(begin: begin, end: end);

  @override
  BarChart lerp(double t) => BarChart(_barsTween.lerp(t));
}

class Bar {
  Bar(this.rank, this.x, this.width, this.height, this.color);

  final int rank;
  final double x;
  final double width;
  final double height;
  final Color color;

  Bar get empty => Bar(rank, x, 0.0, 0.0, color);

  bool operator <(Bar other) => rank < other.rank;

  Tween<Bar> tweenTo(Bar other) => BarTween(this, other);

  static Bar lerp(Bar begin, Bar end, double t) {
    return Bar(
      begin.rank,
      lerpDouble(begin.x, end.x, t),
      lerpDouble(begin.width, end.width, t),
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  final Animation<BarChart> animation;
  final PaintingStyle paintingStyle;

  BarChartPainter(Animation<BarChart> animation, PaintingStyle paintingStyle)
      : animation = animation,
        paintingStyle = paintingStyle,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = paintingStyle;
    final chart = animation.value;
    for (final bar in chart.bars) {
      paint.color = bar.color;
      canvas.drawRect(
        Rect.fromLTWH(
          bar.x,
          size.height - bar.height,
          bar.width,
          bar.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}
