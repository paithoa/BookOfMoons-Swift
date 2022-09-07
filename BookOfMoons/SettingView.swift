//
//  SettingView.swift
//  BookOfMoons
//
//  Created by Handy Hasan on 14/7/2022.
//

import SwiftUI


class testViewNew: ObservableObject {
    @Published var details = [NewResult]()
    @Published var finalResult = [Result]()
}



struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingStore: SettingStore
    
    @State private var selectedOrder = DisplayOrderType.horror
    @StateObject var test = testView()
    
    
    func loadCategories(categories:String) async -> [NewResult] {
        guard let url = URL(string: "https://book-of-moons.appspot.com/categories/\(categories)") else {
            
            print("Invalid URL")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                test.finalResult = decodedResponse
                //this is needed because List need to conform to Identifiable
                for result in test.finalResult {
                    test.details.append(NewResult(newTitle: result.title,newMainImage: result.mainImage, newSlug: result.slug.current, newBody:"", newAuthor: result.author.name, newCategories: result.categories[0].title))
                }
                return test.details
            }
            
        } catch {
        }
        return []
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SORT PREFERENCE")) {
                    Picker(selection: $selectedOrder, label: Text("Current Genre")) {
                        ForEach(DisplayOrderType.allCases, id: \.self) {
                            orderType in
                            Text(orderType.text)
                        }
                    }
                }
                
                
            }
            
            .navigationBarTitle("Choose Genre")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            
                        }
                        self.settingStore.displayOrder = self.selectedOrder
                        dismiss()
                        
                        
                    }) {
                        Text("Save")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            self.selectedOrder = self.settingStore.displayOrder
        }
    }
}
