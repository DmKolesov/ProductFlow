//
//  ProfitableSectionView.swift
//  ProductFlow
//
//  Created by Dima Kolesov on 08.10.2024.
//

import SwiftUI

struct ProfitableSectionView: View {
    
    //@Observed vm
    var body: some View {
        VStack(alignment: .leading) {
           Text("Выгодно и вкусно")
                .font(.system(size: 24, weight: .bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Text("Выгодно и вкусно")
                     
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

#Preview {
    ProfitableSectionView()
}
