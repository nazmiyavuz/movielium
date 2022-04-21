//
//  DeviceHelper.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 21.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

enum DeviceType {
    case iPhone
    case iPad
}


enum Orientation {
    case portrait
    case landscape
}

/// Handle device edge values for orientation and set constraints to user interface
struct DeviceDimensions {
    let short: CGFloat
    let long: CGFloat
}

final class DeviceHelper {
    
    static let main = DeviceHelper()
    
    private let screen: UIScreen = .main
    
    private init() {}
    
    /// recognize device type to handle some user interface
    /// - Returns:
    ///     DeviceType
    ///     1. iPhone
    ///     2. iPad
    func decideDeviceType() -> DeviceType {
        let model = UIDevice.current.model
        return model == "iPhone" ? .iPhone : .iPad
    }
    
    /// Recognize orientation for the first loading
    /// - Returns: orientation value of the custom enum type
    func getOrientation() -> Orientation {
        let size = screen.bounds.size
        return size.width < size.height ? .portrait : .landscape
    }
    
    /// Handle device dimensions to create some views in terms of the dimension
    /// - Returns: small and long value
    func getDimensions() -> DeviceDimensions {
        let size = screen.bounds.size
        let sizes = [size.width, size.height].sorted { $0 < $1 }
        return DeviceDimensions(short: sizes[0], long: sizes[1])
    }
}
