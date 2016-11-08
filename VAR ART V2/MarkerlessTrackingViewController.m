//
//  MarkerlessTrackingViewController.m
//  VAR ART V2
//
//  Created by Ryan Jones on 11/7/16.
//  Copyright © 2016 Ryan Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarkerlessTrackingViewController.h"
#import "InstructionLabel.h"
//need to add instruction label

typedef NS_ENUM(NSInteger, ArbiTrackState) {
    ARBI_Placement,
    ARBI_Tracking,
};

@interface MarkerlessTrackingViewController () {
    ArbiTrackState _arbitButtonState;
    float _lastScale;
    float _lastPanX;
}

@property (nonatomic) ARModelNode *modelNode;
@property (nonatomic) InstructionLabel *Label;

@end

@implementation MarkerlessTrackingViewController

- (void)setupContent {
    [self setupModel];
    [self setupArbiTrack];
    [self setupLabel];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(arbiPinch:)];
    [self.cameraView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(arbiPan:)];
    [self.cameraView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arbiTap:)];
    [self.cameraView addGestureRecognizer:tapGesture];
}

//we need to compartmentalize this to each art piece
- (void)setupModel {
    //need to add the model to the string
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"X.armodel"];
    ARModelNode *modelNode = [importer getNode];
    
    //need to add the image
    ARLightMaterial *material = [ARLightMaterial new];
    material.colour.texture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"image.png"]];
    material.diffuse.value = [ARVector3 vectorWithValuesX:0.2 y:0.2 z:0.2];
    material.ambient.value = [ARVector3 vectorWithValuesX:0.8 y:0.8 z:0.8];
    material.specular.value = [ARVector3 vectorWithValuesX:0.3 y:0.3 z:0.3];
    material.shininess = 20;
    material. reflection.reflectivity = 0.15;
    
    for (ARMeshNode *meshNode in modelNode.meshNodes) {
        meshNode.material = material;
    }
    
    self.modelNode = modelNode;
}

- (void)setupArbiTrack {
    ARGyroPlaceManager *gyroPlaceManager = [ARGyroPlaceManager getInstance];
    [gyroPlaceManager initialise];
    
    ARNode *targetNode = [ARNode nodeWithName:@"targetNode"];
    [gyroPlaceManager.world addChild:targetNode];
    
    //if we want to add a target before it gets placed
    ARImageNode *targetImageNode = [[ARImageNode alloc] initWithImage:[UIImage imageNamed:@"target.png"]];
    [targetNode addChild:targetImageNode];
    
    [targetImageNode scaleByUniform:0.1];
    [targetImageNode rotateByDegrees:90 axisX:1 y:0 z:0];
    
    ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
    [arbiTrack initialise];
    
    arbiTrack.targetNode = targetNode;
    
    [arbiTrack.world addChild:_modelNode];
}

- (void)setupLabel {
    dispatch_async(dispatch_get_main_queue(), ^{
        instructionLabel *label = [[InstructionLabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        label.text = @"Tap screen to place model";
        [self.view addSubview:label];
        [label constrainInview:self.view];
        self.label = label;
    });
}

- (void)arbiTap:(UITapGestureRecognizer *)gesture {
    ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
    if (_arbitButtonState == ARBI_Placement) {
        [arbiTrack start];
        arbiTrack.targetNode.visible = NO;
        self.modelNode.scale = [ARVector3 vectorWithValuesX:1 y:1 z:1];
        _arbitButtonState = ARBI_Tracking;
        self.label.text = @"Pinch and pan to scale/rotate";
        return;
    } else if (_arbitButtonState == ARBI_Tracking) {
        [arbiTrack stop];
        arbiTrack.targetNode.visible = YES;
        _arbitButtonState = ARBI_Placement;
        self.label.text = @"Tap the screen to place the model";
        return;
    }
}

- (void)arbiPinch: (UIPinchGestureRecognizer *) gesture {
    float scaleFactor = gesture.scale;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastScale = 1;
    }
    scaleFactor = 1 - (_lastScale - scaleFactor);
    _lastScale = gesture.scale;
    @synchronized ([ARRenderer getInstance]) {
        [self.modelNode scaleByUniform:scaleFactor];
    }
}

- (void)arbiPan: (UIPanGestureRecognizer *) gesture {
    float panLocation = [gesture translationInView:self.cameraView].x;
    if (gesture.state == UIGestureRecognizerStateBegan){
        _lastPanX = panLocation;
    }
    float diff = panLocation - _lastPanX;
    float deg = diff * 0.5;
    @synchronized ([ARRenderer getInsance]) {
        [self._modelNode rotateByDegrees:deg axisX:0 y:1 z:0];
    }
    _lastPanX = panLocation;
}

+ (NSString *)getExampleName {
    return @"Markerless Tracking";
}

+ (NSInteger)getExampleImportance {
    return 5;
}


@end
