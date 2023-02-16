//
//  HomeView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI


struct HomeView: View {
    
   @StateObject var db: UserDBViewModel
   @Environment(\.dismiss) var goBack
    
    var showHome = AuthorizationModel()

    var body: some View {
        
        VStack {
            HStack {
                Button {
                    AuthService.shared.signOut()
                    self.showHome.showHome.toggle()
                    goBack()
                } label: {
                    Text("Log out")
                        .foregroundColor(.blue)
                        .font(.system(size: 19).monospaced())
                }
                Spacer()
            }
            .padding()
            
            VStack {
                AsyncImage(url: db.someRandomImage) { image in
                    switch image {
                        
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 300, height: 300)
                            .shadow(color: .black.opacity(0.6), radius: 4, x: 4, y: 4)
                    case .failure:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
            }
            VStack (alignment: .leading) {
                VStack {
                    Text("Hello,")
                        .font(.system(size: 23).monospaced() .bold())
                    TextField("Name", text: $db.userDB.name)
                        .font(.system(size: 23).monospaced() .bold())
                }
                HStack {
                    Text("Phone +38")
                        .font(.system(size: 23).monospaced() .bold())
                    TextField("Phone", value: $db.userDB.phone, format: .number)
                        .font(.system(size: 23).monospaced() .bold())
                }
                HStack {
                   Text("Address:")
                        .font(.system(size: 23).monospaced() .bold())
                    TextField("Address", text: $db.userDB.address)
                        .font(.system(size: 23).monospaced() .bold())
                }
            }
            .padding()
        }
        .padding(.bottom, 160)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [.purple, .orange], startPoint: .bottomLeading, endPoint: .topTrailing))
        .onSubmit {
            db.setProfile()
        }
        .onAppear {
            db.getProfile()
        }
    }
}
//                      🔱
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
