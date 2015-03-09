extension RLDNavigationSetup {

    func go() {
        if let navigationCommand = RLDNavigationCommandFactory.navigationCommand(navigationSetup:self) {
            navigationCommand.execute()
        }
    }
    
}