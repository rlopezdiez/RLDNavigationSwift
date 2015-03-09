import Foundation

class RLDNavigationCommand {
    
    class var origins:[String]? {
        return nil
    }
    
    class var destination:String? {
        return nil
    }

    var navigationSetup:RLDNavigationSetup

    // MARK:Initialisation
    
    required init?(navigationSetup:RLDNavigationSetup) {
        self.navigationSetup = navigationSetup
        if self.dynamicType.canHandle(navigationSetup:navigationSetup) == false {
            return nil
        }
    }
    
    // MARK:Suitability checking
    
    class func canHandle(#navigationSetup:RLDNavigationSetup) -> Bool {
        return true
    }
    
    // MARK:Execution
    func execute() {
        // Default implementation does nothing
    }
    
}