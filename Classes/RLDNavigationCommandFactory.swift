class RLDNavigationCommandFactory {

    class func navigationCommand(#navigationSetup:RLDNavigationSetup) -> RLDNavigationCommand? {
        return navigationCommand(navigationSetup:navigationSetup, completionClosure:nil)
    }

    class func navigationCommand(#navigationSetup:RLDNavigationSetup, completionClosure:(() -> Void)?) -> RLDNavigationCommand? {
        // We check if we are already at the destination
        let viewControllerToReturnTo = navigationSetup.navigationController.findDestination(navigationSetup:navigationSetup)
        if viewControllerToReturnTo != nil
            && viewControllerToReturnTo == navigationSetup.navigationController.topViewController {
                return nil
        }
        
        let breadcrumbs = navigationSetup.breadcrumbs
        if breadcrumbs != nil && breadcrumbs!.count > 0 {
            return RLDBreadcrumbNavigationCommand(navigationSetup:navigationSetup, completionClosure:completionClosure)
        }
        else {
            return RLDDirectNavigationCommand(navigationSetup:navigationSetup, completionClosure:completionClosure)
        }
    }
    
}