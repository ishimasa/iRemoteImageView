//
//  RemoteImageFetcher.swift
//  iPenOfDestiny
//
//  Created by eagle two on 2020/03/12.
//  Copyright © 2020 isshie. All rights reserved.
//
        

import SwiftUI
// observable objectであるRemoteImageFetcherと呼ばれるクラスを定義します。
public class RemoteImageFetcher: ObservableObject {
    @Published var imageData = Data()
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    // URLSessionを使用して data を取得し、結果をobject imageDataとして設定するfetch method。
    public func fetch() {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
    
    // image dataを取得するためのメソッド
    public func getImageData() -> Data {
        return imageData
    }
    
    // URLを取得するためのメソッド
    public func getUrl() -> URL {
        return url
    }
    // image dataを削除
    public func purge() {
      imageData = Data()
    }
}
