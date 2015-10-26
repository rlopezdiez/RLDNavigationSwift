import RLDNavigationSwift

class RLDContactCardViewModelNavigationCommand:RLDPushPopNavigationCommand {
    
    override class func canHandle(navigationSetup navigationSetup:RLDNavigationSetup) -> Bool {
        if let _ = navigationSetup.properties?["viewModel"] as? RLDContactCardViewModel {
            return true
        } else {
            return false
        }
    }
    
    override class var destination:String? {
        return "NavigationPrototype.RLDContactCardViewController"
    }
    
    override class var viewControllerStoryboardIdentifier:String? {
        return "RLDContactCardViewController"
    }
    
}