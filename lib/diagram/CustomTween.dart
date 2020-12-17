import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'Bar.dart';

class MergeTween extends Tween<List<Bar>> {

  final _tweens = <Tween<Bar>>[];

  ///constructor
  MergeTween(List<Bar> begin, List<Bar> end) : super(begin: begin, end: end) {
    final bMax = begin.length;
    final eMax = end.length;
    var b = 0;
    var e = 0;
    while (b + e < bMax + eMax) {
      if (b < bMax) {
        _tweens.add(begin[b].tweenTo(begin[b].empty));
        b++;
      } else if (e < eMax) {
        _tweens.add(end[e].empty.tweenTo(end[e]));
        e++;
      } else {
        _tweens.add(begin[b].tweenTo(end[e]));
        b++;
        e++;
      }
    }
  }


  @override
  List<Bar> lerp(double t) => List.generate(
        _tweens.length,
        (i) => _tweens[i].lerp(t),
      );
}