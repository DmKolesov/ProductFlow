//
//  CustomSegmentPicker.swift
//  ProductFlow
//
//  Created by Dima Kolesov on 07.10.2024.
//

import SwiftUI

protocol SelectableOption: Hashable, CaseIterable {
    var title: String { get }
    var iconName: String { get }
}

enum DeliveryOption: String, CaseIterable, SelectableOption {
    case delivery = "Delivery"
    case inside = "Inside"
    
    var title: String {
        self.rawValue
    }
    
    var iconName: String {
        switch self {
            
        case .delivery:
            return "figure.walk"
        case .inside:
            return "fork.knife"
        }
    }
}


struct CustomSegmentPicker<Option: SelectableOption>: View {
    @Binding var selectedOption: Option
    
    var body: some View {
        Picker("", selection: $selectedOption) {
            ForEach(Array(Option.allCases), id: \.self) { option in
                HStack {
                    Image(systemName: option.iconName)
                    Text(option.title)
                }
                .tag(option)
                .modifier(SegmentedPickerItemModifier())
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .modifier(PickerContainerModifier())
    }
}

struct SegmentedPickerItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.primary)
            .padding(4)
            .background(
                Color.gray.opacity(0.2)
            )
            .clipShape(Capsule())
    }
}

struct PickerContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                Color.white
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
    }
}

//#Preview {
//    CustomSegmentPicker(selectedOption: .constant(DeliveryOption.inside))
//}





struct Home: View {
    
    @State var index = 0
    var body: some View {
        
        VStack {
            HStack(spacing: 0){
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(self.index == 0 ? .black : .gray)
                    Text("Person")
                        .foregroundColor(self.index == 0 ? .black : .gray)
                    
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .background((Color.white).opacity(self.index == 0 ? 1 : 0))
                .clipShape(Capsule())
                .onTapGesture {
                    self.index = 0
                }
                
                HStack{
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(self.index == 1 ? .black : .gray)
                    Text("More")
                        .foregroundColor(self.index == 1 ? .black : .gray)
                    
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .background((Color.white).opacity(self.index == 1 ? 1 : 0))
                .clipShape(Capsule())
                .onTapGesture {
                    self.index = 1
                }
            }
            .padding(3)
            .background(Color.black.opacity(0.06))
            .clipShape(Capsule())
            Spacer(minLength: 0)
        }
        .padding(.top)
    }
}
#Preview {
    Home()
}
