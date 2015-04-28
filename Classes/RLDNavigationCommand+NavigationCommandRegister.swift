import Foundation

public extension RLDNavigationCommand {
    
    private static var _availableCommandClasses:[String] = []
    
    public class func registerCommandClass() {
        _availableCommandClasses.append(NSStringFromClass(self))
    }
    
    public class func clearRegisteredCommandClasses() {
        _availableCommandClasses = []
    }
    
    public var availableCommandClasses:[String] {
        return self.dynamicType._availableCommandClasses
    }
    
}