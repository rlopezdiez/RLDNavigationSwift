import UIKit

public class RLDPushPopNavigationCommand:RLDDirectNavigationCommand {

    // MARK: Suitability checking
    
    override public class func canHandle(navigationSetup navigationSetup:RLDNavigationSetup) -> Bool {
        let isDestinationValid = NSClassFromString(navigationSetup.destination)!.isSubclassOfClass(NSClassFromString(destination!)!)
        if isDestinationValid == false {
            return false
        }
        
        let canPopToDestinationInNavigationSetup = navigationSetup.navigationController.findDestination(navigationSetup:navigationSetup) != nil
        let canPushToDestination = canPopToDestinationInNavigationSetup ? false : isOriginValid(navigationSetup.origin)
        
        return canPopToDestinationInNavigationSetup || canPushToDestination
    }
    
    private class func isOriginValid(originClass:String) -> Bool {
        if let origins = self.origins {
            for origin in origins {
                if NSClassFromString(origin)!.isSubclassOfClass(NSClassFromString(originClass)!) {
                    return true
                }
            }
            return false
        }
        return true
    }
    
    public class var viewControllerStoryboardIdentifier:String? {
        return nil
    }
    
    public class var nibName:String? {
        return "Main"
    }
    
    public class var animatesTransitions:Bool {
        return true
    }
    
    // MARK:Execution
    
    override public func execute() {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionClosure)

        if let viewControllerToReturnTo = navigationSetup.navigationController.findDestination(navigationSetup:navigationSetup) {
            popTo(viewController:viewControllerToReturnTo)
        } else {
            pushNewViewController()
        }

        CATransaction.commit()
    }
    
    private func pushNewViewController() {
        
        let viewControllerToPresent:UIViewController
        
        if (self.dynamicType.nibName != nil && self.dynamicType.viewControllerStoryboardIdentifier != nil) {
            let storyBoard:UIStoryboard = UIStoryboard(name:self.dynamicType.nibName!, bundle:nil)
            viewControllerToPresent = storyBoard.instantiateViewControllerWithIdentifier(self.dynamicType.viewControllerStoryboardIdentifier!) 
        } else {
            let destinationViewControllerClass:AnyObject.Type = NSClassFromString(self.dynamicType.destination!)!
            viewControllerToPresent = (destinationViewControllerClass as! UIViewController.Type).init()
        }
        
        configure(viewController:viewControllerToPresent)
        
        navigationSetup.navigationController.pushViewController(viewControllerToPresent, animated:self.dynamicType.animatesTransitions)
    }
    
    private func popTo(viewController viewController:UIViewController) {
        if navigationSetup.navigationController.topViewController != viewController {
            navigationSetup.navigationController.popToViewController(viewController, animated:self.dynamicType.animatesTransitions)
        }
    }
    
    // MARK: Destination view controller configuration
    
    private func configure(viewController viewController:UIViewController) {
        viewController.loadView()
        viewController.set(properties:navigationSetup.properties)
    }
    
}