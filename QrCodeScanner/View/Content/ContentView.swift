//
//  ContentView.swift
//  QrCodeScanner
//
//  Created by Роман Мошковцев on 30.06.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject private var viewModel: Self.ViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Scanning for QR-codes")
                .font(.subheadline)
            Spacer()
            
            Button(action: {
                viewModel.isPresent = true
            }) {
                Text("Scanner QR-Code")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.isPresent) {
            ZStack {
                QrScannerView(codeTypes: [.qr]) { response in
                    switch response {
                    case .success(let result):
                        openURL(URL(string: result)!)
                        viewModel.isPresent = false
                    case .failure(_):
                        viewModel.isError = true
                    }
                }
                VStack{
                    Spacer()
                    Button(action: {
                        viewModel.isPresent = false
                    }) {
                        Text("Close")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }.padding()
            }
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text("Error"), message: Text("Something went wrong"))
        }
    }
}
