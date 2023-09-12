//
//  ContentView.swift
//  Mega Numeros
//
//  Created by Leonardo Fernandes on 09/09/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var numerosSorteados: [Int] = []
    @State private var sorteando = false
    @State private var showingWebView = false
    @State private var webURL = "https://loterias.caixa.gov.br/Paginas/App/Mega-Sena.aspx"

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Text("Mega-Sena")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()

                if numerosSorteados.count == 6 {
                    Text("Números Sorteados:")
                        .font(.headline)
                        .foregroundColor(.blue)

                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(numerosSorteados, id: \.self) { numero in
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text("\(numero)")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                                .padding(10)
                        }
                    }
                    .transition(.move(edge: .bottom))
                } else {
                    Text("Pressione para sortear")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .opacity(sorteando ? 0 : 1)
                        .transition(.opacity)
                }

                Button(action: {
                    sorteando.toggle()
                    self.sortearNumeros()
                }) {
                    Text(sorteando ? "Sorteando..." : "Sortear Números")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .shadow(color: .blue, radius: 5, x: 0, y: 5)
                        .disabled(sorteando)
                }
                .padding()
                .transition(.scale)

                Button(action: {
                    showingWebView.toggle()
                }) {
                    Text("Ver Resultado e Prêmio")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .opacity(numerosSorteados.count == 6 ? 1 : 0)
                        .transition(.opacity)
                }
                .sheet(isPresented: $showingWebView) {
                    NavigationView {
                        WebView(urlString: webURL)
                            .navigationBarTitle("Resultado")
                            .navigationBarItems(trailing: Button("Fechar") {
                                showingWebView.toggle()
                            })
                    }
                }
            }
        }
    }

    func sortearNumeros() {
        DispatchQueue.global(qos: .background).async {
            var numeros = Array(1...60)
            numeros.shuffle()
            let numerosSorteados = Array(numeros.prefix(6))
            self.numerosSorteados = numerosSorteados.sorted()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                sorteando.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
