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

// http://www.ignaciomellado.es/blog/Measuring-heart-rate-with-a-smartphone-camera
@interface HeartRateKitAlgorithm : NSObject

//Properties
@property (nonatomic , readonly) int framesCounter;
@property (nonatomic , readwrite) CGFloat frameRate;// the frame rate of the video
@property (nonatomic , readwrite) int windowSize;// size in frames
@property (nonatomic , readwrite) int filterWindowSize;// duration in frames
@property (nonatomic , readwrite) int calibrationDuration;// duration in frames
@property (nonatomic , readwrite) int windowSizeForAverageCalculation;// size must be <= calibrationDuration

@property (nonatomic , readwrite) double ** buttterworthValues;

//
- (CGFloat)getColorValueFrom:(UIColor *)color;

// outside API
@property (nonatomic , readonly) BOOL isCalibrationOver;
@property (nonatomic , readonly) BOOL isFinalResultDetermined;
@property (nonatomic , readonly) CGFloat bpmLatestResult;

@property (nonatomic, readonly) BOOL isPeakInLastFrame;
@property (nonatomic, readonly) BOOL isMissedTheLastPeak;

@property (nonatomic , readonly) BOOL shouldShowLatestResult;

// the method to be called on each frame
- (void)newFrameDetectedWithAverageColor:(UIColor *)color;

@end
