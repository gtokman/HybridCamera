import UIKit
import AVFoundation
import Vision

/**
 * Setup
 */
extension CamView {
    /**
     * - Note: Setting device.focusMode = .continuousAutoFocus, device.exposureMode = .continuousAutoExposure could make the app better
     * - Throws: SetupError, can be used in init to forward meaningfull error message to user
     */
    @objc open func setupDevice() throws {
        rawVideoOutput.videoSettings = videoSettings
        rawVideoOutput.setSampleBufferDelegate(
            self,
            queue: DispatchQueue.global(qos: .default)
        )
        captureSession.addOutput(rawVideoOutput)
        deviceInput = try captureSession.setupCaptureDeviceInput(cameraPosition: .back)
        try captureSession.setupVideoCamera(output: videoOutput)
        try captureSession.setupPhotoCamera(output: photoOutput)
        try captureSession.setupBackgroundAudioSupport(category: .playAndRecord)
        try captureSession.setupMicrophone()
    }
}

extension CamView: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
          return
        }

        let imageRequestHandler = VNImageRequestHandler(
          cvPixelBuffer: pixelBuffer,
          orientation: .right)

        do {
            guard captureSession.isRunning else { return }
            try imageRequestHandler.perform([visionService?.detectBarcodeRequest].compactMap { $0 })
        } catch {
          print(error)
        }
    }
    
}
