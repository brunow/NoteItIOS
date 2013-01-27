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

/*
 * Check if the device is running on ipad or not
 *      @return YES if device is ipad
 */
BOOL BKIsPad(void);

BOOL BKIsMultitaskingSupported(void);

BOOL BKIsCameraAvailable(void);

BOOL BKDoesCameraSupportShootingVideos(void);

BOOL BKDoesCameraSupportTakingPhotos(void);

BOOL BKIsFrontCameraAvailable(void);

BOOL BKIsRearCameraAvailable(void);

BOOL BKIsFlashAvailableOnFrontCamera(void);

BOOL BKIsFlashAvailableOnRearCamera(void);

BOOL BKIsRetinaDisplay(void);