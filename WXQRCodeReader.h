//
//  WXQRCodeReader.h
//
//  Created by vencentle on 14-4-12.
//  Copyright (c) 2014年 vencentle. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol  WXQRCodeReaderDelegate;

@interface WXQRCodeReader : NSObject

+ (WXQRCodeReader *)sharedReader;

- (void)begainQRCodeScanWithView:(UIView *)view;

@property (strong, nonatomic) id<WXQRCodeReaderDelegate> delegate;

@end

@protocol WXQRCodeReaderDelegate <NSObject>

- (void)readError:(NSError *)error
           reader:(WXQRCodeReader *)reader;

- (void)readSuccessWithInfo:(NSDictionary *)info
                     reader:(WXQRCodeReader *)reader;
@end
