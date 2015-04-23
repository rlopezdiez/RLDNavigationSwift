import Foundation

class RLDNavigationCommand {
    
    class var origins:[String]? {
        return nil
    }
    
    class var destination:String? {
        return nil
    }
    
    var navigationSetup:RLDNavigationSetup
    
    var completionClosure:(() -> Void)? = nil
    
    // MARK:Initialization
    
    required init?(navigationSetup:RLDNavigationSetup, completionClosure:(() -> Void)?) {
        self.navigationSetup = navigationSetup
        self.completionClosure = completionClosure
        if self.dynamicType.canHandle(navigationSetup:navigationSetup) == false {
            return nil
        }
    }
    
    convenience init?(navigationSetup:RLDNavigationSetup) {
        self.init(navigationSetup:navigationSetup, completionClosure:nil)
    }
    
    // MARK:Suitability checking
    
    class func canHandle(#navigationSetup:RLDNavigationSetup) -> Bool {
        return true
    }
    
    // MARK:Execution
    
    func execute() {
        if let completionClosure = completionClosure {
            completionClosure()
        }
    }
    
}