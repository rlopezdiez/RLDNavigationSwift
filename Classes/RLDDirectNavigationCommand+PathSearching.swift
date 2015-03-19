import Foundation

extension RLDDirectNavigationCommand {
    
    func navigationCommandClassChainWithNavigationSetup(navigationSetup:RLDNavigationSetup, availableCommandsClasses:[String]) -> [String] {
        var originNavigationCommandClasses = navigationCommandClassesInClasses(availableCommandsClasses, origin:navigationSetup.origin, destination:nil)
        let directNavigationCommandClasses = navigationCommandClassesInClasses(originNavigationCommandClasses, origin:navigationSetup.origin, destination:navigationSetup.destination)
        
        if count(directNavigationCommandClasses) > 0 {
            return [directNavigationCommandClasses.first!]
        }
        
        var linksBetweenNavigationCommands:[String:String] = [:]
        var nextNavigationCommandClasses = originNavigationCommandClasses

        var lastNavigationCommandClassInChain:String?
        
        while count(nextNavigationCommandClasses) > 0 {
            let parentClass = nextNavigationCommandClasses.removeAtIndex(0)
            let parentClassType:RLDNavigationCommand.Type = NSClassFromString(parentClass) as! RLDNavigationCommand.Type
            
            enumerateNavigationCommandClasses(availableCommandsClasses,
                origin:parentClassType.destination!,
                destination:nil,
                closure:{ (navigationCommandClass, stop) -> Void in
                    linksBetweenNavigationCommands[navigationCommandClass] = parentClass
                    
                    let navigationCommandClassType:RLDNavigationCommand.Type = NSClassFromString(navigationCommandClass) as! RLDNavigationCommand.Type
                    
                    if navigationCommandClassType.destination == navigationSetup.destination {
                        lastNavigationCommandClassInChain = navigationCommandClass
                        stop = true
                    } else {
                        nextNavigationCommandClasses.append(navigationCommandClass)
                    }
            })
            
            if lastNavigationCommandClassInChain != nil {
                return navigationCommandClassChain(originNavigationCommandClasses:originNavigationCommandClasses,
                    linksBetweenNavigationCommands:linksBetweenNavigationCommands,
                    lastNavigationCommandClass:lastNavigationCommandClassInChain!)
            }
            
        }
        
        return []
    }
    
    private func navigationCommandClassesInClasses(classes:[String], origin:String, destination:String?) -> [String] {
        
        var navigationCommandClasses:[String] = []
        
        enumerateNavigationCommandClasses(classes,
            origin:origin,
            destination:destination) { (navigationCommandClass, stop) -> Void in
                navigationCommandClasses.append(navigationCommandClass)
        }
        
        return navigationCommandClasses
    }
    
    private func enumerateNavigationCommandClasses(navigationCommandClasses:[String], origin:String, destination:String?, closure:(navigationCommandClass:String, inout stop:Bool) -> Void) {
        var shouldStop = false
        var found = false
        for navigationCommandClass in navigationCommandClasses {
            
            let navigationCommandType:RLDNavigationCommand.Type = NSClassFromString(navigationCommandClass) as! RLDNavigationCommand.Type
            
            var navigationSetup:RLDNavigationSetup
            if (destination == nil) {
                navigationSetup = RLDNavigationSetup(origin:origin,
                    destination:navigationCommandType.destination!,
                    properties:self.navigationSetup.properties,
                    breadcrumbs:nil,
                    navigationController:self.navigationSetup.navigationController)
            } else {
                navigationSetup = RLDNavigationSetup(origin:origin,
                    destination:destination!,
                    properties:self.navigationSetup.properties,
                    breadcrumbs:nil,
                    navigationController:self.navigationSetup.navigationController)
            }
            
            if navigationCommandType.canHandle(navigationSetup:navigationSetup)
                && navigationCommandType.destination != nil {
                    closure(navigationCommandClass:navigationCommandClass, stop:&shouldStop)
            }
            
            if shouldStop {
                break
            }
            
        }
        
    }
    
    private func navigationCommandClassChain(#originNavigationCommandClasses:[String],linksBetweenNavigationCommands:[String:String], lastNavigationCommandClass:String) -> [String] {
        var navigationCommandClassChain:[String] = []
        
        var nextClass:String? = lastNavigationCommandClass
        
        do {
            navigationCommandClassChain.insert(nextClass!, atIndex:0)
            
            if contains(originNavigationCommandClasses, nextClass!) {
                break
            }
            
            nextClass = linksBetweenNavigationCommands[nextClass!]
        } while nextClass != nil
        
        return navigationCommandClassChain
    }
    
}