//
//  AddImagesView.h
//  Macinator
//
//  Created by Tulakshana on 26/10/2011.
//  Copyright (c) 2011 Eugein. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AddImagesView : NSView{
    NSString *type;
    NSMutableArray *_files;
    IBOutlet NSTextField *dropAreaText,*txtWidth,*txtHeight,*txtAppend,*txtRemove,*txtChangeExt;

}

@property (nonatomic,retain) NSMutableArray *files;

- (IBAction)setJPG:(id)sender;
- (IBAction)setPNG:(id)sender;
- (IBAction)convert:(id)sender;
- (IBAction)resize:(id)sender;
- (IBAction)append:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)changeExtension:(id)sender;
- (IBAction)removeExtension:(id)sender;
@end
