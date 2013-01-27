//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BaseKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "BKDeviceAvailability.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsPad(void) {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsMultitaskingSupported(void) {
    return [[UIDevice currentDevice] isMultitaskingSupported];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsCameraAvailable(void) {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKDoesCameraSupportShootingVideos(void) {
    //[UIImagePickerController cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKDoesCameraSupportTakingPhotos(void) {
    //return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsFrontCameraAvailable(void) {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsRearCameraAvailable(void) {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsFlashAvailableOnFrontCamera(void) {
    return [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceFront];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsFlashAvailableOnRearCamera(void) {
    return [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceRear];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
BOOL BKIsRetinaDisplay(void) {
    return ([UIScreen instancesRespondToSelector:@selector(scale)] &&
            [[UIScreen mainScreen] scale] == 2.0);
}
