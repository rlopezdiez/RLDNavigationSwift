import Foundation

extension RLDNavigationCommand {
    
    private static var _availableCommandClasses:[String] = []
    
    class func registerCommandClass() {
        _availableCommandClasses.append(NSStringFromClass(self))
    }
    
    var availableCommandClasses:[String] {
        return self.dynamicType._availableCommandClasses
    }
    
}