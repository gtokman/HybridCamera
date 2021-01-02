import UIKit
import AVFoundation
/**
 * ## Examples:
 * let camView = CamView(frame: UISCreen.bounds)
 * addSubView(camView)
 * camView.startRecording() // start capturing
 * camView.stopRecording() // stop capturing
 * - Fixme: ⚠️️ Maybe Add CamViewController (CamVC) and CamModel?
 */
open class CamView: UIView {
    // UI
    public lazy var previewView: CamPreviewView = createPreviewView() // Has the view Finder Preview
    // AV
    public var deviceInput: AVCaptureDeviceInput?
    public let videoOutput: AVCaptureMovieFileOutput = .init()
    public let rawVideoOutput = AVCaptureVideoDataOutput()
    public let photoOutput: AVCapturePhotoOutput = .init()
    // State
    public var flashMode: AVCaptureDevice.FlashMode = .off  // - Options: .on, .off, .auto
    public var startingZoomFactorForLongPress: CGFloat = 1
    // Callbacks
    public var onVideoCaptureComplete: VideoCaptureCompleted = defaultVideoCaptureCompleted
    public var onPhotoCaptureComplete: PhotoCaptureCompleted = defaultPhotoCaptureCompleted
    public var visionService: VisionService?
    var videoSettings: [String: Int] = [:]
    
    public convenience init(visionService: VisionService = .shared, videoSettings: [String: Int] = [:]) {
        self.init(frame: UIScreen.main.bounds)
        self.visionService = visionService
        let defaultSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
        ]
        self.videoSettings = videoSettings.isEmpty
            ? defaultSettings
            : videoSettings
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    /**
     * Boilerplate
     */
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .black // Sets the background color of the view
        _ = previewView // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
        do { try setupDevice() }
        catch { Swift.print("setupDevice error:  \((error as? SetupError)?.description ?? error.localizedDescription)") }
        addGestureRecognizer()
    }
}
