/// Maps backend image filenames to local asset paths
class ImageMapper {
  // Map of backend image filenames to local asset paths
  static final Map<String, String> _imageMap = {
    // iPhone 13
    'iphone13_image_1.jpg': 'assets/images/products/iphone13_image_1.png',
    'iphone13_image_2.jpg': 'assets/images/products/iphone13_image_2.png',
    'iphone13_image_1.png': 'assets/images/products/iphone13_image_1.png',
    'iphone13_image_2.png': 'assets/images/products/iphone13_image_2.png',

    // iPhone 15
    'iphone15_image_1.jpg': 'assets/images/products/iphone15_image_1.png',
    'iphone15_image_2.jpg': 'assets/images/products/iphone15_image_2.png',
    'iphone15_image_1.png': 'assets/images/products/iphone15_image_1.png',
    'iphone15_image_2.png': 'assets/images/products/iphone15_image_2.png',

    // Samsung S23
    's23_image_1.jpg': 'assets/images/products/s23_image_1.png',
    's23_image_2.jpg': 'assets/images/products/s23_image_2.png',
    's23_image_1.png': 'assets/images/products/s23_image_1.png',
    's23_image_2.png': 'assets/images/products/s23_image_2.png',

    // Samsung S23 Ultra
    's23ultra_image_1.jpg': 'assets/images/products/s23ultra_image_1.png',
    's23ultra_image_2.jpg': 'assets/images/products/s23ultra_image_2.png',
    's23ultra_image_1.png': 'assets/images/products/s23ultra_image_1.png',
    's23ultra_image_2.png': 'assets/images/products/s23ultra_image_2.png',

    // Google Pixel 7
    'googlePixel7_image_1.jpg':
        'assets/images/products/googlePixel7_image_1.png',
    'googlePixel7_image_2.jpg':
        'assets/images/products/googlePixel7_image_2.png',
    'googlePixel7_image_1.png':
        'assets/images/products/googlePixel7_image_1.png',
    'googlePixel7_image_2.png':
        'assets/images/products/googlePixel7_image_2.png',

    // Xiaomi Note 12 Pro
    'xiaomi_note_12_pro_image_1.jpg':
        'assets/images/products/xiaomi_note_12_pro_image_1.png',
    'xiaomi_note_12_pro_image_2.jpg':
        'assets/images/products/xiaomi_note_12_pro_image_2.png',
    'xiaomi_note_12_pro_image_1.png':
        'assets/images/products/xiaomi_note_12_pro_image_1.png',
    'xiaomi_note_12_pro_image_2.png':
        'assets/images/products/xiaomi_note_12_pro_image_2.png',

    // Samsung A53 5G
    'a535g_image_1.jpg': 'assets/images/products/a535g_image_1.png',
    'a535g_image_2.jpg': 'assets/images/products/a535g_image_2.png',
    'a535g_image_1.png': 'assets/images/products/a535g_image_1.png',
    'a535g_image_2.png': 'assets/images/products/a535g_image_2.png',

    // Samsung S54 5G
    's545g_image_1.jpg': 'assets/images/products/s545g_image_1.png',
    's545g_image_2.jpg': 'assets/images/products/s545g_image_2.png',
    's545g_image_1.png': 'assets/images/products/s545g_image_1.png',
    's545g_image_2.png': 'assets/images/products/s545g_image_2.png',

    // Fairphone 5
    'fairphone5_image_1.jpg': 'assets/images/products/fairphone5_image_1.png',
    'fairphone5_image_2.jpg': 'assets/images/products/fairphone5_image_2.png',
    'fairphone5_image_1.png': 'assets/images/products/fairphone5_image_1.png',
    'fairphone5_image_2.png': 'assets/images/products/fairphone5_image_2.png',
  };

  /// Converts a backend image path to a local asset path
  ///
  /// If the path is already an asset path (starts with 'assets/'), returns it as-is.
  /// If the path matches a known backend image, returns the corresponding local asset path.
  /// Otherwise, returns the original path (will be treated as a network image).
  static String mapToAsset(String imagePath) {
    // Already an asset path
    if (imagePath.startsWith('assets/')) {
      return imagePath;
    }

    // Extract filename from path (handle both forward and backward slashes)
    final filename = imagePath.split(RegExp(r'[/\\]')).last;

    // Check if we have a mapping for this filename
    if (_imageMap.containsKey(filename)) {
      return _imageMap[filename]!;
    }

    // No mapping found, return original path (will be treated as network image)
    return imagePath;
  }

  /// Maps a list of image paths to local assets
  static List<String> mapListToAssets(List<String> imagePaths) {
    return imagePaths.map((path) => mapToAsset(path)).toList();
  }
}
