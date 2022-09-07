struct Result: Codable {
    var title: String
    var mainImage: String
    var slug: Slug
    var author: Author
    var categories : [Categories]
}

struct Author: Codable {
    var name: String
}

struct Slug: Codable {
    var current: String
}

struct Categories: Codable {
    var title: String
}


struct ArticleDetails: Codable {
    var body:String
    var slug:Slug

}

