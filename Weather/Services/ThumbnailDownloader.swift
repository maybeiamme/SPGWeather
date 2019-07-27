//
//  ThumbnailDownloader.swift
//  Weather
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//


import UIKit

protocol ThumbnailDownloaderProtocol {
    /**
     Function for download / and downsample the image without using framebuffer.
     
     This will return nil if something goes wrong.
     */
    func downsample(imageUrl: URL) -> UIImage?
}

class ThumbnailDownloader: ThumbnailDownloaderProtocol {
    func downsample(imageUrl: URL) -> UIImage? {
        let desiredSize = CGSize(width: 64.0, height: 64.0)
        let scale = CGFloat(2.0)
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageUrl as CFURL, imageSourceOptions) else {
            return nil
        }
        let maxDimensionInPixels = max(desiredSize.width, desiredSize.height) * scale
        
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                 kCGImageSourceShouldCacheImmediately: true,
                                 kCGImageSourceCreateThumbnailWithTransform: true,
                                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}
