import 'dart:async';
import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class CreateSpotSuccessScreen extends StatefulWidget {
  const CreateSpotSuccessScreen({super.key});

  @override
  State<CreateSpotSuccessScreen> createState() =>
      _CreateSpotSuccessScreenState();
}

class _CreateSpotSuccessScreenState extends State<CreateSpotSuccessScreen> {
  Timer? _homeTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    unawaited(_playCelebrationMusic());
    _homeTimer = Timer(const Duration(seconds: 5), _goHome);
  }

  Future<void> _playCelebrationMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(0.8);
      await _audioPlayer.play(
        AssetSource('audio/activity_created_victory.wav'),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Could not play the activity creation celebration audio.',
        name: 'CreateSpotSuccessScreen',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _toggleSound() async {
    final enableSound = !_soundEnabled;
    setState(() => _soundEnabled = enableSound);
    if (enableSound) {
      await _playCelebrationMusic();
    } else {
      await _audioPlayer.stop();
    }
  }

  void _goHome() {
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _homeTimer?.cancel();
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.r24.dynamicW),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton.filledTonal(
                  tooltip: _soundEnabled ? 'Turn sound off' : 'Turn sound on',
                  onPressed: _toggleSound,
                  icon: Icon(
                    _soundEnabled
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 5,
                child: Lottie.asset(
                  Assets.ain.anCongratulationScreen.path,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: Dimensions.r16.dynamicH),
              Text(
                'Activity Created!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r24.dynamicSP,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Text(
                'Your activity is now live. People can start requesting to join.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r14.dynamicSP,
                  color: context.textSecondary,
                ),
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r14.dynamicW,
                  vertical: Dimensions.r10.dynamicH,
                ),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.r999.dynamicR),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      size: Dimensions.r16.dynamicH,
                      color: context.primaryColor,
                    ),
                    SizedBox(width: Dimensions.r8.dynamicW),
                    Text(
                      'Your next game starts here',
                      style: context.bodySmall?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _goHome,
                  child: const Text('Go to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
