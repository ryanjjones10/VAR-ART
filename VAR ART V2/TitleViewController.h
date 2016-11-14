//
//  TitleViewController.h
//  VAR ART V2
//
//  Created by Ryan Jones on 11/13/16.
//  Copyright © 2016 Ryan Jones. All rights reserved.
//

#ifndef TitleViewController_h
#define TitleViewController_h

#import <UIKit/UIKit.h>

@protocol KudanExamplesProtocol <NSObject>

@required

+ (NSString *)getExampleName;
+ (NSInteger)getExampleImportance;

@end

@interface TitleViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *codeExamples;

@end

#endif /* TitleViewController_h */
