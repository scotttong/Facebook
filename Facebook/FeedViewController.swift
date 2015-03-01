//
//  FeedViewController.swift
//  Facebook
//
//  Created by Scott Tong on 2/4/15.
//  Copyright (c) 2015 Scott Tong. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
	

	
	
	@IBOutlet weak var feedImageView: UIImageView!
	@IBOutlet weak var feedScrollView: UIScrollView!
	
	var isPresenting: Bool = true
	var selectedImageView: UIImageView!
	var movingImageView: UIImageView!
	var blackView: UIView!
	var duration: NSTimeInterval!
	var interactiveTransition: UIPercentDrivenInteractiveTransition!
	
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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		var destinationVC = segue.destinationViewController as UIViewController
		destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
		destinationVC.transitioningDelegate = self
		
		var destinationViewController = segue.destinationViewController as PhotoViewController
		
		destinationViewController.fullSizeImage = selectedImageView.image
		
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
	
	//    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
	//        interactiveTransition = UIPercentDrivenInteractiveTransition()
	//
	//        //Setting the completion speed gets rid of a weird bounce effect bug when transitions complete
	//        interactiveTransition.completionSpeed = 0.99
	//        return interactiveTransition
	//    }
	
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		var containerView = transitionContext.containerView()
		var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		var frame = containerView.convertRect(selectedImageView.frame, fromView: feedScrollView)
		
		if (isPresenting) {
			
			var photoViewContoller = toViewController as PhotoViewController
			var finalImageView = photoViewContoller.zoomedInPhotoContainer
			var window = UIApplication.sharedApplication().keyWindow!
			
			//Hide the real deal while we're transitioning movingImageView
			
			selectedImageView.hidden = true
			photoViewContoller.zoomedInPhotoContainer.hidden = true
			
			//Set movingImageView to copy all of the properties of the selectedImageView
			
			movingImageView = UIImageView(image: selectedImageView.image)
			movingImageView.frame = frame
			
			movingImageView.contentMode = selectedImageView.contentMode
			movingImageView.clipsToBounds = selectedImageView.clipsToBounds
		
			
			containerView.addSubview(toViewController.view)
			
			//Finally add our new copy to the photoViewController
			window.addSubview(movingImageView)
			
			photoViewContoller.view.alpha = 0
			
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				
				photoViewContoller.view.alpha = 1
				self.movingImageView.frame = finalImageView.frame
				//                self.blackView.alpha = 1
				
				}) { (finished: Bool) -> Void in
					
					transitionContext.completeTransition(true)
					self.movingImageView.hidden = true
					photoViewContoller.zoomedInPhotoContainer.hidden = false
			}
			
			// Define the dismiss transition
		} else {
			
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				self.movingImageView.hidden = false
				fromViewController.view.alpha = 0
				
				//                self.blackView.alpha = 0
				self.movingImageView.frame = frame
				
				}) { (finished: Bool) -> Void in
					
					transitionContext.completeTransition(true)
					fromViewController.view.removeFromSuperview()
					self.movingImageView.removeFromSuperview()
					//                    self.blackView.removeFromSuperview()
					self.selectedImageView.hidden = false
			}
		}
	}
	
	@IBAction func onTapThumbnail(sender: AnyObject) {
		var imageView = sender.view as UIImageView
		selectedImageView = imageView
		
		performSegueWithIdentifier("photoSegue", sender: self)
	}
	
	
	
	
}
