//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Scott Tong on 2/23/15.
//  Copyright (c) 2015 Scott Tong. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
	
	
	@IBOutlet weak var doneButtonImage: UIImageView!
	@IBOutlet weak var actionsBar: UIImageView!
	
	@IBOutlet weak var photoScrollView: UIScrollView!

	@IBOutlet weak var zoomedInPhotoContainer: UIImageView!

	
	var fullSizeImage: UIImage!
	var scrollMove: CGFloat!
	var	scrollAlpha: CGFloat!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		zoomedInPhotoContainer.image = fullSizeImage
		
		photoScrollView.delegate = self

        // Do any additional setup after loading the view.
    }
	
	func scrollViewDidScroll(scrollView: UIScrollView!) {
		scrollMove = photoScrollView.contentOffset.y
		photoScrollView.backgroundColor = UIColor(white: 0, alpha: ((100-abs(scrollMove))/100))
		
	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
		doneButtonImage.hidden = true
		actionsBar.hidden = true
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
		doneButtonImage.hidden = false
		actionsBar.hidden = false
		
		// If we scroll more than the 50 points, perform the dismiss action
		if (scrollMove > 50 || scrollMove < -50) {
			println("dismissing")
			dismissViewControllerAnimated(true, completion: nil)
			zoomedInPhotoContainer.hidden = true
		} else {
			photoScrollView.contentOffset.y = 0
		}
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
		doneButtonImage.hidden = false
		actionsBar.hidden = false
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func didPressDoneButton(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	

}
