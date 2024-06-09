//
//  ContentView.swift
//  MyMap
//
//  Created by Otsuka on 2024/06/09.
//

import SwiftUI

struct ContentView: View {
    // 入力中の文字列を格納する状態変数
    @State var inputText: String = ""
    // 検索キーワードを格納する状態変数
    @State var displaySearchKey: String = "Tokyo Station"
    // マップの種類を格納する状態変数
    @State var displayMapType: MapType = .standard
    
    var body: some View {
        VStack{
            // 引数に状態変数を指定するときは先頭に$をつける
            TextField("Key words", text: $inputText, prompt: Text("Put some key words"))
                // ユーザが改行を行ったタイミングでブロック内のコードを実行
                .onSubmit {
                    displaySearchKey = inputText
                }
                .padding()
            ZStack(alignment: .bottomTrailing) {
                
                MapView(searchKey: displaySearchKey, mapType: displayMapType)
                
                Button {
                    if displayMapType == .standard {
                        displayMapType = .satellite
                    } else if displayMapType == .satellite {
                        displayMapType = .hybrid
                    } else {
                        displayMapType = .standard
                    }
                } label: {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                }
                .padding(.trailing, 20.0)
                .padding(.bottom, 30.0)
            }
        }
    }
}

#Preview {
    ContentView()
}
