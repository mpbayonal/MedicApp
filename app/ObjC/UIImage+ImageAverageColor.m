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

#import "UIImage+ImageAverageColor.h"

@implementation UIImage (ImageAverageColor)

- (UIColor *)hrkAverageColorPrecise
{
    CGImageRef rawImageRef = self.CGImage;
    
    // This function returns the raw pixel values
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);
    
    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
	NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;
    
    // Here I sort the R,G,B, values and get the average over the whole image
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
	for (int row = 0; row < imageHeight; row++) {
		const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
		for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[2];
            green  += rowPtr[1];
            blue   += rowPtr[0];
			rowPtr += stride;
            
        }
    }
	CFRelease(data);
    
	CGFloat f = 1.0f / (255.0f * imageWidth * imageHeight);
	return [UIColor colorWithRed:f*red  green:f*green blue:f*blue alpha:1];
}

// should be at least four time faster than hrkAverageColorPrecise
// but the result isn't accurate, color values only given in integers (if multiplied by 255.0f)
- (UIColor *)hrkAverageColor
{
    CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
	uint8_t *data = CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed:data[0] / 255.0f
									 green:data[1] / 255.0f
									  blue:data[2] / 255.0f
									 alpha:data[3]];
	UIGraphicsEndImageContext();
	return color;
    
    // another implemention that should work on every UIImage
    /*
     CGImageRef rawImageRef = [self CGImage];
     
     // scale image to an one pixel image
     
     uint8_t  bitmapData[4];
     int bitmapByteCount;
     int bitmapBytesPerRow;
     int width = 1;
     int height = 1;
     
     bitmapBytesPerRow = (width * 4);
     bitmapByteCount = (bitmapBytesPerRow * height);
     memset(bitmapData, 0, bitmapByteCount);
     CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
     CGContextRef context = CGBitmapContextCreate (bitmapData,width,height,8,bitmapBytesPerRow,
     colorspace,kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
     CGColorSpaceRelease(colorspace);
     CGContextSetBlendMode(context, kCGBlendModeCopy);
     CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
     CGContextDrawImage(context, CGRectMake(0, 0, width, height), rawImageRef);
     CGContextRelease(context);
     return [UIColor colorWithRed:bitmapData[2] / 255.0f
     green:bitmapData[1] / 255.0f
     blue:bitmapData[0] / 255.0f
     alpha:1];
     */
}

@end
