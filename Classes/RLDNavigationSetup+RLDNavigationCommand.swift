public extension RLDNavigationSetup {

    public func go() {
        go(completionClosure:nil)
    }
    
    public func go(#completionClosure:(() -> Void)?) {
        if let navigationCommand = RLDNavigationCommandFactory.navigationCommand(navigationSetup:self, completionClosure:completionClosure) {
            navigationCommand.execute()
        }
    }
    
}