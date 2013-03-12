//
//  AddImagesView.m
//  Macinator
//
//  Created by Tulakshana on 26/10/2011.
//  Copyright (c) 2011 Eugein. All rights reserved.
//

#import "AddImagesView.h"

#import "AppDelegate.h"

@implementation AddImagesView

@synthesize files = _files;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        type = @"png";
        
    }
    return self;
}

- (void)dealloc{
    type = nil;
    _files = nil;
    
    [super dealloc];
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
	sender = nil;
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSMutableArray *files1 = [pboard propertyListForType:NSFilenamesPboardType];
        pboard = nil;
        //		NSLog(@"file dropped; path = %@",[[files objectAtIndex:0] pathExtension]);
        for (int i = 0; i < [files1 count]; i++) {
            NSString *pathExtension = [[[files1 objectAtIndex:i] pathExtension]lowercaseString];
            if (![pathExtension isEqualToString:@"png"] && ![pathExtension isEqualToString:@"jpg"] && ![pathExtension isEqualToString:@"tiff"] && ![pathExtension isEqualToString:@"jpeg"]) {
                return NSDragOperationNone;
            }
        }
        
		files1 = nil;
    }
    
	return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
	sender = nil;
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        self.files = [pboard propertyListForType:NSFilenamesPboardType];
        [dropAreaText setStringValue:@"Image(s) dropped"];
        //		NSLog(@"file dropped; path = %@",[files objectAtIndex:0]);
        //		[infoVC selectFile:[files objectAtIndex:0]];

    }
    return YES;
}

- (IBAction)setJPG:(id)sender{
    type = @"jpg";
}

- (IBAction)setPNG:(id)sender{
    type = @"png";
}

