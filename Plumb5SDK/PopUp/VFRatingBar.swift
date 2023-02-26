//
//  VFRatingBar.swift
//  VendorFeedback
//
//  Created by Shaikh Sahid Akhtar on 02/11/16.
//  Copyright © 2016 Shaikh Sahid Akhtar. All rights reserved.
//

import UIKit

class VFRatingBar: P5BaseFromView {

    @IBOutlet weak var lblField: UILabel!
    @IBOutlet weak var vwRatitingButtonContainer: UIView!
    @objc var contentView: UIView!
    
    @IBInspectable var label:String = "" {
        didSet{
            if self.lblField != nil {
                self.lblField?.text = label;
            }
        }
    };
    var ratingValue:NSInteger! = 0;
    
    @objc var nibName: String {
        return String(describing: type(of: self))
    }
    
    //MARK:
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    //MARK:
    fileprivate func loadViewFromNib() {
        let frameWorkBundle = Bundle(for: type(of: self))
        contentView = frameWorkBundle.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }

    @IBAction func btnRatingTapped(_ sender: UIButton) {
        let tag = sender.tag;
        setRating(tag);
    }
    @objc func setRating(_ rating:NSInteger)  {
        self.ratingValue = rating;
        for i in 1 ..< 6 {
            let button = self.vwRatitingButtonContainer.viewWithTag(i) as! UIButton;
            if i<=rating {
                button.isSelected = true;
            }else{
                button.isSelected = false;
            }
        }
    }
    override func isFieldValid() -> Bool {
        if self.ratingValue != 0{
            return true
        }else{
            return false
        }
    }
    override func fieldValue() -> String {
        return String(self.ratingValue);
    }
}
