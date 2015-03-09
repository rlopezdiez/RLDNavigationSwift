class RLDBreadcrumbNavigationCommand:RLDNavigationCommand {
    
    override func execute() {
        var milestones = navigationSetup.breadcrumbs!
        milestones.append(navigationSetup.destination)
        for destination in milestones {
            RLDNavigationSetup(
                destination:destination,
                properties:navigationSetup.properties,
                breadcrumbs:nil,
                navigationController:navigationSetup.navigationController).go()
        }
    }
    
}