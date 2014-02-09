//
//  StreamFile.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASIProgressDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import "STreamAccessControl.h"
#import "ASINetworkQueue.h"

/*!
 StreamFile is a local representation of a file that is saved on the Stream Server.
 It supports post a file and post data. There is no limitation for the file size to be posted.
 It is strongly recommended to use the postFile function if the item size is larger than 500kb because the postData function automatically allocate the amount of  heap size that is the same as the posting item.
 StreamFile also supports file's metaData. You can set the metaData type by setting a NSMutableDictionary on the stream file object. The metaData is saved on first time the file is posted to stream server.
 Use populateMetaData To retrieve the file's metadata.
 */



@interface STreamFile : NSObject<ASIProgressDelegate, ASIHTTPRequestDelegate>{
    
    NSString *fileId;
    STreamAccessControl *accessControl;
    ASINetworkQueue *networkQueue;
    ASINetworkQueue *downloadNetworkQueue;
}

@property(retain) NSString *fileId;
@property(retain) NSMutableDictionary *fileMetadata;
@property(retain) STreamAccessControl *accessControl;
@property(retain) ASINetworkQueue *networkQueue;
@property(retain) ASINetworkQueue *downloadNetwrokQueue;
@property(strong, nonatomic)NSNumber *currentPostDataLength;
@property(copy) NSString *errorMessage;

typedef void (^DelegateCall)(float);
typedef void (^FinishCall)(NSString *);
typedef void (^FinishDownload)(NSData *, NSString *);


/*!
 Saves the contents of file and its metaData permanently to storage.
 @param filePath The file's local path
 @param finished The block to execute when the file is successfully posted.
 @param byteSent The block to execute when uploading progress is changed. byteSent:^(float percentage). The uploading progress is returned with an accurate percentage in float type.
 */
- (void)postFile: (NSString *)filePath finished: (FinishCall)doStaff byteSent: (DelegateCall)call;

- (NSString *)convertToJsonString: (NSMutableDictionary *)data;

/*!
 Download the file to local storage.
 @param path The destination path for the file to be downloaded to. The file path is automatically created if it does not exist.
 @param fileId The file's ID.
 @param view An UI component for displaying uploading progress.
 */
- (void)downloadAsFile: (NSString *)path fileId:(NSString *)objectId view:(UIProgressView *)processView;


/*!
 Download the file as NSData object.
 @param objectId the file's ID
 @param downladedData The block to execute when the file is successlly downloaded. downloadedData:^(NSData *data). Response data contains file's content.
 */
- (void)downloadAsData: (NSString *)objectId downloadedData: (FinishDownload)doStaff;

- (NSData *)downloadAsData:(NSString *)objectId;

- (void)convertJsonToMap: (NSArray *)jsonData;

- (void)downloadAsDataAndPopulateMetadata: (NSString *)objectId downloadedData: (FinishDownload)doStaff;

/*!
 Populate the file's metaData as NSMutableDictionary.
 @param fId The file's ID
 @param response The block to execute when the metaData is sucessfully populated.
 */
- (void)populateMetaData: (NSString *)fId response: (void (^)(NSString *))doStaff;

/*!
 Saves the contents of data and its metaData permanently to storage.
 @param data The data to be posted.
 @param finished The block to execute when the file is successfully posted.
 @param byteSent The block to execute when uploading progress is changed. byteSent:^(float percentage). The uploading progress is returned with an accurate percentage in float type.
 */
- (void) postData:(NSData *)data finished:(FinishCall)doStaff byteSent:(DelegateCall)call;


- (void) postData:(NSData *)data;


@end
