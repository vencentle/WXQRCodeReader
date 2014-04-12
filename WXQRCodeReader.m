//
//  WXQRCodeReader.m
//
//  Created by vencentle on 14-4-12.
//  Copyright (c) 2014年 vencentle. All rights reserved.
//

#import "WXQRCodeReader.h"

@interface WXQRCodeReader()<AVCaptureMetadataOutputObjectsDelegate>

@property(strong, nonatomic) AVCaptureSession *session;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation WXQRCodeReader
@synthesize delegate = _delegate;

+ (instancetype)sharedReader
{
    static WXQRCodeReader *_reader = nil;
    if (!_reader) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _reader = [[WXQRCodeReader alloc] init];
        });
    }
    return _reader;
}

- (void)begainQRCodeScanWithView:(UIView *)view
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        if (_delegate && [_delegate respondsToSelector:@selector(readError:reader:)]) {
            [_delegate readError:error reader:self];
        }
        return;
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session addInput:input];
    [session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [preview setFrame:view.bounds];
    [view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    [session startRunning];
    self.session = session;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning]; self.session = nil;
    [self.previewLayer removeFromSuperlayer]; self.previewLayer = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (_delegate && [_delegate respondsToSelector:@selector(readSuccessWithInfo:reader:)]) {
            [_delegate readSuccessWithInfo:@{@"stringValue": obj.stringValue,@"type":obj.type} reader:self];
        }
    }
}



@end
