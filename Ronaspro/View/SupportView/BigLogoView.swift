//
//  BigLogoView.swift
//  Ronaspro
//
//  Created by Sergey Volkov on 25.01.2021.
//

import SwiftUI

struct BigLogoView: View {
    
    @State var width: CGFloat
    @State var height: CGFloat
    @State var font: Font
    @State var textPadding: CGFloat
    @State var textLogo: String
    
    var body: some View {
        VStack {
            Image("ronaspro")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height, alignment: .center)
            Text(textLogo)
                .padding(textPadding)
                .foregroundColor(Color.accentColor)
                .font(font)
        }
    }
}
//
//struct BigLogoView_Previews: PreviewProvider {
//    static var previews: some View {
//        BigLogoView(width: 100, height: 100, font: .title2, textPadding: 0, textLogo: "РОНАСПРО")
//    }
//}
