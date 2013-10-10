//
//  TCFloorPickerView.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCMuseum;
@class TCMuseumFloor;
@class TCFloorPickerView;

/**
 * Delegate for receiving TCFloorPickerView events.
 */
@protocol TCFloorPickerViewDelegate <NSObject>

/**
 * Tells the delegate that a new floor was selected.
 *
 * @param floorPickerView The \c TCFloorPickerView object informing the delegate about the new
 *                        floor selection.
 * @param floor The \c TCMuseumFloor model object that represents the selected floor.
 */
- (void)floorPickerView:(TCFloorPickerView *)floorPickerView didSelectFloor:(TCMuseumFloor *)floor;

@end

/**
 * The floor picker control allows the user to select different floors of 
 * a museum to view.
 *
 * To create a floor picker control:
 * \code
 * TCFloorPickerView *floorPicker = 
 *   [TCFloorPickerView alloc] initWithDelegate:self];
 * [self.view addSubview:floorPicker];
 * \endcode
 */
@interface TCFloorPickerView : UIView

/**
 * The delegate object that will receive callback of \c TCFloorPickerView events.
 */
@property (nonatomic, weak) id<TCFloorPickerViewDelegate> delegate;

/**
 * The museum that this floor picker is controlling the floors for.
 *
 * Set it to the museum that you want the floor picker to control the floors for.
 */
@property (nonatomic, strong) TCMuseum *museum;

/**
 * Returns the currently selected floor of the museum.
 *
 * The \c selectedFloor property will be set to the museum's \c defaultFloor
 * property when the museum is first displayed.
 */
@property (nonatomic, strong, readonly) TCMuseumFloor *selectedFloor;

/**
 * Initializes the floor picker control with the given delegate object.
 * The delegate object will be notified of the floor picker control's events.
 *
 * @param delegate A delegate object that conforms to \c TCFloorPickerViewDelegate protocol.
 *
 * @return An initialized \c TCFloorPickerView control that can be added to a view.
 */
- (id)initWithDelegate:(id<TCFloorPickerViewDelegate>)delegate;

@end
