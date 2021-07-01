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
                QrScannerView { response in
                    switch response {
                    case .success(let result):
                        openURL(URL(string: result)!) { result in
                            if !result {
                                viewModel.errorTitle = "Error URL"
                                viewModel.errorMessage = "Invalid URL"
                                viewModel.isError = true
                            }
                        }
                        viewModel.isPresent = false
                    case .failure(_):
                        viewModel.errorTitle = "Error"
                        viewModel.errorMessage = "Something went wrong"
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
            Alert(
                title: Text(viewModel.errorTitle),
                message: Text(viewModel.errorMessage)
            )
        }
    }
}
