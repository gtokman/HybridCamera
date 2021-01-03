import Foundation
import With
import AVFoundation
/**
 * Events
 */
extension HybridCamView {
    /**
     * Attach CallBacks
     * - Fixme: ⚠️️ add support for .auto flashmode?
     */
    @objc public func addEventHandlers() {
        guard let recordButton = recordButton else {
            return
        }
        with(recordButton) { // Attach callbacks to recordButton
            $0.onShortPressRelease = { self.camView.photoOutput.takePhoto(self.camView, flashMode: self.camView.flashMode) }
            $0.onLongPressBegan = { self.camView.startRecordingVideo() }
            $0.onLongPressRelease = { self.camView.stopRecordingVideo() }
            $0.onLongPressChanged = { self.camView.zoomViaRecord(addZoom: $0) }
        }
        guard let topBar = topBar else {
            return
        }
        with(topBar) { // Attach callbacks to topBar
            $0.flipButton.onToggle = { try? self.camView.toggleCameraPosition(for: $0 ? .front : .back) }
            $0.flashButton.onToggle = { self.camView.flashMode = $0 ? .on : .off }
            $0.exitButton.onClick =   self.onCameraExit ?? {}
        }
        //      zoomSwitchBtn.onToggle = { try? self.camView.toggleCameraPosition(for: self.topBar.flipButton.toggle ? .front : .back, deviceType: $0 ? .builtInWideAngleCamera : .builtInTelephotoCamera) }
        guard let zoomSwitcher = zoomSwitcher else {
            return
        }
        zoomSwitcher.onSwitch = { focalType in // Fixme: ⚠️️ Maybe not toggle when camposition is equal to front?
            let deviceType: AVCaptureDevice.DeviceType = {
                switch focalType {
                    case .wide:
                        return .builtInWideAngleCamera
                    case .tele:
                        return .builtInTelephotoCamera
                    case .ultraWide:
                        if #available(iOS 13.0, *) { return .builtInUltraWideCamera }
                        else { return .builtInWideAngleCamera }
                }
            }()
            Swift.print("zoomSwitcher.onSwitch: \(focalType.rawValue) deviceType: \(deviceType)")
            try? self.camView.toggleCameraPosition(for: topBar.flipButton.toggle ? .front : .back, deviceType: deviceType)
        }
    }
}
