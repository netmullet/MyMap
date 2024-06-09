//
//  MapView.swift
//  MyMap
//
//  Created by Otsuka on 2024/06/09.
//

import SwiftUI
import MapKit
// マップの種類を管理する列挙型を宣言
enum MapType {
    case standard
    case satellite
    case hybrid
}

struct MapView: View {
    
    let searchKey: String
    
    let mapType: MapType
    // 経緯度を格納する位置座標オブジェクトの作成
    @State var targetCoordinate = CLLocationCoordinate2D()
    // 表示するマップの位置を設定
    @State var cameraPosition: MapCameraPosition = .automatic
    
    var mapStyle: MapStyle {
        switch mapType {
        case .standard:
            return MapStyle.standard()
        case .satellite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }
    
    var body: some View {
        
        Map(position: $cameraPosition){ // クロージャ
            // ピンを表示する
            Marker(searchKey, coordinate: targetCoordinate)
        }
        // マップのスタイルを指定
        .mapStyle(mapStyle)
        // 検索キーワードの変更を検知
        .onChange(of: searchKey, initial: true) { oldValue, newValue in
            print("search word: \(searchKey)")
            // 地図の検索クエリの作成
            let request = MKLocalSearch.Request()
            // 検索クエリにキーワードを設定
            request.naturalLanguageQuery = newValue
            // MKLocalSearch（地図の検索をするためのオブジェクト）の初期化
            let search = MKLocalSearch(request: request)
            // 検索の開始
            search.start { response, error in
                // 検索結果が存在する場合は、1件目を取り出す
                // Optional Chainingを用いてnilでない場合は代入する
                if let mapItems = response?.mapItems,
                   let mapItem = mapItems.first {
                    // 検索結果から経緯度を取り出す
                    targetCoordinate = mapItem.placemark.coordinate
                    print("latitude and longitude:\(targetCoordinate)")
                    // MapKitのregionメソッドで表示するマップの領域を作成
                    cameraPosition = .region(MKCoordinateRegion(
                        center: targetCoordinate,
                        latitudinalMeters: 500.0,
                        longitudinalMeters: 500.0
                    ))
                }
            }
        }
    }
}

#Preview {
    MapView(searchKey: "Narita", mapType: .standard)
}
