//
//  Utils.swift
//  iCalories
//
//  Created by Esad Dursun on 30.06.23.
//

import SwiftUI

struct DismissKeyboardModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                endEditing()
            }
    }

    private func endEditing() {
        UIApplication.shared.windows
            .first { $0.isKeyWindow }?
            .endEditing(true)
    }
}
