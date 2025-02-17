//
//  RecipeappTests.swift
//  RecipeappTests
//
//  Created by Ak B on 2/14/25.
//
import XCTest
@testable import Recipeapp
import UIKit

final class RecipeappCacheTests: XCTestCase {
    
   
    func testCacheImageDataAndRetrieve() async throws {
        let diskCache = DiskImageCache()
        
       
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")!
        let dummyData = "dummy data".data(using: .utf8)!
        
        
        let fileURL = diskCache.fileURL(for: testURL)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
        
       
        diskCache.cacheImageData(dummyData, for: testURL)
        
        
        let cachedData = diskCache.cachedImageData(for: testURL)
        
        
        XCTAssertNotNil(cachedData, "Cached data should not be nil after caching.")
        XCTAssertEqual(cachedData, dummyData, "Cached data should match the original dummy data.")
    }
    
    
    func testImageLoaderCachesImage() async throws {
        let imageLoader = ImageLoader()
        
        
        let testImageURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")!
        
        
        let image1 = await imageLoader.load(url: testImageURL)
        XCTAssertNotNil(image1, "Image should be loaded on the first call.")
        
        
        let image2 = await imageLoader.load(url: testImageURL)
        XCTAssertNotNil(image2, "Image should be loaded on the second call from the cache.")
        
        
        let data1 = image1?.pngData()
        let data2 = image2?.pngData()
        XCTAssertEqual(data1, data2, "The cached image data should match the originally downloaded image data.")
    }
    
    
    func testSomething() async throws {
        XCTAssertTrue(true, "This test always passes.")
    }
}
