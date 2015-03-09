import Foundation

class RLDContactCardViewModelNavigationCommand:RLDPushPopNavigationCommand {
    
    override class func canHandle(#navigationSetup:RLDNavigationSetup) -> Bool {
        if let viewModel = navigationSetup.properties?["viewModel"] as? RLDContactCardViewModel {
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