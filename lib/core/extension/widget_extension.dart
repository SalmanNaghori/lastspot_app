import 'package:flutter/material.dart';

extension CenterExtension on Widget {
  /// Wrap with center
  Center toCenter() {
    return Center(child: this);
  }

  /// Wrap with gesture detector
  Widget onTap(Function() function) =>
      GestureDetector(onTap: function, child: this);

  Padding paddingAll(double value, {Key? key}) =>
      Padding(key: key, padding: EdgeInsets.all(value), child: this);

  Padding paddingSymmetric({Key? key, double? vertical, double? horizontal}) =>
      Padding(
        key: key,
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: this,
      );

  Padding paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    Key? key,
  }) => Padding(
    key: key,
    padding: EdgeInsets.only(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
    ),
    child: this,
  );

  Container marginAll(double value, {Key? key}) {
    return Container(key: key, margin: EdgeInsets.all(value), child: this);
  }

  Container marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    Key? key,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.only(
        top: top,
        left: left,
        bottom: bottom,
        right: right,
      ),
      child: this,
    );
  }
}
