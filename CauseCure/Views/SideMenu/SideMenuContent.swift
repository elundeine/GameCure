//
//  SideMenuContent.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 20.12.20.
//

import SwiftUI

struct SideMenuContent: View {
        var body: some View {
            List {
                Text("My Profile").onTapGesture {
                    print("My Profile")
                }
                Text("Posts").onTapGesture {
                    print("Posts")
                }
                Text("Logout").onTapGesture {
                    print("Logout")
                }
            }
        }
    }

struct SideMenuContent_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuContent()
    }
}
