// MARK: - HomeCategory
class HomeCategory: Codable {
    let id, name, image, banner1Image: String?
    let banner2Image, banner3Image, dateTime, status: String?

    
    var getCategoryBannerImages: [String] {
        get {
            [banner1Image, banner2Image, banner3Image].flatMap { $0 }.map { $0 ?? ""}
        }
    }
    
    var getCategoryBannerImagesTwo: [String] {
        get {
            [banner1Image, banner2Image].flatMap { $0 }.map { $0 ?? ""}
        }
    }
    
    
    var products: [Product]?
    var images: [ProductImages]?
    var productCategories: [ProductCategory] = []

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case banner1Image = "banner1_image"
        case banner2Image = "banner2_image"
        case banner3Image = "banner3_image"
        case dateTime = "date_time"
        case status
    }

    init(id: String?, name: String?, image: String?, banner1Image: String?, banner2Image: String?, banner3Image: String?, dateTime: String?, status: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.banner1Image = banner1Image
        self.banner2Image = banner2Image
        self.banner3Image = banner3Image
        self.dateTime = dateTime
        self.status = status
    }
}

typealias HomeCategories = [HomeCategory]
