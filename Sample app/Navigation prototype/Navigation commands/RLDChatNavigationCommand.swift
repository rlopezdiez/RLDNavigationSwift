import RLDNavigationSwift

class RLDChatNavigationCommand:RLDPushPopNavigationCommand {
    
    override class func canHandle(#navigationSetup:RLDNavigationSetup) -> Bool {
        var canHandleNavigationSetup = super.canHandle(navigationSetup:navigationSetup)
        
        if (canHandleNavigationSetup) {
            if let topViewController = navigationSetup.navigationController.topViewController as? RLDProfileViewController,
                let previousUserId = topViewController.userId,
                let expectedUserId = navigationSetup.properties?["userId"] as? String {
                    canHandleNavigationSetup = previousUserId == expectedUserId
            }
        }
        
        return canHandleNavigationSetup
    }

    override class var origins:[String]? {
        return ["NavigationPrototype.RLDConnectionsViewController", "NavigationPrototype.RLDProfileViewController"]
    }
    
    override class var destination:String? {
        return "NavigationPrototype.RLDChatViewController"
    }
    
    override class var viewControllerStoryboardIdentifier:String? {
        return "RLDChatViewController"
    }
    
}