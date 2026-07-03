import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/ui/styles/colors.dart';
import '../../../core/ui/styles/typography.dart';
import '../bloc/breathe_bloc.dart';

class BreathePage extends StatelessWidget {
  const BreathePage({super.key, this.autostart = false});

  final bool autostart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BreatheBloc>(),
      child: _BreatheView(autostart: autostart),
    );
  }
}

class _BreatheView extends StatefulWidget {
  const _BreatheView({required this.autostart});

  final bool autostart;

  @override
  State<_BreatheView> createState() => _BreatheViewState();
}

class _BreatheViewState extends State<_BreatheView>
    with SingleTickerProviderStateMixin {
  static const int _sessionSeconds = 8 * 60;
  static const List<String> _phases = ['Breathe in…', 'Hold', 'Breathe out…', 'Hold'];
  static const int _phaseLen = 4;

  late final AnimationController _scale =
      AnimationController(vsync: this, duration: const Duration(seconds: _phaseLen));

  Timer? _timer;
  int _remaining = _sessionSeconds;
  int _phase = 0;
  int _phaseSecond = 0;
  bool _running = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    if (widget.autostart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  void _start() {
    if (_done) {
      _reset();
      return;
    }
    setState(() => _running = true);
    _animatePhase();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _pause() {
    _timer?.cancel();
    _scale.stop();
    setState(() => _running = false);
  }

  void _toggle() => _running ? _pause() : _start();

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remaining = _sessionSeconds;
      _phase = 0;
      _phaseSecond = 0;
      _done = false;
    });
    _start();
  }

  void _tick() {
    if (_remaining <= 1) {
      _finish();
      return;
    }
    setState(() {
      _remaining--;
      _phaseSecond++;
      if (_phaseSecond >= _phaseLen) {
        _phaseSecond = 0;
        _phase = (_phase + 1) % _phases.length;
        _animatePhase();
      }
    });
  }

  void _animatePhase() {
    final remainInPhase = Duration(seconds: _phaseLen - _phaseSecond);
    if (_phase == 0) {
      _scale.animateTo(1, duration: remainInPhase, curve: Curves.easeInOut);
    } else if (_phase == 2) {
      _scale.animateBack(0, duration: remainInPhase, curve: Curves.easeInOut);
    }
  }

  void _skip(int seconds) {
    setState(() {
      _remaining = (_remaining + seconds).clamp(0, _sessionSeconds);
    });
    if (_remaining == 0) _finish();
  }

  void _finish() {
    _timer?.cancel();
    _scale.stop();
    final listened = _sessionSeconds - _remaining;
    context.read<BreatheBloc>().add(CompletePracticeEvent(Duration(seconds: listened)));
    setState(() {
      _running = false;
      _done = true;
      _remaining = 0;
    });
  }

  String get _clock {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
        child: Column(
          children: [
            Text('PRACTICE · 04 / 12', style: AppText.label(color: Colors.white70)),
            const SizedBox(height: 12),
            Text(
              'Returning to the breath',
              style: AppText.serif(size: 24, italic: true, color: Colors.white),
            ),
            const Spacer(),
            _rings(),
            const Spacer(),
            Text(
              _done ? 'Practice complete' : '$_clock remaining',
              style: AppText.sans(size: 13.5, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GhostControl(icon: Icons.replay_5, onTap: () => _skip(-5)),
                const SizedBox(width: 28),
                _PlayButton(running: _running, done: _done, onTap: _toggle),
                const SizedBox(width: 28),
                _GhostControl(icon: Icons.forward_5, onTap: () => _skip(5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rings() {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, _) {
        final f = 0.72 + 0.28 * _scale.value;
        return SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _ring(260, 0.10),
              _ring(200 * f, 0.14),
              _ring(140 * f, 0.22),
              Text(
                _done ? 'Well done' : (_running ? _phases[_phase] : 'Paused'),
                style: AppText.serif(size: 22, italic: true, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _ring(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.running, required this.done, required this.onTap});

  final bool running;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = done ? Icons.replay : (running ? Icons.pause : Icons.play_arrow);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.breatheBg, size: 26),
      ),
    );
  }
}

class _GhostControl extends StatelessWidget {
  const _GhostControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.4)),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }
}
