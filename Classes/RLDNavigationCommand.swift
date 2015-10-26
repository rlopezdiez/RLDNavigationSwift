import Foundation

public class RLDNavigationCommand {
    
    public class var origins:[String]? {
        return nil
    }
    
    public class var destination:String? {
        return nil
    }
    
    public var navigationSetup:RLDNavigationSetup
    
    public var completionClosure:(() -> Void)? = nil
    
    // MARK:Initialization
    
    required public init?(navigationSetup:RLDNavigationSetup, completionClosure:(() -> Void)?) {
        self.navigationSetup = navigationSetup
        self.completionClosure = completionClosure
        if self.dynamicType.canHandle(navigationSetup:navigationSetup) == false {
            return nil
        }
    }
    
    convenience public init?(navigationSetup:RLDNavigationSetup) {
        self.init(navigationSetup:navigationSetup, completionClosure:nil)
    }
    
    // MARK:Suitability checking
    
    public class func canHandle(navigationSetup navigationSetup:RLDNavigationSetup) -> Bool {
        return true
    }
    
    // MARK:Execution
    
    public func execute() {
        if let completionClosure = completionClosure {
            completionClosure()
        }
    }
    
}