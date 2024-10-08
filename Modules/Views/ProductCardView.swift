//
//  ProductCardView.swift
//  ProductFlow
//
//  Created by Dima Kolesov on 08.10.2024.
//

import SwiftUI

struct ProductCardView: View {
    
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(" viewModel. ")
                    .font(.headline)
                
                Text(" viewModel. ")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text(" ViewModel acting")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ProductCardView()
}
