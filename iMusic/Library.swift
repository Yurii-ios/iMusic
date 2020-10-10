//
//  Library.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 10/10/2020.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("action")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9218373299, green: 0.9163574576, blue: 0.9260496497, alpha: 1)))
                                .cornerRadius(10)
                            
                        })
                        Button(action: {
                            print("action 2")
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9218373299, green: 0.9163574576, blue: 0.9260496497, alpha: 1)))
                                .cornerRadius(10)
                            
                        })
                    }
                } .padding()
                .frame(height: 65)
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                Spacer()
                List {
                    LibraryCell()
                }
            }
            
            
            .navigationBarTitle("Library")
        }
        
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Image")
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(4)
        VStack {
            Text("1")
            Text("2")
        }
    }
    }
}


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Library()
                .previewDevice("iPhone 11")
            Library()
                .previewDevice("iPhone 11")
            Library()
                .previewDevice("iPhone 11")
            Library()
                .previewDevice("iPhone 11")
        }
    }
}
