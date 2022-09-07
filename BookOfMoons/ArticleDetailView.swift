//
//  ArticleDetailView.swift
//  SwiftUIModal
//
//  Created by Handy Hasan on 05/09/2022.
//

import SwiftUI

struct ArticleDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    
    @State var article: NewResult
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: article.newMainImage))
                { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth:.infinity,minHeight:300,maxHeight:300)
                .clipped()
                
                
                Group {
                    
                    Text(article.newTitle)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.black)
                        .lineLimit(3)
                    
                    
                    Text("By \(article.newAuthor)".uppercased())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 0)
                .padding(.horizontal)
                
                let articleBody = article.newBody
                Text(articleBody.htmlToString())
                    .font(.body)
                    .padding()
                    .lineLimit(1000)
                    .multilineTextAlignment(.leading)
            }
            
        }
        .overlay(
            
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                    .padding(.trailing, 20)
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
        )
        .ignoresSafeArea(.all, edges: .top)
        
    }
}

extension String {
    func htmlToString() -> String {
        if let data = try? NSAttributedString(data: self.data(using: .utf16)!,
                                              options: [.documentType: NSAttributedString.DocumentType.html],
                                              documentAttributes: nil).string {
            return data
        }
        else{
            return ""
        }
        
    }
}
