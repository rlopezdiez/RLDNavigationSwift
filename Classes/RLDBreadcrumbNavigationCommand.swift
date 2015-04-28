import Foundation

public class RLDBreadcrumbNavigationCommand:RLDNavigationCommand {
    
    override public func execute() {
        var milestones = navigationSetup.breadcrumbs!
        milestones.append(navigationSetup.destination)
        
        var origin = NSStringFromClass(self.navigationSetup.navigationController.topViewController!.dynamicType)
        
        var navigationCommands:[RLDNavigationCommand] = []
        
        for destination in milestones {
            let navigationSetup = RLDNavigationSetup(
                origin:origin,
                destination:destination,
                properties:self.navigationSetup.properties,
                breadcrumbs:nil,
                navigationController:self.navigationSetup.navigationController)
            
            let navigationCommand = RLDNavigationCommandFactory.navigationCommand(navigationSetup:navigationSetup, completionClosure:nil)!
            
            if let lastNavigationCommand = navigationCommands.last {
                lastNavigationCommand.completionClosure = {
                    navigationCommand.execute()
                }
            }
            navigationCommands.append(navigationCommand)
            
            origin = destination
        }
        
        if let lastNavigationCommand = navigationCommands.last {
            lastNavigationCommand.completionClosure = completionClosure
            navigationCommands.first!.execute()
        }
    }
}