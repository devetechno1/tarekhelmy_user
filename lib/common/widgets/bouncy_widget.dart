import 'package:flutter/widgets.dart';
class BouncyWidget extends StatefulWidget {
  final Duration duration;
  final double lift;
  final double pause;
  final double ratio;
  final Widget child;

  const BouncyWidget(
      {this.duration = const Duration(seconds: 1),
        required this.lift,
        this.pause = 0,
        this.ratio = 0.25,
        required this.child,
        super.key});

  @override
  BouncyWidgetState createState() => BouncyWidgetState();
}

class BouncyWidgetState extends State<BouncyWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BouncyAnimation(
        controller: _controller,
        lift: widget.lift,
        pause: widget.pause,
        ratio: widget.ratio,
        child: widget.child);
  }
}

class _BouncyAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> upPhase;
  final Animation<double> downPhase;
  final Animation<double> pausePhase;
  final double ratio;
  final double lift;
  final double pause;
  final Widget child;

  _BouncyAnimation({
    required this.controller,
    required this.lift,
    required this.pause,
    required this.ratio,
    required this.child,
  })  : upPhase = Tween<double>(begin: 0.0, end: lift).animate(CurvedAnimation(
      parent: controller,
      curve:
      Interval(0.0, ratio * (1 - pause), curve: Curves.decelerate))),
        downPhase = Tween<double>(begin: lift, end: 0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(ratio * (1 - pause), (1.0 - pause),
                curve: Curves.bounceOut))),
        pausePhase = Tween<double>(begin: 0, end: 0).animate(
            CurvedAnimation(parent: controller, curve: Interval(1 - pause, 1)));

  Widget _buildAnimation(BuildContext context, Widget? child) {
    Animation<double> phase = pausePhase;
    if (controller.value >= 0 && controller.value < (ratio * (1 - pause))) {
      phase = upPhase;
    }
    if (controller.value >= (ratio * (1 - pause)) &&
        (controller.value < (1 - pause))) {
      phase = downPhase;
    }
    return Transform(
        transform: Matrix4.translationValues(0, -1 * phase.value, 0),
        child: child ?? const SizedBox());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller, builder: _buildAnimation, child: child);
  }
}