- (IBAction)convert:(id)sender{
    NSProgressIndicator *progressView = [[NSProgressIndicator alloc]initWithFrame:NSMakeRect(98, 80, 20, 20)];
    [progressView setStyle:NSProgressIndicatorSpinningStyle];
    [progressView startAnimation:self];
    [self addSubview:progressView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"%@/ImageConvertor/",documentsDirectory];
//    NSLog(@"number of files %d",[_files count]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:url]) {
        [fileManager createDirectoryAtPath:url withIntermediateDirectories:TRUE attributes:nil error:nil];
	}
    
    BOOL copied = FALSE;
    
    
    
    for (int i = 0; i < [_files count]; i++) {
        NSString *imagePath = [_files objectAtIndex:i];
        if (imagePath != nil) {
            
            NSImage* image = [[NSImage alloc]initWithContentsOfFile:imagePath];
            NSArray*  representations  = [image representations];
            NSData* bitmapData;
            if ([type isEqualToString:@"png"]) {
                bitmapData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSPNGFileType properties:nil];
            }else{
                bitmapData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSJPEGFileType properties:nil];
            }
            
            NSArray *pathComponantsArray = [imagePath pathComponents];
            NSString *saveImageToPath = [NSString stringWithFormat:@"%@/%@.%@",url,[[pathComponantsArray lastObject] stringByDeletingPathExtension],type];
            copied = [bitmapData writeToFile:saveImageToPath atomically:YES];
            [image release];
            if (!copied) {
                break;
            }
        }
    }
    NSString *messageString = nil;
    if ([_files count] >0) {
        if (copied) {
            messageString = [NSString stringWithFormat:@"Image(s) were saved to the directory %@",documentsDirectory];
        }else{
            messageString = [NSString stringWithFormat:@"Image converter requires read/write access to the directory %@",documentsDirectory];
            
        }
    }else{
        messageString = @"Drag and drop image files to the drop area";
    }
    AppDelegate *appDelegate=(AppDelegate *)[[NSApplication sharedApplication]delegate];
    
    NSAlert *alertForNotSelectIcon = [[NSAlert alloc] init];
    [alertForNotSelectIcon addButtonWithTitle:@"OK"];
    [alertForNotSelectIcon addButtonWithTitle:@"Cancel"];
    [alertForNotSelectIcon setMessageText:@"Image Convertor"];
    [alertForNotSelectIcon setInformativeText:messageString];
    [alertForNotSelectIcon setAlertStyle:NSWarningAlertStyle];
    [alertForNotSelectIcon beginSheetModalForWindow:[appDelegate window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    [alertForNotSelectIcon release];

    [dropAreaText setStringValue:@"Drop image(s) (PNG/JPG/TIFF) here"];
    
    [_files removeAllObjects];

    [progressView removeFromSuperview];
    [progressView stopAnimation:self];
    [progressView release];

}

- (IBAction)append:(id)sender{
    NSProgressIndicator *progressView = [[NSProgressIndicator alloc]initWithFrame:NSMakeRect(98, 80, 20, 20)];
    [progressView setStyle:NSProgressIndicatorSpinningStyle];
    [progressView startAnimation:self];
    [self addSubview:progressView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"%@/ImageConvertor/",documentsDirectory];
    //    NSLog(@"number of files %d",[_files count]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:url]) {
        [fileManager createDirectoryAtPath:url withIntermediateDirectories:TRUE attributes:nil error:nil];
	}
    
    BOOL copied = FALSE;
    
    
    
    for (int i = 0; i < [_files count]; i++) {
        NSString *imagePath = [_files objectAtIndex:i];
        if (imagePath != nil) {
            
            NSImage* image = [[NSImage alloc]initWithContentsOfFile:imagePath];
            NSArray*  representations  = [image representations];
            NSData* bitmapData;
            NSString *fileType = [[imagePath pathExtension] lowercaseString];
            if ([fileType isEqualToString:@"png"]) {
                bitmapData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSPNGFileType properties:nil];
            }else{
                bitmapData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSJPEGFileType properties:nil];
            }
            
            NSArray *pathComponantsArray = [imagePath pathComponents];
            NSString *saveImageToPath = [NSString stringWithFormat:@"%@/%@%@.%@",url,[[pathComponantsArray lastObject] stringByDeletingPathExtension],txtAppend.stringValue,fileType];
            copied = [bitmapData writeToFile:saveImageToPath atomically:YES];
            [image release];
            if (!copied) {
                break;
            }
        }
    }
    NSString *messageString = nil;
    if ([_files count] >0) {
        if (copied) {
            messageString = [NSString stringWithFormat:@"Image(s) were saved to the directory %@",documentsDirectory];
        }else{
            messageString = [NSString stringWithFormat:@"Image converter requires read/write access to the directory %@",documentsDirectory];
            
        }
    }else{
        messageString = @"Drag and drop image files to the drop area";
    }
    AppDelegate *appDelegate=(AppDelegate *)[[NSApplication sharedApplication]delegate];
    
    NSAlert *alertForNotSelectIcon = [[NSAlert alloc] init];
    [alertForNotSelectIcon addButtonWithTitle:@"OK"];
    [alertForNotSelectIcon addButtonWithTitle:@"Cancel"];
    [alertForNotSelectIcon setMessageText:@"Image Convertor"];
    [alertForNotSelectIcon setInformativeText:messageString];
    [alertForNotSelectIcon setAlertStyle:NSWarningAlertStyle];
    [alertForNotSelectIcon beginSheetModalForWindow:[appDelegate window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    [alertForNotSelectIcon release];
    
    [dropAreaText setStringValue:@"Drop image(s) (PNG/JPG/TIFF) here"];
    
    [_files removeAllObjects];
    
    [progressView removeFromSuperview];
    [progressView stopAnimation:self];
    [progressView release];
    
}

- (IBAction)resize:(id)sender{
    NSProgressIndicator *progressView = [[NSProgressIndicator alloc]initWithFrame:NSMakeRect(98, 80, 20, 20)];
    [progressView setStyle:NSProgressIndicatorSpinningStyle];
    [progressView startAnimation:self];
    [self addSubview:progressView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"%@/ImageConvertor/",documentsDirectory];
    //    NSLog(@"number of files %d",[_files count]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:url]) {
        [fileManager createDirectoryAtPath:url withIntermediateDirectories:TRUE attributes:nil error:nil];
	}
    
    BOOL copied = FALSE;
    
    
    
    for (int i = 0; i < [_files count]; i++) {
        NSString *imagePath = [_files objectAtIndex:i];
        if (imagePath != nil) {
            
            NSImage* image = [[NSImage alloc]initWithContentsOfFile:imagePath];
            NSImage *resizedImage = [self resizeImage:image toSize:CGSizeMake([txtWidth.stringValue floatValue], [txtHeight.stringValue floatValue])];
            [image release];
            NSArray*  representations  = [resizedImage representations];
            NSData* bitmapData;

                bitmapData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSPNGFileType properties:nil];

            
            NSArray *pathComponantsArray = [imagePath pathComponents];
            NSString *saveImageToPath = [NSString stringWithFormat:@"%@/%@.png",url,[[pathComponantsArray lastObject] stringByDeletingPathExtension]];
            copied = [bitmapData writeToFile:saveImageToPath atomically:YES];
            
            if (!copied) {
                break;
            }
        }
    }
    NSString *messageString = nil;
    if ([_files count] >0) {
        if (copied) {
            messageString = [NSString stringWithFormat:@"Image(s) were saved to the directory %@",documentsDirectory];
        }else{
            messageString = [NSString stringWithFormat:@"Image converter requires read/write access to the directory %@",documentsDirectory];
            
        }
    }else{
        messageString = @"Drag and drop image files to the drop area";
    }

    AppDelegate *appDelegate=(AppDelegate *)[[NSApplication sharedApplication]delegate];
    
    NSAlert *alertForNotSelectIcon = [[NSAlert alloc] init];
    [alertForNotSelectIcon addButtonWithTitle:@"OK"];
    [alertForNotSelectIcon addButtonWithTitle:@"Cancel"];
    [alertForNotSelectIcon setMessageText:@"Image Convertor"];
    [alertForNotSelectIcon setInformativeText:messageString];
    [alertForNotSelectIcon setAlertStyle:NSWarningAlertStyle];
    [alertForNotSelectIcon beginSheetModalForWindow:[appDelegate window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    [alertForNotSelectIcon release];
    
    [dropAreaText setStringValue:@"Drop image(s) (PNG/JPG/TIFF) here"];
    
    [_files removeAllObjects];
    
    [progressView removeFromSuperview];
    [progressView stopAnimation:self];
    [progressView release];
}

- (NSImage *)resizeImage:(NSImage *)image toSize:(CGSize)size{
    
    NSImageView* kView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, size.width, size.height)] autorelease];
    [kView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [kView setImage:image];
    
    NSRect kRect = kView.frame;
    NSBitmapImageRep* kRep = [kView bitmapImageRepForCachingDisplayInRect:kRect];
    [kView cacheDisplayInRect:kRect toBitmapImageRep:kRep];
    
    NSData* kData = [kRep representationUsingType:NSPNGFileType properties:nil];
    
    return [[[NSImage alloc] initWithData:kData] autorelease];

}


@end
