import Foundation

extension RLDNavigationCommand {
    
    private static var _availableCommandClasses:[String] = []
    
    class func registerCommandClass() {
        _availableCommandClasses.append(NSStringFromClass(self))
    }
    
    class func clearRegisteredCommandClasses() {
        _availableCommandClasses = []
    }
    
    var availableCommandClasses:[String] {
        return self.dynamicType._availableCommandClasses
    }
    
}