import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/constants.dart';

class AgoraService {
  late RtcEngine _engine;

  Future<void> initAgora() async {
    // Retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: AppConstants.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await _engine.enableVideo();
  }

  Future<void> joinChannel(String channelName, int uid, {bool isHost = false}) async {
    await _engine.setClientRole(
      role: isHost ? ClientRoleType.clientRoleBroadcaster : ClientRoleType.clientRoleAudience,
    );
    await _engine.joinChannel(
      token: '', // In production, fetch from server
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> setLowDataMode(bool enabled) async {
    if (enabled) {
      await _engine.setVideoEncoderConfiguration(const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 480, height: 480),
        frameRate: 15,
        bitrate: 400,
      ));
    } else {
      await _engine.setVideoEncoderConfiguration(const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 720, height: 1280),
        frameRate: 30,
        bitrate: 1000,
      ));
    }
  }
}
