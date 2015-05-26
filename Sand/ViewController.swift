//
//  ViewController.swift
//  Sand
//
//  Created by Ryder Mackay on 2015-05-26.
//  Copyright (c) 2015 Ryder Mackay. All rights reserved.
//

import UIKit

@availability(iOS, deprecated=1.0, message="DO NOT RUN ON PERSONAL DEVICES")
func WARNING(){}

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var progressView: UIProgressView!
    
    let sandbox = Sandbox()
    
    var timer: NSTimer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        WARNING()
    }
    
    func updateUI() {
        let (free, total) = sandbox.usage
        let formatter = NSByteCountFormatter()
        formatter.countStyle = .File
        formatter.allowedUnits = .UseAll
        formatter.zeroPadsFractionDigits = true
        label.text = "\(formatter.stringFromByteCount(free)) of \(formatter.stringFromByteCount(total)) free"
        progressView.progress = Float(free) / Float(total)
    }
    
    @IBAction func fill(sender: UIControl?) {
        sender?.hidden = true
        UIApplication.sharedApplication().idleTimerDisabled = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.sandbox.fill()
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().idleTimerDisabled = false
                self.timer?.invalidate()
                self.timer = nil
            }
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0/30.0, target: self, selector: "updateUI", userInfo: nil, repeats: true)
    }
}

