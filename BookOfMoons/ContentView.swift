//
//  ContentView.swift
//  BookOfMoons
//
//  Created by Handy Hasan on 14/7/2022.
//

import SwiftUI
struct NewResult: Identifiable,Equatable,Hashable {
    var id = UUID()
    var newTitle: String
    var newMainImage: String
    var newSlug: String
    var newBody: String
    var newAuthor: String
    var newCategories: String
}

struct ContentView: View {
    @State public var results = [Result]()
    @State public var articleDetails = ArticleDetails(body: "", slug: Slug(current:""))
    @State public var newResults = [NewResult]()
    
    @EnvironmentObject var settingStore: SettingStore

    
    
    @State var selectedArticle: NewResult?
    @State var firstAppear: Bool = true
    @State public var showSettings: Bool = false
    
    @State var start = 5
    @State var end = 10
    @State var genre = ""

    var body: some View {
        NavigationView {
            
            List(newResults.removingDuplicates().sorted(by: self.settingStore.displayOrder.predicate() )) { article in
                
                ArticleRow(article: article)
                    .onTapGesture {
                        self.selectedArticle = article
                    }
                    .listRowSeparator(.hidden)
                    .task {
                        
                        if !self.firstAppear {  if article == self.newResults.last {
                            await loadMoreData()
                            
                        } }
                        self.firstAppear = false
                    }
                
            }
            
            
            .task {
                await loadData()
            }
           
            .listStyle(.plain)
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
            
            .navigationBarTitle("Book of Moons")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action:
                            {
                        Task {
                            while(true) {
                                await loadMoreData()
                                if(end >= 50) {
                                    break
                                }
                            }
                        }
                        self.showSettings = true
                        
                    }, label: {
                        Image(systemName: "gear").font(.title2)
                    })
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingView().environmentObject(self.settingStore)
                
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func loadData() async{
        guard let url = URL(string: "https://book-of-moons.appspot.com/posts?fbclid=IwAR3qIlOx7j8ACE2pFzINjPjQ90_SP6NyuwJsb-aovVaYYqqgv7IXEctf3oc") else {
            
            print("Invalid URL")
            return
        }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
                //this is needed because List need to conform to Identifiable
                for result in results {
                    newResults.append(NewResult(newTitle: result.title,newMainImage: result.mainImage, newSlug: result.slug.current, newBody:"", newAuthor: result.author.name, newCategories: result.categories[0].title))
                    
                    await loadArticle(slug: result.slug.current)
                }
                
            }
            
        } catch {
        }
    }
    
    
    func loadMoreData() async{
        guard let url = URL(string: "https://book-of-moons.appspot.com/posts/?start=\(start)&end=\(end)") else {
            
            print("Invalid URL")
            return
        }
        do {
            print("Called")
            let (data, _) = try await URLSession.shared.data(from: url)
            start = start + 5
            end = end + 5
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
                //this is needed because List need to conform to Identifiable
                for result in results {
                    newResults.append(NewResult(newTitle: result.title,newMainImage: result.mainImage, newSlug: result.slug.current, newBody:"", newAuthor: result.author.name, newCategories: result.categories[0].title))
                    await loadArticle(slug: result.slug.current)
                }
            }
            
        } catch {
        }
    }
    
    func loadArticle(slug: String) async {
        guard let url = URL(string: "https://book-of-moons.appspot.com/posts/\(slug)") else {
            
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(ArticleDetails.self, from: data) {
                articleDetails = decodedResponse
                
                //this is needed because List need to conform to Identifiable
                if let index = newResults.firstIndex(where: {$0.newSlug == articleDetails.slug.current}) {
                    newResults[index].newBody = articleDetails.body
                }
                
            }
            
        } catch {
        }
    }
}

struct ArticleRow: View {
    var article: NewResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            AsyncImage(url: URL(string: article.newMainImage))
            { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.purple.opacity(0.1)
            }
            .frame(width: 375, height: 300)
            .cornerRadius(20)
            
            Text(article.newTitle)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
                .lineLimit(3)
                .padding(.bottom, 0)
            
            
        }
        .padding(.bottom)
        
        
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
