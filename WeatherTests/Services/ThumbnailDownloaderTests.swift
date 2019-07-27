//
//  ThumbnailDownloaderTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class ThumbnailDownloaderTests: XCTestCase {
    var sut: ThumbnailDownloader!
    
    override func setUp() {
        sut = ThumbnailDownloader()
    }
    
    func testThumbnailDownloadForDesiredSize() {
        let url = Bundle(for: ThumbnailDownloaderTests.self).url(forResource: "thumbnailtest", withExtension: "jpg")
        let image = sut.downsample(imageUrl: url!)
        
        let expected = 128.0 as CGFloat
        let actual = max(image!.size.width, image!.size.height)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testThumbnailDownloadWrongUrl() {
        let url = URL(string: "/images/missing.png")
        let image = sut.downsample(imageUrl: url!)
        
        let expected: UIImage? = nil
        let actual = image
        
        XCTAssertEqual(expected, actual)
    }
}
