import UIKit
import With
import ZoomSwitcherKit
/**
 * Create
 */
extension HybridCamView {
    /**
     * Creates camView
     */
    @objc open func createCamView() -> CamView {
        let rect: CGRect = .init(origin: .zero, size: UIScreen.main.bounds.size)
        return with(.init(frame: rect)) {
            self.addSubview($0)
        }
    }
    /**
     * Creates topBar
     */
    @objc open func createTopBar() -> TopBarViewKind {
        with(TopBar(frame: TopBar.rect)) {
            self.addSubview($0)
        }
    }
    /**
     * Creates Record button
     */
    @objc open func createRecordButton() -> RecordButtonViewKind {
        with(RecordButton(frame: RecordButton.rect)) {
            self.addSubview($0)
        }
    }
    /**
     * Creates zoom switcher
     */
    //   @objc open func createZoomSwitchBtn() -> ZoomSwitchBtnKind {
    //      fatalError("must be overriden in subclass")
    //   }
    /**
     * Creates zoom switcher
     */
    @objc open func createZoomSwitcher() -> ZoomSwitcherKind {
        let backCamType: BackCameraType = .backCameraType
        let size = ZoomSwitcher.getSize(backCamType: backCamType)
        let rect = ZoomSwitcher.getRect(size: size) // .init(origin: .zero, size: size
        return with(ZoomSwitcher(frame: rect, backCameraType: backCamType)) {
            $0.buttons[backCamType.defaultLenseIndex].toggle = true // for tripple cam this needs to be .second,
            //         $0.onSwitch = { focalType in
            //            Swift.print("Switched to focalType:  \(focalType)")
            //         }
            self.addSubview($0)
        }
    }
}
