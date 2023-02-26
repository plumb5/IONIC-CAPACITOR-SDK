
import UIKit

class P5CheckBox: UIButton {

    @objc func configureButton(){
        self.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:0)
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgChecked = UIImage.init(named: "ic_checkbox_selected", in: frameWorkBundle, compatibleWith: nil);
        let imgUnChecked = UIImage.init(named: "ic_checkbox_unselected", in: frameWorkBundle, compatibleWith: nil);
        self.setImage(imgChecked, for: .selected)
        self.setImage(imgUnChecked, for: .normal)
    }
    @objc func btnTapped(){
        isSelected = !isSelected
    }

}
