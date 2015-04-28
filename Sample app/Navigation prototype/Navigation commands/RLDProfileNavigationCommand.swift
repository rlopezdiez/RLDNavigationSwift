import RLDNavigationSwift

class RLDProfileNavigationCommand:RLDPushPopNavigationCommand {
    
    override class func canHandle(#navigationSetup:RLDNavigationSetup) -> Bool {
        var canHandleNavigationSetup = super.canHandle(navigationSetup:navigationSetup)
        
        if (canHandleNavigationSetup) {
            if let topViewController = navigationSetup.navigationController.topViewController as? RLDChatViewController,
                let previousUserId = topViewController.userId,
                let expectedUserId = navigationSetup.properties?["userId"] as? String {
                    canHandleNavigationSetup = previousUserId == expectedUserId
            }
        }
        
        return canHandleNavigationSetup
    }

    override class var origins:[String]? {
        return ["NavigationPrototype.RLDChatViewController", "NavigationPrototype.RLDFolderViewController"]
    }
    
    override class var destination:String? {
        return "NavigationPrototype.RLDProfileViewController"
    }
    
    override class var viewControllerStoryboardIdentifier:String? {
        return "RLDProfileViewController"
    }
    
}