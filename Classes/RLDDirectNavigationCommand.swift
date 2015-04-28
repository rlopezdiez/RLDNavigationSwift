import Foundation

public class RLDDirectNavigationCommand:RLDNavigationCommand {
    
    private lazy var navigationCommandClassChain:[String] = { [unowned self] in
        return self.navigationCommandClassChainWithNavigationSetup(self.navigationSetup, availableCommandsClasses:self.availableCommandClasses)
        }()
    
    override public func execute() {
        
        if count(availableCommandClasses) == 0 {
            return
        }
        
        var navigationCommands:[RLDNavigationCommand] = []
        
        for navigationCommandClass in navigationCommandClassChain {
            
            let navigationCommandType = NSClassFromString(navigationCommandClass) as! RLDNavigationCommand.Type
            navigationSetup.destination = navigationCommandType.destination!
            
            let navigationCommand = navigationCommandType(navigationSetup:navigationSetup, completionClosure:nil)!
            
            if let lastNavigationCommand = navigationCommands.last {
                lastNavigationCommand.completionClosure = {
                    navigationCommand.execute()
                }
            }
            
            navigationCommands.append(navigationCommand)
            
            navigationSetup.origin = navigationSetup.destination
        }
        
        if let lastNavigationCommand = navigationCommands.last {
            lastNavigationCommand.completionClosure = completionClosure
            navigationCommands.first!.execute()
        }
        
    }
    
}