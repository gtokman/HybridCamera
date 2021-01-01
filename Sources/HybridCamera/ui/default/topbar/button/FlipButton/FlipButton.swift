import UIKit

open class FlipButton: ToggleButton {
   override public init(frame: CGRect) {
      super.init(frame: FlipButton.rect)
      backgroundColor = .clear
      self.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
   }
   /**
    * Boilerplate
    */
   @available(*, unavailable)
   public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
