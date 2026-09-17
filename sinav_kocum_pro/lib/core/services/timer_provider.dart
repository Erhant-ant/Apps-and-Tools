import 'dart:async';
import 'package:flutter/material.dart';

enum TimerMode { countdown, stopwatch }

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  bool _isRunning = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  TimerMode _mode = TimerMode.countdown;
  String? _title;

  bool get isRunning => _isRunning;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  TimerMode get mode => _mode;
  String? get title => _title;

  double get progress {
    if (_mode == TimerMode.stopwatch) return 1.0;
    if (_totalDuration.inSeconds == 0) return 0.0;
    return _currentDuration.inSeconds / _totalDuration.inSeconds;
  }

  void startCountdown(Duration duration, {String? title}) {
    _totalDuration = duration;
    _currentDuration = duration;
    _mode = TimerMode.countdown;
    _title = title;
    _startTimer();
  }

  void startStopwatch({String? title}) {
    _totalDuration = Duration.zero;
    _currentDuration = Duration.zero;
    _mode = TimerMode.stopwatch;
    _title = title;
    _startTimer();
  }

  void toggleTimer() {
    if (_isRunning) {
      pauseTimer();
    } else {
      _startTimer();
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void stopAndReset() {
    _timer?.cancel();
    _isRunning = false;
    if (_mode == TimerMode.countdown) {
      _currentDuration = _totalDuration;
    } else {
      _currentDuration = Duration.zero;
    }
    notifyListeners();
  }

  void _startTimer() {
    if (_isRunning) return;
    
    // Prevent starting countdown if duration is 0
    if (_mode == TimerMode.countdown && _currentDuration.inSeconds == 0) return;

    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_mode == TimerMode.countdown) {
        if (_currentDuration.inSeconds > 0) {
          _currentDuration -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _isRunning = false;
          _onTimerComplete();
        }
      } else {
        _currentDuration += const Duration(seconds: 1);
      }
      notifyListeners();
    });
  }

  void addMinutes(int minutes) {
    if (_mode == TimerMode.countdown) {
      _currentDuration += Duration(minutes: minutes);
      _totalDuration += Duration(minutes: minutes);
      notifyListeners();
    }
  }

  void _onTimerComplete() {
    // Notify or play sound
    // TODO: Trigger flutter_local_notifications if needed.
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
