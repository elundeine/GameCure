//
//  Community.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct Community: View {
    @State var isPresented = false
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
            }
            .navigationBarTitle("Explore")
            .navigationBarItems(trailing:
                HStack {
                    Button(action:  {
                        withAnimation{
                            self.isPresented.toggle()
                        }
                        }) {
                            Image(systemName: "plus")
                        
                    }.foregroundColor(Color.black)
                }
            )
        }.fullScreenCover(isPresented: $isPresented) { PostFullScreenModalView()
    }
}
}
    struct PostFullScreenModalView: View {
            @Environment(\.presentationMode) var presentationMode
            var body: some View {
                //TODO: add dismiss button
                VStack{
                HStack {
                    Spacer()
                    Text("Dismiss").onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    
                }
                
                Post()
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                }
                Spacer()
                
            }
        }

//
//struct Community_Previews: PreviewProvider {
//    static var previews: some View {
//        Community()
//    }
//}
////{
//
//    VStack(alignment: .leading, spacing: 15){
//        HStack(){
//            Text("Publications")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("100")
//                .fontWeight(.semibold)
//        }
//        HStack(){
//            Text("Followers")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("56")
//                .fontWeight(.semibold)
//        }
//        HStack(){
//            Text("Experience")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("195320")
//                .fontWeight(.semibold)
//        }
//        HStack(){
//            Text("Points")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("1984 Stone Coins")
//                .fontWeight(.semibold)
//        }
//    }.padding(EdgeInsets(top:10, leading:10, bottom:10, trailing: 10))
//}
