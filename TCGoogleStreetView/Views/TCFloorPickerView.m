//
//  TCFloorPickerView.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCFloorPickerView.h"
#import "TCMuseum.h"
#import "TCMuseumFloor.h"
#import "UIButton+TCMuseumFloor.h"

@interface TCFloorPickerView ()

/**
 * The reference to the currently selected button.
 *
 * This is a \b weak reference because the \c UIButton has already been added
 * as our subview.
 */
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation TCFloorPickerView

#pragma mark - Initialize View

- (id)initWithMuseum:(TCMuseum *)museum
{
    // Frame size does not matter. We're using Auto Layout.
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _museum = museum;
        
        // Initialize this view's properties.
        [self initializeView];
        
        // Create a button for each floor in the museum.
        [self createButtonsWithFloors:_museum.floors];
        
        // Add the required auto layout constraints, so that the buttons
        // are in the correct position.
        [self configureConstraints];
    }
    
    return self;
}

/**
 * Initializes this view which acts as the container view for the buttons.
 */
- (void)initializeView
{
    // Semi-transparent Black Color
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.65f];
    self.opaque = NO;
    
    // Allow user to tap the buttons to select floors.
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    
    // Disable the autoresizing mask, otherwise it will interfere with
    // our custom auto layout constraints.
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Create Floor Buttons

/**
 * Create a \c UIButton for each \c TCMuseumFloor object in 
 * the \c floors array.
 *
 * @param floors The array of \c TCMuseumFloor objects.
 */
- (void)createButtonsWithFloors:(NSArray *)floors
{
    // Create a UIButton for each museum floor.
    for (TCMuseumFloor *floor in floors) {
        UIButton *button = [self buttonWithFloor:floor];
        [self addSubview:button];
    }
}

/**
 * Creates and returns a new \c UIButton that is associated with the given
 * museum floor.
 *
 * @param floor The \c TCMuseumFloor object to be associated with the \c UIButton.
 *
 * @return A new \c UIButton that when tapped will navigate to the given museum floor.
 */
- (UIButton *)buttonWithFloor:(TCMuseumFloor *)floor
{
    // Using UIButtonTypeCustom allows us to customize the button however we want.
    // It will not depend on the system's button appearance.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Add fixed size constraints to button.
    [self addSizeConstraints:CGSizeMake(45, 36) toButton:button];

    // Button's background is transparent.
    button.opaque = NO;
    button.backgroundColor = [UIColor clearColor];

    // When a floor button is not selected, we will use a duller color and font.
    NSAttributedString *defaultTitleStyle =
        [[NSAttributedString alloc] initWithString:floor.name
                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [button setAttributedTitle:defaultTitleStyle forState:UIControlStateNormal];
    
    // When a floor button is selected, we will bold its font and give it
    // a brighter color to make it stand out.
    NSAttributedString *selectedTitleStyle =
        [[NSAttributedString alloc] initWithString:floor.name
                                        attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                                     NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [button setAttributedTitle:selectedTitleStyle forState:UIControlStateSelected];
    
    // The action method to trigger when this floor button is tapped.
    [button addTarget:self
               action:@selector(selectFloor:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // Associate the given museum floor with this button.
    // This allows us to retrieve the museum floor in the action method.
    button.floor = floor;
    
    return button;
}

/**
 * Adds a size constraint to the given button.
 *
 * @param size The size to constraint \c button to.
 * @param button The \c UIButton to apply the size constraint to.
 */
- (void)addSizeConstraints:(CGSize)size toButton:(UIButton *)button
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(button);
    NSDictionary *metricsDictionary = @{@"width": @(size.width),
                                        @"height": @(size.height)};
    [button addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(width)]"
                                             options:0
                                             metrics:metricsDictionary
                                               views:viewsDictionary]];
    [button addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(height)]"
                                             options:0
                                             metrics:metricsDictionary
                                               views:viewsDictionary]];
}

/**
 * The action message that is sent when the floor button was tapped.
 *
 * @param sender The \c UIButton that was tapped.
 */
- (IBAction)selectFloor:(id)sender
{
    UIButton *newSelectedButton = (UIButton *)sender;
    
    // If button is already currently selected, we don't have to
    // do anything else.
    if (newSelectedButton.isSelected) { return; }
    
    // De-select the currently selected button.
    self.selectedButton.selected = NO;
    
    // Set the new button as the currently selected button.
    newSelectedButton.selected = YES;
    self.selectedButton = newSelectedButton;
    
    // Notify our delegate that a new floor was selected.
    [self.delegate floorPickerView:self didSelectFloor:newSelectedButton.floor];
}

#pragma mark - Auto Layout Constraints

- (void)configureConstraints
{
    // Create the views dictionary for the auto layout visual format string.
    NSDictionary *viewsDictionary =
        [self viewsDictionaryWithButtons:self.subviews];
 
    // Add the vertical layout constraints for the buttons in this view.
    [self addVerticalConstraintsWithViewsDictionary:viewsDictionary];
    
    // Add the horizontal layout constraints for the buttons in this view.
    [self addHorizontalConstraintsWithViewsDictionary:viewsDictionary];
}

/**
 * Creates and returns a new dictionary of views to be used in the
 * Auto Layout visual format string.
 *
 * The keys in the dictionary are created from the array index. 
 * Example of a returned dictionary:
 *
 * \code
 * @{@"button0": <UIButton>, 
 *   @"button1": <UIButton>, 
 *   @"button2": <UIButton>, ...}
 * \endcode
 *
 * @param buttons The array of \c UIButton view objects.
 *
 * @return A \c NSDictionary object representing the UIButton views in the
 *         visual format string.
 */
- (NSDictionary *)viewsDictionaryWithButtons:(NSArray *)buttons
{
    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc]
                                            initWithCapacity:buttons.count];
    
    [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
        NSString *key = [[NSString alloc] initWithFormat:@"button%lu", (unsigned long)index];
        viewsDictionary[key] = button;
    }];
    
    return [viewsDictionary copy];
}

/**
 * Add the required vertical layout constraints to this view.
 *
 * @param viewsDictionary A dictionary of views that appear in the visual format string.
 */
- (void)addVerticalConstraintsWithViewsDictionary:(NSDictionary *)viewsDictionary
{
    NSMutableString *verticalLayoutFormat =
    [[NSMutableString alloc] initWithString:@"V:|"];
    
    for (UIButton *button in [self.subviews reverseObjectEnumerator]) {
        [verticalLayoutFormat appendFormat:@"[button%lu]", (unsigned long)index];
    }
    [verticalLayoutFormat appendString:@"|"];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:verticalLayoutFormat
                                             options:NSLayoutFormatAlignAllLeading
                                             metrics:nil
                                               views:viewsDictionary]];
}

/**
 * Add the required horizontal layout constraints to this view.
 *
 * @param viewsDictionary A dictionary of views that appear in the visual format string.
 */
- (void)addHorizontalConstraintsWithViewsDictionary:(NSDictionary *)viewsDictionary
{
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
        NSString *horizontalLayoutFormat = [[NSString alloc] initWithFormat:
                                            @"H:|[button%lu]|", (unsigned long)index];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:horizontalLayoutFormat
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDictionary]];
    }];
}

@end
