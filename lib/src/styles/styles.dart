import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStyles {

 Color colorAzul = const Color.fromRGBO(0, 0, 255, 1);
 Color colorRojo = const Color.fromRGBO(204, 14, 14, 1);
 Color colorNaranja = const Color(0xfff98707);

 TextStyle titleStyle = const TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
 TextStyle titleNewProfileStyle = const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey);

 TextStyle subtitleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w100);
 TextStyle subtitleStyle1 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade500);

 LinearGradient gradientVertical = const LinearGradient(
   begin: Alignment.topCenter,
   end: Alignment.bottomCenter,
   colors: [
   Color.fromRGBO(0, 0, 255, 1), 
   Color.fromRGBO(204, 14, 14, 1)
   ]);

  LinearGradient gradientHorizontal = const LinearGradient(
   begin: Alignment.centerLeft,
   end: Alignment.centerRight,
   colors: [
   Color.fromRGBO(0, 0, 255, 1), 
   Color.fromRGBO(204, 14, 14, 1)
   ]);

  LinearGradient gradientDiagonal = const LinearGradient(
   begin: Alignment.topLeft,
   end: Alignment.bottomRight,
   colors: [
   Color.fromRGBO(0, 0, 255, 1), 
   Color.fromRGBO(204, 14, 14, 1)
   ]);

   LinearGradient gradientRedToOrange = const LinearGradient(
   begin: Alignment.centerLeft,
   end: Alignment.centerRight,
   colors: [
   Color.fromRGBO(204, 14, 14, 1), 
   Color(0xfff98707)
   ]);

  double kPadding =  8; 

}




class GradientRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const GradientRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    LinearGradient gradient =LinearGradient(colors: [
      MyStyles().colorAzul, 
      MyStyles().colorRojo
      ]);

      final Rect rect = Rect.fromCircle(center: const Offset(150, 0.0), radius: 30);
    

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
    ..shader =  gradient.createShader(rect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}
