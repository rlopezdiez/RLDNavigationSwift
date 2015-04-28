//
//  RLDNavigationSwift
//
//  Copyright (c) 2015 Rafael Lopez Diez. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License")
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import UIKit

public struct RLDNavigationSetup {
    public var origin:String
    public var destination:String
    public var properties:[String:AnyObject]?
    public var breadcrumbs:[String]?
    
    public var navigationController:UINavigationController
    
    public init(destination:String,
        navigationController:UINavigationController) {
            self.init(destination:destination,
                properties:nil,
                breadcrumbs:nil,
                navigationController:navigationController)
    }
    
    public init(destination:String,
        breadcrumbs:[String]?,
        navigationController:UINavigationController) {
            self.init(destination:destination,
                properties:nil,
                breadcrumbs:breadcrumbs,
                navigationController:navigationController)
    }
    
    public init(destination:String,
        properties:[String:AnyObject]?,
        navigationController:UINavigationController) {
            self.init(destination:destination,
                properties:properties,
                breadcrumbs:nil,
                navigationController:navigationController)
    }
    
    public init(destination:String,
        properties:[String:AnyObject]?,
        breadcrumbs:[String]?,
        navigationController:UINavigationController) {
            let origin = NSStringFromClass(navigationController.topViewController!.dynamicType)
            self.init(origin:origin,
                destination:destination,
                properties:properties,
                breadcrumbs:breadcrumbs,
                navigationController:navigationController)
    }
    
    public init(origin:String,
        destination:String,
        properties:[String:AnyObject]?,
        breadcrumbs:[String]?,
        navigationController:UINavigationController) {
            self.origin = origin
            self.destination = destination
            self.properties = properties
            self.breadcrumbs = breadcrumbs
            self.navigationController = navigationController
    }
    
}