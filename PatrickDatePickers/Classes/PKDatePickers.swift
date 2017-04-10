//
//  PKDatePickers.swift
//  PatrickDatePickers
//
//  Created by pratikpanchal131 on 04/10/2017.
//  Copyright (c) 2017 pratikpanchal13. All rights reserved.
//



import UIKit

public protocol PKDatePickersDelegate: class {
    
    func pkDatePickers(_ pkDatePickers: PKDatePickers, didSelect date: Date)
    func pkDatePickersDidCancelSelection(_ pkDatePickers: PKDatePickers)
    
}

public class PKDatePickers: UIView {
    
    // MARK: - Config
    public  struct Config {
        
        public let contentHeight: CGFloat = 250
        public let bouncingOffset: CGFloat = 20
        
        public var startDate: Date?
        public var minimumDate: Date?
        public var maximumDate: Date?
        
        public var confirmButtonTitle = "Select"
        public var cancelButtonTitle = "Cancel"
        
        public var headerHeight: CGFloat = 50
        
        public var animationDuration: TimeInterval = 0.3
        
        public var contentBackgroundColor: UIColor = UIColor.lightGray
        public var headerBackgroundColor: UIColor = UIColor.white
        public var confirmButtonColor: UIColor = UIColor.blue
        public var cancelButtonColor: UIColor = UIColor.black
        
        public var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
        
    }
    
    public var config = Config()
    
    public weak var delegate: PKDatePickersDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    public var bottomConstraint: NSLayoutConstraint!
    public var overlayButton: UIButton!
    
    // MARK: - Init
    public static func getFromNib() -> PKDatePickers {
        let podBundle = Bundle(for: PKDatePickers.self)
        let bundleURL = podBundle.url(forResource: "PKDatePickers", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        return UINib(nibName: "PKDatePickers", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! PKDatePickers
    }
    
    // MARK: - IBAction
    @IBAction func confirmButtonDidTapped(_ sender: AnyObject) {
        
        config.startDate = datePicker.date
        
        dismiss()
        delegate?.pkDatePickers(self, didSelect: datePicker.date)
        
    }
    @IBAction func cancelButtonDidTapped(_ sender: AnyObject) {
        dismiss()
        delegate?.pkDatePickersDidCancelSelection(self)
    }
    
    // MARK: - public
    public func setup(_ parentVC: UIViewController) {
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate
        }
        
        if let minimumData = config.minimumDate{
            
            datePicker.minimumDate = minimumData
        }
        
        if let maximumDate = config.maximumDate{
            
            datePicker.maximumDate = maximumDate
        }
        
        headerViewHeightConstraint.constant = config.headerHeight
        
        confirmButton.setTitle(config.confirmButtonTitle, for: UIControlState())
        cancelButton.setTitle(config.cancelButtonTitle, for: UIControlState())
        
        confirmButton.setTitleColor(config.confirmButtonColor, for: UIControlState())
        cancelButton.setTitleColor(config.cancelButtonColor, for: UIControlState())
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: parentVC.view) { parentVC.view.addSubview(overlayButton) }
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: parentVC.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        if !isDescendant(of: parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint,
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        move(goUp: false)
        
    }
    public  func move(goUp: Bool) {
        bottomConstraint.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    public func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        parentVC.view.endEditing(true)
        
        setup(parentVC)
        move(goUp: true)
        
        UIView.animate(
            withDuration: config.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
        }, completion: { (finished) in
            completion?()
        }
        )
        
    }
    public func dismiss(_ completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animate(
            withDuration: config.animationDuration, animations: {
                
                self.layoutIfNeeded()
                self.overlayButton.alpha = 0
                
        }, completion: { (finished) in
            completion?()
            self.removeFromSuperview()
            self.overlayButton.removeFromSuperview()
        }
        )
        
    }
    
}
