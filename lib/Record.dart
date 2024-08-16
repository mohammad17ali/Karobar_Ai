import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with TickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  String _filePath = '';
  String _timerText = '00:00';
  Timer? _timer;
  int _recordingDuration = 0; // seconds
  double _playbackPosition = 0.0;
  double _playbackDuration = 0.0;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _initializePaths();
    _initializeRecorder();
    _initializePlayer();
    _lottieController = AnimationController(
      vsync: this, // Providing the vsync from the TickerProviderStateMixin
      duration: const Duration(seconds: 1),
    );
  }

  Future<void> _initializePaths() async {
    final directory = await getTemporaryDirectory();
    setState(() {
      _filePath = '${directory.path}/audio_example.aac';
    });
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _showPermissionDialog();
        return;
      }

      await _recorder!.openRecorder();
      print('Recorder initialized and opened');
    } catch (e) {
      print('Error initializing recorder: $e');
    }
  }

  Future<void> _initializePlayer() async {
    _player = FlutterSoundPlayer();
    try {
      await _player!.openPlayer();
      _player!.setSubscriptionDuration(Duration(milliseconds: 100));
      _player!.onProgress!.listen((event) {
        setState(() {
          _playbackPosition = event.position.inMilliseconds.toDouble();
          _playbackDuration = event.duration.inMilliseconds.toDouble();
        });
      });
      print('Player initialized');
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    _recorder = null;
    _player = null;
    _timer?.cancel();
    _lottieController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
        _timerText = _formatDuration(_recordingDuration);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Future<void> _startRecording() async {
    if (_recorder == null) {
      print('Recorder is not initialized');
      return;
    }
    if (_recorder!.isStopped) {
      print('Starting recorder');
      try {
        await _recorder!.startRecorder(
          toFile: _filePath,
        );
        setState(() {
          _isRecording = true;
          _recordingDuration = 0;
          _timerText = '00:00';
        });
        _startTimer();
        _lottieController.repeat(); // Start Lottie animation
      } catch (e) {
        print('Error starting recorder: $e');
      }
    } else {
      print('Recorder is already recording or paused');
    }
  }

  Future<void> _stopRecording() async {
    if (_recorder != null && _recorder!.isRecording) {
      print('Stopping recorder');
      try {
        await _recorder!.stopRecorder();
        setState(() {
          _isRecording = false;
        });
        _stopTimer();
        _lottieController.stop(); // Stop Lottie animation
      } catch (e) {
        print('Error stopping recorder: $e');
      }
    } else {
      print('Recorder is not recording');
    }
  }

  Future<void> _playRecording() async {
    if (_player == null) {
      print('Player is not initialized');
      return;
    }
    if (_player!.isStopped) {
      print('Playing recording');
      try {
        _recordingDuration = 0; // Reset the duration for playback
        _startTimer();
        await _player!.startPlayer(
          fromURI: _filePath,
          whenFinished: () {
            setState(() {
              _stopTimer();
              _timerText = _formatDuration(_recordingDuration);
            });
          },
        );
      } catch (e) {
        print('Error playing recording: $e');
      }
    } else {
      print('Player is already playing');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Microphone Permission'),
          content: Text(
              'This app needs access to your microphone to record audio. Please enable microphone access in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff043F84),
        title:
            Text('Ledger', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Speak Now...',
                style: TextStyle(fontSize: 24, color: Color(0xff043F84))),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/recording_animation.json',
              width: 200,
              height: 200,
              controller: _lottieController,
            ),
            SizedBox(height: 10),
            Text(_timerText,
                style: TextStyle(fontSize: 24, color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording',
                  style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff043F84),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Play', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_formatDuration(_playbackPosition ~/ 1000),
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(width: 10),
                Expanded(
                  child: Slider(
                    value: _playbackPosition,
                    min: 0,
                    max: _playbackDuration,
                    onChanged: (newValue) {
                      setState(() {
                        _playbackPosition = newValue;
                        _player!.seekToPlayer(
                            Duration(milliseconds: newValue.toInt()));
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text(_formatDuration((_playbackDuration ~/ 1000).toInt()),
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Place Order'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: Color(0xff043F84),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RecordPage(),
  ));
}
