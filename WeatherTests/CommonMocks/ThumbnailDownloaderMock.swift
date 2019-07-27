
//
//  ThumbnailDownloaderMock.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit
@testable import Weather

class ThumbnailDownloaderMock: ThumbnailDownloaderProtocol {
    var image: UIImage?
    func downsample(imageUrl: URL) -> UIImage? {
        return image
    }
}
