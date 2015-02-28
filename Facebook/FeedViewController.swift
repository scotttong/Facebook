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
	var duration: NSTimeInterval!
	
	
	@IBOutlet weak var feedImageView: UIImageView!
	@IBOutlet weak var feedScrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		duration = 0.5
		
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
		return duration
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		println("animating transition")
		
		var containerView = transitionContext.containerView()
		var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		
		if (isPresenting) {
			
			//add black background
			blackView = UIView(frame: fromViewController.view.frame)
			blackView.backgroundColor = UIColor.blackColor()
			blackView.alpha = 0
			
			containerView.addSubview(blackView)
			containerView.addSubview(toViewController.view)
			toViewController.view.alpha = 0
			
			// this is creating and setting the properties of the copy
			movingImageView = UIImageView(frame: selectedImageView.frame)
			movingImageView.image = selectedImageView.image
			movingImageView.contentMode = selectedImageView.contentMode
//			movingImageView.contentMode = UIViewContentMode.ScaleAspectFill
			movingImageView.clipsToBounds = selectedImageView.clipsToBounds


			
			// NEW STUFF -- this adds the movingImageView to the destination view controller
			// Give us your main window and let us do stuff there, it's above everything else in layer order
			
			var window = UIApplication.sharedApplication().keyWindow!
			window.addSubview(movingImageView)
			

			
			var photoViewController = toViewController as PhotoViewController
			var finalImageView = photoViewController.zoomedInPhotoContainer
			finalImageView.alpha = 0
			
			
			
			UIView.animateWithDuration(duration, animations: { () -> Void in

				self.blackView.alpha = 1
				self.movingImageView.frame = finalImageView.frame
				println("presenting\(self.movingImageView.frame)")
				toViewController.view.alpha = 1
				
				}) { (finished: Bool) -> Void in
					finalImageView.alpha = 0
					transitionContext.completeTransition(true)
					//					self.movingImageView.removeFromSuperview()
					//					toViewController.view.removeFromSuperview()
			}
		} else {
			
			
			UIView.animateWithDuration(duration, animations: { () -> Void in
				fromViewController.view.alpha = 0
				
				
				
				
				self.blackView.alpha = 0
				self.movingImageView.frame = self.selectedImageView.frame

				println("dismissing\(self.movingImageView.frame)")
				
				}) { (finished: Bool) -> Void in
					transitionContext.completeTransition(true)
					self.movingImageView.removeFromSuperview()
//					fromViewController.view.removeFromSuperview()
					self.blackView.removeFromSuperview()
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
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
