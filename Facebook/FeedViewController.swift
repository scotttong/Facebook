//
//  FeedViewController.swift
//  Facebook
//
//  Created by Scott Tong on 2/4/15.
//  Copyright (c) 2015 Scott Tong. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
	
	var isPresenting: Bool = true
	var selectedImageView: UIImageView!
	var movingImageView: UIImageView!
	var blackView: UIView!

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feedScrollView.contentSize = feedImageView.frame.size
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
		isPresenting = true
		return self
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
		isPresenting = false
		return self
	}
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		// The value here should be the duration of the animations scheduled in the animationTransition method
		return 0.4
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		println("animating transition")
		var containerView = transitionContext.containerView()
		var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		
		// this is creating and setting the properties of the copy
		movingImageView = UIImageView(frame: selectedImageView.frame)
		movingImageView.image = selectedImageView.image
		movingImageView.contentMode = selectedImageView.contentMode
		movingImageView.clipsToBounds = selectedImageView.clipsToBounds

		
		if (isPresenting) {

			//add black background
			blackView = UIView(frame: fromViewController.view.frame)
			blackView.backgroundColor = UIColor.blackColor()
			blackView.alpha = 0
			containerView.addSubview(blackView)
			
			//add toViewController to containerView
			containerView.addSubview(toViewController.view)
			toViewController.view.alpha = 0
			
		
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				toViewController.view.alpha = 1
				self.blackView.alpha = 1
				}) { (finished: Bool) -> Void in
					transitionContext.completeTransition(true)
			}
		} else {
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				fromViewController.view.alpha = 0
				self.blackView.alpha = 0
				}) { (finished: Bool) -> Void in
					transitionContext.completeTransition(true)
					fromViewController.view.removeFromSuperview()
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		var destinationVC = segue.destinationViewController as UIViewController
		destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
		destinationVC.transitioningDelegate = self
		
		// this creates a generic view controller, but then CASTS it as the detail view controller. Casting allows you to access all the IB outlets and variables of the destination view controller that you named.
		var destinationViewController = segue.destinationViewController as PhotoViewController
		destinationViewController.fullSizeImage = selectedImageView.image
		
		destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
		destinationViewController.transitioningDelegate = self

		
	}
	
	@IBAction func onTapThumbnail(sender: AnyObject) {
		var imageView = sender.view as UIImageView
		selectedImageView = imageView
		
		performSegueWithIdentifier("photoSegue", sender: self)
	}
	
	

	
}
