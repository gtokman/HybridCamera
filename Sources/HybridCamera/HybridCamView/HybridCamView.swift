import UIKit
/**
 * Main view of HybridCam
 * - Note: To support merging video segments: https://www.raywenderlich.com/188034/how-to-play-record-and-merge-videos-in-ios-and-swift
 * - Note: To support overlays on videos: https://www.lynda.com/Swift-tutorials/AVFoundation-Essentials-iOS-Swift/504183-2.html
 * - Fixme: ⚠️️ Add bottom-bar
 */
open class HybridCamView: UIView {
   public lazy var camView: CamView = createCamView()
   public lazy var topBar: TopBarViewKind? = createTopBar()
   public lazy var recordButton: RecordButtonViewKind? = createRecordButton()
//   public lazy var zoomSwitchBtn: ZoomSwitchBtnKind = createZoomSwitchBtn()
   public lazy var zoomSwitcher: ZoomSwitcherKind? = createZoomSwitcher()
   public var onCameraExit: OnCameraExit? = defaultOnCameraExit
    
    public convenience init(camView: CamView) {
        self.init(frame: UIScreen.main.bounds)
        self.camView = camView
        setup()
    }
   /**
    * Adds UI, eventHandlers and then starts the Camera preview view
    */
   override public init(frame: CGRect) {
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
        _ = camView
        _ = topBar
        _ = recordButton
  //      _ = zoomSwitchBtn
        _ = zoomSwitcher
        addEventHandlers()
        camView.startPreview() // Starts preview session
    }
}
