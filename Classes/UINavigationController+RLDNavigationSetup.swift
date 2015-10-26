import UIKit

extension UINavigationController {
    
    func findDestination(navigationSetup navigationSetup:RLDNavigationSetup) -> UIViewController? {
        
        for viewController:UIViewController in Array((viewControllers ).reverse()) {
            if viewController.isDestinationOf(navigationSetup) {
                return viewController
            }
        }
        
        return nil
    }
    
}

private extension UIViewController {
    
    func isDestinationOf(navigationSetup:RLDNavigationSetup) -> Bool {
        if self.isKindOfClass(NSClassFromString(navigationSetup.destination)!) == false {
            return false
        }
        
        if let properties = navigationSetup.properties {
            for (key, value) in properties {
                if has(property:key) && valueForKey(key)!.isEqual(value) == false {
                    return false
                }
            }
        }
        return true
    }
    
}

extension NSObject {
    
    func has(property property:String) -> Bool {
        let expectedProperty = objcProperty(name:property)
        return expectedProperty != nil
    }
    
    func canSet(property property:String) -> Bool {
        var canSet = false
        let expectedProperty = objcProperty(name:property)
        if expectedProperty != nil {
            let isReadonly = property_copyAttributeValue(expectedProperty, "R")
            canSet = isReadonly == nil
        }
        return canSet
    }
    
    func set(properties properties:[String:AnyObject]?) {
        if let properties = properties {
            for (key, value) in properties {
                if canSet(property:key) {
                    self.setValue(value, forKey:key)
                }
            }
        }
    }
    
    private func objcProperty(name name:String) -> objc_property_t {
        
        if name.characters.count == 0 {
            return nil
        }
        
        var propertyCount:UInt32 = 0
        var sourceClass:AnyClass? = self.dynamicType
        
        repeat {
            let objcProperties:UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(sourceClass, &propertyCount)
            for index in 0..<Int(propertyCount) {
                let property:objc_property_t = objcProperties[index]
                let propertyName = NSString(UTF8String:property_getName(property))!
                
                if propertyName == name {
                    return property
                }
                
            }
            free(objcProperties)
            sourceClass = sourceClass!.superclass()
            
        } while sourceClass != nil
        
        return nil
    }
    
}