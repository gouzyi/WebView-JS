//
//  YY_JSObject.h
//  WebView
//
//  Created by zainguo on 2020/2/27.
//  Copyright © 2020 zainguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN

@protocol YYProtocol <JSExport>
- (void)letShowImage;

JSExportAs(getSums, - (int)getSum:(int)num1 num2:(int)num2);

@end

@interface YY_JSObject : NSObject<YYProtocol>

@end

NS_ASSUME_NONNULL_END
