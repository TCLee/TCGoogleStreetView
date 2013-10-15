//
//  TCStreetViewController.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@import UIKit;

@class TCMuseumDataController;

#import "TCFloorPickerView.h"

/**
 * This view controller manages a GMSPanoramaView instance that displays 
 * street views of the museums.
 */
@interface TCStreetViewController : UIViewController
    <GMSPanoramaViewDelegate, TCFloorPickerViewDelegate, UIGestureRecognizerDelegate>

/** The data controller that manages the TCMuseum model objects. */
@property (nonatomic, strong) TCMuseumDataController *dataController;

@end