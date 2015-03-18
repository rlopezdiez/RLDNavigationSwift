# RLDNavigationSwift

If you want to adhere to the single responsibility principle of object-oriented programming, your view controllers shouldn't be taking care of the navigation flow of your app.

`RLDNavigationSwift` is a set of Swift classes which allow you to decouple navigation from view controllers, using navigation command objects to define the possible navigation flows of your app.

It implements routing using breadth-first search to resolve complex paths. It also prevents navigation cycles like `A > B > C > B`. A sample app is included.

> Requires XCode Version 6.3 (6D543q) or newer.
> [Objective-C version](https://github.com/rlopezdiez/RLDNavigation) also available.

## How to use

### Environment setup

The easiest setup involves subclassing `RLDPushPopNavigationCommand` for each of the `destination` view controllers of your app, defining the possible flows that can lead to that view controller and how to initialize it, by overriding these class vars: 

```swift
class var origins:[String]? 
class var destination:String?
class var viewControllerStoryboardIdentifier:String?
class var nibName:String? 
```

You should return in `origins` an array of all the view controller classes that can lead to the one referred by the navigation command in `destination`. If you return an empty array or `nil`, the `destination` view controller class will be accessible from any other view controller.

If your navigation command doesn't provide a `viewControllerStoryboardIdentifier` and a `nibName`, the view controller will be initialised by direct allocation.

You can implement more advanced navigation commands by subclassing `RLDNavigationCommand`.

#### Registering navigation commands

In order to find the most suitable navigation commands, `RLDNavigationCommandFactory` is used. You need to register your custom created navigation commands to make them available to the factory, using their `registerCommandClass()` class function.

One he best way to make sure all your classes are ready when needed is registering them in the same place. You can use a registar class with a function that is called once in when the application has finished launching. The included sample app uses this approach:

```swift
import Foundation

class RLDNavigationCommandRegistrar {
    
    static var onceToken: dispatch_once_t = 0
    
    class func registerAvailableNavigationCommands() {
        dispatch_once(&onceToken) {
            RLDMenuNavigationCommand.registerCommandClass()
            RLDFolderNavigationCommand.registerCommandClass()
            RLDConnectionsNavigationCommand.registerCommandClass()
            RLDProfileNavigationCommand.registerCommandClass()
            RLDChatNavigationCommand.registerCommandClass()
            RLDContactCardViewModelNavigationCommand.registerCommandClass()
        }
    }
}

```

### Navigating between view controllers

#### Basic navigation

Once you have registered all the navigation commands that you need, you will be able to easily navigate from one view controller to another:

```swift
RLDNavigationSetup(
    destination:"classNameOfDestination",
    navigationController:navigationController!).go()
```

#### Setting up the view controllers

If you need to pass parameters or customize the view controllers when navigating to them, you can specify a dictionary of properties, and [KVC](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/BasicPrinciples.html#//apple_ref/doc/uid/20002170-178791) will be used to try to set all properties for every newly instantiated view controller in the navigation chain. 

For instance, if three view controllers are pushed when navigating in this example, all of them will get its `userName` property set to `John Doe`. In case any of the view controllers doesn't have this property, or it's readonly, it will be ignored:

```swift
RLDNavigationSetup(
    destination:"classNameOfDestination",
    properties:["userName":"John Doe"],
    navigationController:navigationController!).go()
```

#### Breadcrumbs

You can override the fully automatic flow calculation by specifying intermediate destinations that must be reached before aiming to the final target. Automated paths will be followed between these milestones when necessary.

```swift
RLDNavigationSetup(
    destination:"classNameOfDestination",
    properties:["userName":"John Doe"],
    breadcrumbs:["firstIntermediateClassName", "secondIntermediateClassName"],
    navigationController:navigationController!).go()
```

Breadcrumbs can help you creating complex routes, and are also a helpful way to replace URL-like navigation definitions.

#### View models

Instead of exposing your view controller classes, you should consider using view models, which is a cleaner, more flexible and strongly typed way to pass configuration parameters around. This will require a little more effort from your side if your application is not architected to work that way, but will probably pay off in the long term. You can find how to use view models with `RLDNavigationSwift` in the included sample app:
```swift
// RLDMenuViewController
- (IBAction)contactCardTapped {
    RLDContactCardViewModel *viewModel = [RLDContactCardViewModel viewModelWithName:@"John"
                                                                            surname:@"Doe"
                                                                              email:@"john.doe@example.com"];
    [[RLDNavigationSetup setupWithViewModel:viewModel
                       navigationController:self.navigationController] go];
}
```

#### URL navigation

In the unlikely event that you want to use an URL-like navigation scheme, you can easily implement it with `RLDNavigationSwift`. Just create a category on `RLDNavigationSetup` and implement a factory method to convert the URL components into breadcrumbs, and the final query into properties. You can find an basic example of how to do this in the included app:

```swift
// RLDMenuViewController
    @IBAction func contactCardTapped() {
        let viewModel = RLDContactCardViewModel(name:"John", surname:"Doe", email:"john.doe@example.com")
        RLDNavigationSetup(
            viewModel:viewModel,
            navigationController:navigationController!).go()
    }
```

## Installing

### Using CocoaPods

To use the latest stable release of `RLDNavigationSwift`, just add the following to your project `Podfile`:

```
pod 'RLDNavigationSwift', '~> 0.4.0' 
```

If you like to live on the bleeding edge, you can use the `master` branch with:

```
pod 'RLDNavigationSwift', :git => 'https://github.com/rlopezdiez/RLDNavigationSwift'
```

### Manually

1. Clone, add as a submodule or [download.](https://github.com/rlopezdiez/RLDNavigationSwift/zipball/master)
2. Add all the files under `Classes` to your project.
3. Enjoy.

## License

`RLDNavigationSwift` is available under the Apache License, Version 2.0. See LICENSE file for more info.

This README has been made with [(GitHub-Flavored) Markdown Editor](http://jbt.github.io/markdown-editor)