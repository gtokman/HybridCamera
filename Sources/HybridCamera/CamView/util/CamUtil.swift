import UIKit
import AVFoundation
import With
import ResultSugar

public class CamUtil {
    /**
     * Returns camera (.front or .back)
     * - Fixme: ⚠️️ make this try error based with meaningful error message
     * - Fixme: ⚠️️ maybe add support for the different cameras types, like wide, tele, normal, consider iphone 11
     * - Fixme: ⚠️️ Seems we only support wideAngleCamera for now?
     */
    public static func camera(devicePosition: AVCaptureDevice.Position = .unspecified, deviceType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera) -> CameraResult {
        let session: AVCaptureDevice.DiscoverySession = .init(deviceTypes: [deviceType], mediaType: .video, position: devicePosition)
        let cameras: [AVCaptureDevice] = session.devices.compactMap { $0 }
        guard !cameras.isEmpty else {
            return .failure(.noCameraOfTypeAvailable(deviceType, cameras))
        }
        guard let camera = cameras.first(where: { $0.position == devicePosition }) else {
            return .failure(.noPositionAvailableForDeviceType(devicePosition, deviceType))
        }
        return .success(camera)
    }
    /**
     * Requests video and mic access
     * - Note: https://stackoverflow.com/a/47688969/5389500
     */
    public static func request(mediaTypes: Set<AVMediaType>, vc: UIViewController, onComplete: @escaping AssertMicAndVideoAccessComplete) {
        for type in mediaTypes {
            let status = AVCaptureDevice.authorizationStatus(for: type)
            guard !(AVCaptureDevice.authorizationStatus(for: type) == .authorized) else {
                onComplete(.success)
                continue
            }
            switch type {
                case .video where status == .notDetermined:
                    assertVideoAccess(vc: vc, onComplete: onComplete)
                case .audio where status == .notDetermined:
                    assertMicrophoneAccess(vc: vc, onComplete: onComplete)
                default:
                    Swift.print("ERROR: Unsupported media type \(type).")
                    onComplete(.failure(.videoAccessWasDenied))
            }
        }
    }
    
    /// Is the video recording permisson enabled.
    public static var isVideoPermissionEnabled: Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
}
/**
 * Private utility methods
 */
extension CamUtil {
    /**
     * Asserts video access
     * - Abstract: Prompts user if access is needed
     * - Parameter vc: the viewcontroller to present the Alert from
     */
    private static func assertVideoAccess(vc: UIViewController, onComplete:@escaping AssertMicAndVideoAccessComplete) {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in // prompts the user for cam access
            guard !isGranted else { onComplete(.success(())); return }
            DispatchQueue.main.async { // we have to jump on the main que again since requestAccess in onan arbitrary que
                // Fixme: ⚠️️ put the bellow dialog into a static method. along with the other AlertControllers in this lib
                with(UIAlertController(title: "Camera", message: "This app does not have permission to access camera", preferredStyle: .alert)) {
                    let action = UIAlertAction(title: "OK", style: .default) { _ in Swift.print("Do nothing, user needs to grant access from settings") }
                    $0.addAction(action)
                    vc.present($0, animated: true) { onComplete(.failure(.videoAccessWasDenied)) }
                }
            }
        }
    }
    /**
     * Asserts microphone access
     * - Fixme: ⚠️️ Use Result here with sucess or failure with meaningful err msg etc
     * - Parameter vc: the viewcontroller to present the Alert from
     */
    private static func assertMicrophoneAccess(vc: UIViewController, onComplete:@escaping AssertMicAndVideoAccessComplete) {
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch micStatus {
            case .authorized: onComplete(.success(())) // Got access
            case .denied, .restricted: onComplete(.failure(.micDeniedOrRestricted)) // Microphone disabled in settings, No access granted
            case .notDetermined: // Didn't request access yet
                AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) in
                    granted ? onComplete(.success) : onComplete(.failure(.micAccessNotDetermined))
                }
            @unknown default: fatalError("Unknown case") }
    }
}
