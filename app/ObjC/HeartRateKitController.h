/*
 https://github.com/ItamarM/HeartRate-iOS-SDK
 MIT License
 
 Copyright (c) 2017 Itamar
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE. */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeartRateKitResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HeartRateKitControllerDelegate;

@interface HeartRateKitController : UIViewController
@property(nullable,nonatomic,weak) id <HeartRateKitControllerDelegate> delegate;
@end

@protocol HeartRateKitControllerDelegate<NSObject>
@optional
// The controller does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)heartRateKitController:(HeartRateKitController *)controller didFinishWithResult:(HeartRateKitResult *)result;
- (void)heartRateKitControllerDidCancel:(HeartRateKitController *)controller;

@end

NS_ASSUME_NONNULL_END
