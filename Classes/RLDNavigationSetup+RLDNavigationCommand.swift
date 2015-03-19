extension RLDNavigationSetup {

    func go() {
        go(completionClosure:nil)
    }
    
    func go(#completionClosure:(() -> Void)?) {
        if let navigationCommand = RLDNavigationCommandFactory.navigationCommand(navigationSetup:self, completionClosure:completionClosure) {
            navigationCommand.execute()
        }
    }
    
}