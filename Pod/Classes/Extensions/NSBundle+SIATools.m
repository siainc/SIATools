//
//  NSBundle+SIATools.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2012/07/11.
//  Copyright (c) 2012-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSBundle+SIATools.h"
#import <SIAEnumerator/SIAEnumerator.h>

@interface SIALocalization : NSObject
@property (nonatomic, strong) NSMutableSet *alreadyLocalizedObjects;
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation SIALocalization

+ (void)localizeViewController:(UIViewController *)controller bundle:(NSBundle *)bundle
{
    SIALocalization *localization = [[SIALocalization alloc] initWithBundle:bundle];
    [localization localizeViewController:controller];
}

- (id)initWithBundle:(NSBundle *)bundle
{
    self = [super init];
    if (self) {
        _alreadyLocalizedObjects = [NSMutableSet setWithCapacity:50];
        _bundle = bundle;
        if (_bundle) {
            _bundle = [NSBundle mainBundle];
        }
    }
    return self;
}

- (void)localizeViewController:(UIViewController *)controller
{
    if (controller == nil || [self.alreadyLocalizedObjects containsObject:controller]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:controller];
    
    [self localizeObject:controller forKVCKey:@"title"];
    [self localizeNavigationController:controller.navigationController];
    [self localizeNavigationItem:controller.navigationItem];
    
    [controller.toolbarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self localizeObject:obj forKVCKey:@"title"];
    }];
    
    [self localizeTabBarController:controller.tabBarController];
    
    [self localizeObject:controller.tabBarController forKVCKey:@"title"];
    
    [self localizeSearchDisplayController:controller.searchDisplayController];
    // controller.childViewControllers;
    [self localizeView:controller.view];
}

- (void)localizeObject:(id)object forKVCKeys:(NSString *)firstKey, ...
{
    NSMutableArray *arguments = @[].mutableCopy;
    va_list argumentList;
    if (firstKey) {
        va_start(argumentList, firstKey);
        NSString *key = firstKey;
        while (key != nil) {
            [arguments addObject:key];
            key = va_arg(argumentList, NSString *);
        }
        va_end(argumentList);
    }
    
    [arguments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [object valueForKey:obj];
        NSString *localizedString = [self localizedStringForKey:key value:nil table:nil ifNil:nil];
        [object setValue:localizedString forKey:key];
    }];
}

- (void)localizeObject:(id)object forKVCKey:(NSString *)KVCkey
{
    NSString *key = [object valueForKey:KVCkey];
    NSString *localizedString = [self localizedStringForKey:key value:nil table:nil ifNil:nil];
    [object setValue:localizedString forKey:KVCkey];
}

- (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)value
                              table:(NSString *)tableName
                              ifNil:(NSString *)ifNil
{
    if (key == nil) {
        return ifNil;
    }
    return [self.bundle localizedStringForKey:key value:value table:tableName];
}

- (void)localizeView:(UIView *)view
{
    if (view == nil || [self.alreadyLocalizedObjects containsObject:view]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:view];
    
    if ([view isKindOfClass:[UILabel class]]) {
        [self localizeObject:view forKVCKey:@"text"];
    }
    else if ([view isKindOfClass:[UITextField class]]) {
        [self localizeObject:view forKVCKey:@"text"];
    }
    else if ([view isKindOfClass:[UITextView class]]) {
        [self localizeObject:view forKVCKey:@"text"];
    }
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *v = (UIButton *)view;
        NSString *normal = [[NSBundle mainBundle] localizedStringForKey:[v titleForState:UIControlStateNormal]
                                                                  value:nil table:nil];
        if (normal) {
            [v setTitle:normal forState:UIControlStateNormal];
        }
        NSString *disabled = [[NSBundle mainBundle] localizedStringForKey:[v titleForState:UIControlStateDisabled]
                                                                    value:nil table:nil];
        if (disabled) {
            [v setTitle:disabled forState:UIControlStateDisabled];
        }
        NSString *highlighted = [[NSBundle mainBundle] localizedStringForKey:[v titleForState:UIControlStateHighlighted]
                                                                       value:nil table:nil
                                 ];
        if (highlighted) {
            [v setTitle:highlighted forState:UIControlStateHighlighted];
        }
        NSString *selected = [[NSBundle mainBundle] localizedStringForKey:[v titleForState:UIControlStateSelected]
                                                                    value:nil table:nil];
        if (selected) {
            [v setTitle:normal forState:UIControlStateSelected];
        }
    }
    else if ([view isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *v = (UISegmentedControl *)view;
        for (int i = 0; i < v.numberOfSegments; i++) {
            NSString *s = [[NSBundle mainBundle] localizedStringForKey:[v titleForSegmentAtIndex:i]
                                                                 value:nil table:nil];
            if (s) {
                [v setTitle:s forSegmentAtIndex:i];
            }
        }
    }
    else if ([view isKindOfClass:[UIToolbar class]]) {
        UIToolbar *v = (UIToolbar *)view;
        for (UIBarButtonItem *i in v.items) {
            NSString *s = [[NSBundle mainBundle] localizedStringForKey:i.title value:nil table:nil];
            if (s) {
                i.title = s;
            }
            if (i.customView) {
                [self localizeView:i.customView];
            }
        }
    }
    else if ([view isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *v = (UINavigationBar *)view;
        for (UIBarButtonItem *i in v.items) {
            NSString *s = [[NSBundle mainBundle] localizedStringForKey:i.title value:nil table:nil];
            if (s) {
                i.title = s;
            }
        }
    }
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self localizeView:obj];
    }];
}

