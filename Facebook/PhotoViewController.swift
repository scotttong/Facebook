//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Scott Tong on 2/23/15.
//  Copyright (c) 2015 Scott Tong. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
	
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func didPressDoneButton(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	

}
