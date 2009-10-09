//
//  ClassroomAppDelegate.h
//  Classroom
//
//  Created by Adrian Smith on 10/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassroomViewController;

@interface ClassroomAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ClassroomViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ClassroomViewController *viewController;

@end

