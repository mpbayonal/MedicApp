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

#import "ViewController.h"
#import "HeartRateKit.h"


@interface ViewController ()<HeartRateKitControllerDelegate>

@end

@implementation ViewController



-(IBAction)startMonitor:(id)sender {
    #if TARGET_OS_SIMULATOR
    [self presentAlert:@"Este código solo funciona en el dispositivo. ¡Lo siento!"];
    #else
    HeartRateKitController *controller = [[HeartRateKitController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    #endif
}

-(void)presentAlert:(NSString *)message {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// HeartRateKitControllerDelegate methods
- (void)heartRateKitController:(HeartRateKitController *)controller didFinishWithResult:(HeartRateKitResult *)result {
    NSString *messageToDisplay = [NSString stringWithFormat:@"LPM : %.01f", result.bpm];
    
    
    
    
  //  [[[[[self.ref child:@"users"] child:@"44"] child:@"44"] child:@"frecuencia_Cardiaca"]
  //  setValue:@{@"bpm": [NSString stringWithFormat:@"BPM : %.01f", result.bpm]}];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentAlert:messageToDisplay];
    }];
}

- (void)heartRateKitControllerDidCancel:(HeartRateKitController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
