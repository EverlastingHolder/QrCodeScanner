//
//  ContentViewModel.swift
//  QrCodeScanner
//
//  Created by Роман Мошковцев on 30.06.2021.
//

import Foundation
import Combine

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var isPresent: Bool = false
        @Published var isError: Bool = false
    }
}

