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
 * The floor picker control is shown whenever a museum has more than one
 * level.
 *
 * @note If a museum has only one level, the floor picker control will be
 * hidden automatically. To override this behavior, set 
 * \c hidden property to \c NO.
 */
@interface TCFloorPickerView : UIView

/**
 * The delegate object that will receive callback of \c TCFloorPickerView events.
 */
@property (nonatomic, weak) id<TCFloorPickerViewDelegate> delegate;

/**
 * Returns the museum that this floor picker was created for.
 */
@property (nonatomic, strong, readonly) TCMuseum *museum;

/**
 * Returns the currently selected floor of the museum.
 *
 * The \c selectedFloor property will be set to the museum's \c defaultFloor
 * property when the museum is first displayed.
 */
@property (nonatomic, strong, readonly) TCMuseumFloor *selectedFloor;

/**
 * Initializes the floor picker control with the given museum.
 * The floor picker control can then be used to select different floors
 * in this museum.
 *
 * @param museum The \c TCMuseum model object describing the museum.
 *
 * @return An initialized \c TCFloorPickerView control.
 */
- (id)initWithMuseum:(TCMuseum *)museum;

@end
