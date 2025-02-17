import XCTest
@testable import Recipeapp

final class DiskImageCacheTests: XCTestCase {

    var diskCache: DiskImageCache!
    let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
    let testData = "Fake data".data(using: .utf8)!

    override func setUpWithError() throws {
        diskCache = DiskImageCache()
        
        if !FileManager.default.fileExists(atPath: diskCache.cacheDirectory.path) {
            try FileManager.default.createDirectory(at: diskCache.cacheDirectory,
                                                      withIntermediateDirectories: true,
                                                      attributes: nil)
        }
    }

    override func tearDownWithError() throws {
        // delete cache
        let fileURL = diskCache.fileURL(for: testURL)
        try? FileManager.default.removeItem(at: fileURL)
        diskCache = nil
    }

    func testCacheAndRetrieveImageData() throws {
        // Cache data
        diskCache.cacheImageData(testData, for: testURL)
        
        // Retrieve cachedata.
        let retrievedData = diskCache.cachedImageData(for: testURL)
        
        // Checking
        XCTAssertNotNil(retrievedData, "Retrieved data should not be nil.")
        XCTAssertEqual(testData, retrievedData, "The cached data should match the original test data.")
    }
}
