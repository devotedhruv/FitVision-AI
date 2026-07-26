import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionService {
  const CameraPermissionService();

  Future<CameraPermissionState> request() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return CameraPermissionState.granted;
    if (status.isPermanentlyDenied || status.isRestricted) {
      return CameraPermissionState.permanentlyDenied;
    }
    return CameraPermissionState.denied;
  }

  Future<bool> openApplicationSettings() => openAppSettings();
}
