/*
 * Copyright (c) 2014-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit

extension PopAnimator:CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        NSLog("#1 enter")
        if flag,ctx != nil{
            NSLog("#2 completed")
            
            ctx.completeTransition(!ctx.transitionWasCancelled)
            if !self.presenting{
                dismissCompletion?()
            }
            
        }
        ctx = nil
    }
}

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  let duration = 1.0
  var presenting = true
  var originFrame = CGRect.zero
    
    var ctx:UIViewControllerContextTransitioning!

  var dismissCompletion: (()->Void)?

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        //let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        //NSLog("fromeView size : \(fromView.bounds.size)")
        
        ctx = transitionContext
        
        containerView.addSubview(toView)
        toView.frame = transitionContext.finalFrame(for: toVC)
        
        let animation = CATransition()
        animation.duration = duration / 2.0
        //animation.type = kCATransitionReveal
        animation.type = "cube"
        
        if presenting{
            animation.subtype = kCATransitionFromLeft
        }else{
            animation.subtype = kCATransitionFromRight
        }
        
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self
    
        containerView.layer.add(animation, forKey: nil)
        
        //UIView.animate(withDuration: duration, animations: {
        //    containerView.alpha = 0.2
        //}, completion: {_ in
        //    self.dismissCompletion?()
        //    transitionContext.completeTransition(true)
        //})
        
        //toView.layer.add(animation, forKey: nil)
    }
    
    /*
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    let toView = transitionContext.view(forKey: .to)!

    let herbView = presenting ? toView : transitionContext.view(forKey: .from)!

    let initialFrame = presenting ? originFrame : herbView.frame
    let finalFrame = presenting ? herbView.frame : originFrame

    let xScaleFactor = presenting ?

      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width

    let yScaleFactor = presenting ?

      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height

    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

    if presenting {
      herbView.transform = scaleTransform
      herbView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      herbView.clipsToBounds = true
    }

    containerView.addSubview(toView)
    containerView.bringSubview(toFront: herbView)

    let herbController = transitionContext.viewController(
      forKey: presenting ? .to : .from
    ) as! HerbDetailsViewController

    if presenting {
      herbController.containerView.alpha = 0.0
    }

    UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.0,
      animations: {
        herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
        herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        herbController.containerView.alpha = self.presenting ? 1.0 : 0.0
      },
      completion:{_ in
        if !self.presenting {
          self.dismissCompletion?()
        }
        transitionContext.completeTransition(true)
      }
    )
    
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = !presenting ? 0.0 : 20.0/xScaleFactor
    round.toValue = presenting ? 0.0 : 20.0/xScaleFactor
    round.duration = duration / 2
    herbView.layer.add(round, forKey: nil)
    herbView.layer.cornerRadius = presenting ? 0.0 : 20.0/xScaleFactor
  }*/
  
}
