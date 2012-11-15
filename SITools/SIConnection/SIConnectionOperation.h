//
//  SIConnectionOperation.h
//  SIOperation
//
//  Created by KUROSAKI Ryota on 2011/04/27.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIBaseOperation.h"

@interface SIConnectionOperation : SIBaseOperation

@property(nonatomic,readonly) NSURLRequest *request;           ///< 通信リクエスト.
@property(nonatomic,assign) NSTimeInterval timeoutInterval;    ///< タイムアウト値. setHTTPBody:を行うとNSURLRequestのタイムアウトが効かなくなるのでこれを使用すること.

@property(nonatomic,readonly) NSURLResponse *response;         ///< 受信したレスポンス.
@property(nonatomic,readonly) NSHTTPURLResponse *httpResponse; ///< 受信したHTTPレスポンス.
@property(nonatomic,readonly) NSError *error;                  ///< 通信error時のNSErrorインスタンス.
@property(nonatomic,readonly) BOOL errorOccurd;                ///< エラーが発生した場合YES. 通信error発生またはhttpResponseのstatusCode!=200の場合エラーと判定する.
@property(nonatomic,readonly) long long currentContentLength;  ///< ダウンロード済みデータ長.
@property(nonatomic,readonly) float downloadedProgress;        ///< ダウンロード進捗率. totalLengthがわからない場合nanを返す.

@property(nonatomic,assign) BOOL storeToDisk;                  ///< ダウンロードデータをファイルに保存する場合 YES, メモリ上で保持する場合 NO.
@property(nonatomic,copy) NSString *downloadedFilePath;        ///< ダウンロードデータをファイルに保存する場合の保存先ファイルパス.
@property(nonatomic,readonly) NSMutableData *downloadedData;   ///< これまでに受信した通信データ.

@property(nonatomic,assign) BOOL disableRedirect;

@property(nonatomic,copy) void (^receiptResponse)(SIConnectionOperation *connection); ///< レスポンス受信時のcallback block.
@property(nonatomic,copy) void (^receiptData)(SIConnectionOperation *connection, NSData *receiveData);         ///< データ受信時のcallback block.
@property(nonatomic,copy) void (^completionConnection)(SIConnectionOperation *connection); ///< ダウンロード完了時のcallback block.

// 通信requestで初期化
- (id)initWithURL:(NSURL *)URL;
- (id)initWithURLRequest:(NSURLRequest *)URLRequest;
- (id)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;

// 通信キャンセル、キャンセル時はdelegateが呼ばれない
- (void)cancel;

- (void)removeDownloadedFile;

@end
