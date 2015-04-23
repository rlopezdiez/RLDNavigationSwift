import UIKit

extension UIView {
    
    func goTo(destination:String) {
        self.goTo(destination, properties:nil, breadcrumbs:nil, completionClosure:nil)
    }
    
    func goTo(destination:String, breadcrumbs:[String]) {
        self.goTo(destination, properties:nil, breadcrumbs:breadcrumbs, completionClosure:nil)
    }
    
    func goTo(destination:String, properties:[String:AnyObject]) {
        self.goTo(destination, properties:properties, breadcrumbs:nil, completionClosure:nil)
    }
    
    func goTo(destination:String, properties:[String:AnyObject], breadcrumbs:[String]) {
        self.goTo(destination, properties:properties, breadcrumbs:breadcrumbs, completionClosure:nil)
    }
    
    func goTo(destination:String, completionClosure:(() -> Void)) {
        self.goTo(destination, properties:nil, breadcrumbs:nil, completionClosure:completionClosure)
    }
    
    func goTo(destination:String, breadcrumbs:[String], completionClosure:(() -> Void)) {
        self.goTo(destination, properties:nil, breadcrumbs:breadcrumbs, completionClosure:completionClosure)
    }
    
    func goTo(destination:String, properties:[String:AnyObject], completionClosure:(() -> Void)) {
        self.goTo(destination, properties:properties, breadcrumbs:nil, completionClosure:completionClosure)
    }
    
    func goTo(destination:String, properties:[String:AnyObject]?, breadcrumbs:[String]?, completionClosure:(() -> Void)?) {
        if let navigationController = self.topmostNavigationController() {
            RLDNavigationSetup(destination:destination,
                properties:properties,
                breadcrumbs:breadcrumbs,
                navigationController:navigationController).go(completionClosure:completionClosure)
        }
    }
    
    private func topmostNavigationController() -> UINavigationController? {
        for var nextView:UIView? = self.superview; nextView != nil; nextView = nextView!.superview {
            if let nextResponder = nextView?.nextResponder() as? UINavigationController {
                    return nextResponder;
            }
        }
        return nil;
    }
    
}