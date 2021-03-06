//
//  ViewController.swift
//  UniversialLinkDemo
//
//  Created by sam phomsopha on 6/24/16.
//  Copyright © 2016 sam phomsopha. All rights reserved.
//

import UIKit

let mySpecialNotificationKey = "UniversialLinkDemo.specialNotificationKey"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateNotification), name: mySpecialNotificationKey, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateNotification(object: AnyObject) {
        print("RECIEVIED NOTIFICATION")
        print(object)
    }
}

