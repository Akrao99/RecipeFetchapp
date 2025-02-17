import SwiftUI


// Disk cache //store in  subdirectory of the apps caches directory.
class DiskImageCache {
    let fileManager = FileManager.default
    let cacheDirectory: URL
    
    init() {
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to locate caches directory")
        }
        cacheDirectory = cachesDirectory.appendingPathComponent("DiskImageCache")
        print("Cache directory: \(cacheDirectory.path)") // for Checking images are cached on my MacBook.
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory,
                                               withIntermediateDirectories: true,
                                               attributes: nil)
        }
    }
    
    func fileURL(for url: URL) -> URL {
        let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(fileName)
    }
    
    func cacheImageData(_ data: Data, for url: URL) {
        let fileURL = self.fileURL(for: url)
        try? data.write(to: fileURL)
    }
    
    func cachedImageData(for url: URL) -> Data? {
        let fileURL = self.fileURL(for: url)
        return fileManager.fileExists(atPath: fileURL.path) ? try? Data(contentsOf: fileURL) : nil
    }
}



//  image loading using disk cache
final class ImageLoader {
    let diskCache = DiskImageCache()
    
    
        
    
        func load(url: URL) async -> UIImage? {
        // Check if the image data is cached on disk.
        if let data = diskCache.cachedImageData(for: url),
           let cachedImage = UIImage(data: data) {
            await Task.yield()
            return cachedImage
        }
        
        // Download image if not in cache directory
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            diskCache.cacheImageData(data, for: url)
            return image
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
            return nil
        }
    }
}



struct CachedAsyncImage: View {
    let url: URL
    @State var image: UIImage?
    @State var isLoading = false
    let imageLoader = ImageLoader()
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else if isLoading {
                ProgressView()
            } else {
                Color.gray.opacity(0.1)
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    func loadImage() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            let loadedImage = await imageLoader.load(url: url)
            await MainActor.run {
                self.image = loadedImage
                self.isLoading = false
            }
        }
    }
}
