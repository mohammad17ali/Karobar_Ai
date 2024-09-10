import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

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

  String _selectedLanguage = 'hi-IN';
  String _apiResponse = '';

  final _languages = [
    'hi-IN',
    'bn-IN',
    'kn-IN',
    'ml-IN',
    'mr-IN',
    'od-IN',
    'pa-IN',
    'ta-IN',
    'te-IN',
    'gu-IN'
  ];

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
      _filePath =
          '${directory.path}/audio_example.wav'; // Changed to .wav for wider support
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
          // Change the codec to aacMP4 or another compatible one
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
        // After stopping, send the audio file to the API
        await _sendAudioToAPI();
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

  Future<void> _sendAudioToAPI() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.sarvam.ai/speech-to-text'),
      );

      request.headers['api-subscription-key'] =
          '690911d6-a461-43e2-94db-74e789f7f418';

      // Add language and model fields
      request.fields['language_code'] = _selectedLanguage;
      request.fields['model'] = 'saarika:v1';

      // Attach audio file with correct MIME type
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _filePath,
          contentType: MediaType('audio', 'wav'), // Explicitly set MIME type
        ),
      );

      var response = await request.send();

      // Checking response status
      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        var decodedResponse =
            jsonDecode(responseData); // Decode the JSON response
        String transcript =
            decodedResponse['transcript']; // Extract the transcript
        print('Transcript: $transcript');
        setState(() {
          _apiResponse = ' $transcript'; // Update the UI with the transcript
        });
      } else {
        String errorData = await response.stream.bytesToString();
        print(
            'Failed to upload audio: ${response.statusCode}, error: $errorData');
        setState(() {
          _apiResponse =
              'Failed to upload audio: ${response.statusCode}, error: $errorData';
        });
      }
    } catch (e) {
      print('Failed to upload audio: $e');
      setState(() {
        _apiResponse = 'Failed to upload audio: $e';
      });
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
        title: Text('Tell Me What You Want',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: Center(
        child: SingleChildScrollView(
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
              DropdownButton<String>(
                value: _selectedLanguage,
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isRecording ? 'Stop Recording' : 'Start Recording',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _playRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff043F84),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Play Recording',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _apiResponse,
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
