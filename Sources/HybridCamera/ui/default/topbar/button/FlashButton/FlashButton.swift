import UIKit

open class FlashButton: ToggleButton {
   override public init(frame: CGRect) {
      super.init(frame: FlashButton.rect)
      backgroundColor = .clear
      self.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
   }
}