- (void)localizeSearchDisplayController:(UISearchDisplayController *)searchDisplayController
{
    if (searchDisplayController == nil || [self.alreadyLocalizedObjects containsObject:searchDisplayController]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:searchDisplayController];
    
    [self localizeSearchBar:searchDisplayController.searchBar];
    [self localizeObject:searchDisplayController forKVCKey:@"searchResultsTitle"];
    [self localizeView:searchDisplayController.searchResultsTableView];
}

- (void)localizeSearchBar:(UISearchBar *)searchBar
{
    if (searchBar == nil || [self.alreadyLocalizedObjects containsObject:searchBar]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:searchBar];
    
    [self localizeView:searchBar];
    [self localizeObject:searchBar forKVCKey:@"prompt"];
    [self localizeObject:searchBar forKVCKey:@"placeholder"];
    NSArray *titles = [searchBar.scopeButtonTitles sia_map:^id (id obj) {
        return [self.bundle localizedStringForKey:obj value:nil table:nil];
    }];
    searchBar.scopeButtonTitles = titles;
}

- (void)localizeTabBarController:(UITabBarController *)tabBarController
{
    if (tabBarController == nil || [self.alreadyLocalizedObjects containsObject:tabBarController]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:tabBarController];
    
    [self localizeTabBar:tabBarController.tabBar];
}

- (void)localizeTabBar:(UITabBar *)tabBar
{
    if (tabBar == nil || [self.alreadyLocalizedObjects containsObject:tabBar]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:tabBar];
    
    [self localizeView:tabBar];
    [tabBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self localizeObject:obj forKVCKey:@"title"];
    }];
}

- (void)localizeNavigationController:(UINavigationController *)navigationController
{
    if (navigationController == nil || [self.alreadyLocalizedObjects containsObject:navigationController]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:navigationController];
    
    [self localizeToolbar:navigationController.toolbar];
    [self localizeNavigationItem:navigationController.navigationItem];
    [self localizeNavigationBar:navigationController.navigationBar];
}

- (void)localizeNavigationItem:(UINavigationItem *)item
{
    if (item == nil || [self.alreadyLocalizedObjects containsObject:item]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:item];
    
    [self localizeObject:item forKVCKey:@"title"];
}

- (void)localizeNavigationBar:(UINavigationBar *)navigationBar
{
    if (navigationBar == nil || [self.alreadyLocalizedObjects containsObject:navigationBar]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:navigationBar];
    
    [self localizeView:navigationBar];
    [navigationBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self localizeObject:obj forKVCKey:@"title"];
    }];
}

- (void)localizeToolbar:(UIToolbar *)toolbar
{
    if (toolbar == nil || [self.alreadyLocalizedObjects containsObject:toolbar]) {
        return;
    }
    [self.alreadyLocalizedObjects addObject:toolbar];
    
    [self localizeView:toolbar];
    [toolbar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self localizeObject:obj forKVCKey:@"title"];
    }];
}

@end

@implementation NSBundle (SIATools)

- (NSString *)sia_localizedStringForKey:(NSString *)key
                                  value:(NSString *)value
                                  table:(NSString *)tableName
                                  ifNil:(NSString *)ifNil
{
    if (key == nil) {
        return ifNil;
    }
    return [self localizedStringForKey:key value:value table:tableName];
}

- (void)sia_localizeViewController:(UIViewController *)controller
{
    [SIALocalization localizeViewController:controller bundle:self];
}

- (void)sia_localizeView:(UIView *)view
{
    SIALocalization *localization = [[SIALocalization alloc] initWithBundle:self];
    [localization localizeView:view];
}

@end
