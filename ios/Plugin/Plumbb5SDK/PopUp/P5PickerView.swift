//
//  P5PickerView.swift
//  Plumb5SDK
//
//  Created by Shahid Akhtar Shaikh on 6/20/17.
//  Copyright © 2017 Plumb5. All rights reserved.
//

import UIKit

class P5PickerView: P5BaseFromView, UIPickerViewDelegate, UIPickerViewDataSource {
    var completion: ((String) -> Void)?
    var selectItem: String?
    var text: String = "" {
        didSet {
            backgroundColor = UIColor(red: 211.0 / 255.0, green: 211.0 / 255.0, blue: 211.0 / 255.0, alpha: 0.3)
            options = text.components(separatedBy: ",")
        }
    }

    var options: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
            let index: Int = options.firstIndex(of: selectItem!)!
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        self.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = ["picker": picker]
        let horizontalVisualString = "H:|[picker]|"
        let verticalVisualString = "V:[picker]|"
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString, options: [], metrics: nil, views: views)
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate(verticalConstraint)

        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        let cancleBtn = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(cancelBtnTapped))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnTapped))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let fixedItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedItem.width = 15
        let items = [fixedItem, cancleBtn, flexibleItem, doneBtn, fixedItem]
        toolBar.items = items
        let views1: [String: Any] = ["picker": picker, "toolBar": toolBar]
        let horizontalVisualString1 = "H:|[toolBar]|"
        let verticalVisualString1 = "V:[toolBar]-[picker]|"
        self.addSubview(toolBar)
        let horizontalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualString1, options: [], metrics: nil, views: views1)
        let verticalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: verticalVisualString1, options: [], metrics: nil, views: views1)
        NSLayoutConstraint.activate(horizontalConstraint1)
        NSLayoutConstraint.activate(verticalConstraint1)
        return picker
    }()

    @objc func cancelBtnTapped() {
        removeFromSuperview()
    }

    @objc func doneBtnTapped() {
        completion!(selectItem!)
        removeFromSuperview()
    }

    // PickerView data sources and delagates

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return options.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return options[row]
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        selectItem = options[row]
    }

    override func isFieldValid() -> Bool {
        if selectItem != nil {
            return true
        } else {
            return false
        }
    }

    override func fieldValue() -> String {
        return selectItem!
    }
}
