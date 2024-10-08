//
//  OfferSectionView.swift
//  ProductFlow
//
//  Created by Dima Kolesov on 08.10.2024.
//

import SwiftUI

struct OfferSectionView: View {
    
    // ViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<10, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                }
                .onTapGesture {
                    // vm navigate
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    OfferSectionView()
        .background(Color.gray)
}
