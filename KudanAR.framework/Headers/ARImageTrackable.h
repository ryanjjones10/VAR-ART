#import <Foundation/Foundation.h>
@class UIImage;
@class ARNode;

/**
 This class represents an image that can be tracked. The ARImageTrackerManager will automatically update properties. Attach content to the world property to have it rendered on the trackable.
 */
@interface ARImageTrackable : NSObject

/**
 Tracking events.
 */
typedef NS_ENUM(NSInteger, ARImageTrackableEvents) {
    /**
     The first frame a marker has been detected following a frame with no tracking.
     */
    ARImageTrackableEventDetected,
    /**
     A previously tracked marker was lost.
     */
    ARImageTrackableEventLost,
    /**
     Marker was tracked. This can be sent in the same frame as ARImageTrackableEventDetected.
     */
    ARImageTrackableEventTracked,
};

/**
 Initialises this object with trackable file.
 @param path The full path to the trackable file. This file should have been generated by the marker conversion tool.
 @return the initialised object.
 */
- (instancetype)initWithPath:(NSString *)path;

/**
 Initialises this object with an image file.
 @param bundledFile The full path to the trackable file. This file should have been generated by the marker conversion tool.
 @return the initialised object.
 */
- (instancetype)initWithBundledFile:(NSString *)bundledFile;

/**
 Initialises this object with an image.
 @param image a UIImage representing the image to create this trackable from.
 @return the initialised object.
 */
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name;
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name width:(int)width height:(int)height;

/**
 The name of this trackable. This needs to be unique. If initialised from a trackable file then it is read in automatically.
 */
@property (nonatomic) NSString *name;

/**
 The scene width of this trackable. This can be arbitrary but is used to determine the scale of the coordinate system that is attached to this node.
 */
@property (nonatomic) int width;

/**
 The scene height of this trackable. This can be arbitrary but is used to determine the scale of the coordinate system that is attached to this node.
 */
@property (nonatomic) int height;

/**
 Whether this trackable is currently detected or not. Automatically controlled by the tracker.
 */
@property (nonatomic, readonly) BOOL isDetected;

/**
 The node whose transformation is automatically updated by the tracker to represent the trackable's pose in the camera image. Content can be attached here.
 */
@property (nonatomic) ARNode *world;
@property (nonatomic) ARNode *worldYUp;
@property (nonatomic) ARNode *touchableNode;

/**
 Add an action for a certain tracking event.
 @param target The target object to receive the event.
 @param action The action to get called on the target. It will get called with a single argument - the ARImageTrackable that triggered the event.
 @param forEvent The event type of interest.
 */
- (void)addTrackingEventTarget:(id)target action:(SEL)action forEvent:(ARImageTrackableEvents)event;

/**
 Remove an existing tracking target.
 @param target The target object to receive the event.
 @param action The action to get called on the target. It will get called with a single argument - the ARImageTrackable that triggered the event.
 @param forEvent The event type of interest.
 */
- (void)removeTrackingEventTarget:(id)target action:(SEL)action forEvent:(ARImageTrackableEvents)event;

/**
 The set of all tracking targets. Contains NSDictionary objects of target, action and forEvent keys.
 */
- (NSSet *)allTrackingEventTargets;




// ** New computer vision features **

/**
 Set this marker to use flow recovery, if the global setting is switched on (default to global setting)
 */
- (void)allowRecoveryMode;

/**
 Make this marker use flow recovery irrespective of the global setting 
 */
- (void)forceRecoveryMode;

/** 
 Prevent this marker from using flow recovery, irrespective of the global setting 
 */
- (void)prohibitRecoveryMode;


@end