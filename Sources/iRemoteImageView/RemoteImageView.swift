//
//  RemoteImageView.swift
//  iPenOfDestiny
//
//  Created by eagle two on 2020/03/12.
//  Copyright © 2020 isshie. All rights reserved.
//
        

import SwiftUI
// RemoteImageFetcherから取得したデータまたは初期化中に提供されたplaceholderのいずれかでimageをレンダリングするSwiftUI viewが含まれています
public struct RemoteImageView<Content: View>: View {
    // remote image view には、remote image fetcher、viewのコンテンツ、placeholder imageを保持する property が含まれています。
    @ObservedObject var imageFetcher: RemoteImageFetcher
    var content: (_ image: Image) -> Content
    let placeHolder: Image
    
    // 表示された以前のURLへの reference とimage dataを保持する State
    @State var previousURL: URL? = nil
    @State var imageData: Data = Data()
    
    // placeholder image、 remote image fetcher、およびImageを受け取る closure で初期化されます。
    public init(
        placeHolder: Image,
        imageFetcher: RemoteImageFetcher,
        content: @escaping (_ image: Image) -> Content
    ) {
        self.placeHolder = placeHolder
        self.imageFetcher = imageFetcher
        self.content = content
    }
    
    // fetcherからURLとimage data property を取得し、returnする前にローカルに保存します。
    public var body: some View {
        DispatchQueue.main.async {
            if (self.previousURL != self.imageFetcher.getUrl()) {
                self.previousURL = self.imageFetcher.getUrl()
            }
            
            if (!self.imageFetcher.imageData.isEmpty) {
                self.imageData = self.imageFetcher.imageData
            }
        }
        
        let uiImage = imageData.isEmpty ? nil : UIImage(data: imageData)
        let image = uiImage != nil ? Image(uiImage: uiImage!) : nil;
        
        // imageまたはplaceholderのいずれかを含むZStack。このスタックは、表示されるときにprivate method loadImageを呼び出します。
        return ZStack() {
            if image != nil {
                content(image!)
            } else {
                content(placeHolder)
            }
        }
        .onAppear(perform: loadImage)
    }
    
    // image fetcherにimage dataを取得するよう要求します。
    private func loadImage() {
        imageFetcher.fetch()
    }
}
