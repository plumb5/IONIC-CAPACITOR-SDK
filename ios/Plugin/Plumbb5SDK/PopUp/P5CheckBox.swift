
import UIKit

class P5CheckBox: UIButton {
    @objc func configureButton() {
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let frameWorkBundle = Bundle(for: type(of: self))
        let imgChecked = UIImage(named: "ic_checkbox_selected")
        let imgUnChecked = UIImage(named: "ic_checkbox_unselected")
        setImage(imgChecked, for: .selected)
        setImage(imgUnChecked, for: .normal)
    }

    @objc func btnTapped() {
        isSelected = !isSelected
    }
}
