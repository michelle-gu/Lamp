// Generated by Apple Swift version 5.0.1 effective-4.2 (swiftlang-1001.0.82.4 clang-1001.0.46.5)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreGraphics;
@import Foundation;
@import MapKit;
@import MessageKit;
@import RangeUISlider;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="Lamp",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class UITableView;
@class UITableViewCell;
@class UIStoryboardSegue;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC4Lamp21AccountViewController")
@interface AccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)viewDidLoad;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIWindow;
@class UIApplication;

SWIFT_CLASS("_TtC4Lamp11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions SWIFT_WARN_UNUSED_RESULT;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;

SWIFT_CLASS("_TtC4Lamp16BioTableViewCell")
@interface BioTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified bioTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified bioTextLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp19BudgetTableViewCell")
@interface BudgetTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified budgetTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified budgetTextLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImageView;

SWIFT_CLASS("_TtC4Lamp8CardView")
@interface CardView : UIView
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified image;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified jobLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified locationLabel;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIButton;

SWIFT_CLASS("_TtC4Lamp19CardsViewController")
@interface CardsViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified cardView;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profilePic;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified yesButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified noButton;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITextField;

SWIFT_CLASS("_TtC4Lamp28ChangePasswordViewController")
@interface ChangePasswordViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified oldPasswordField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified newPasswordField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified confirmPasswordField;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified saveButton;
- (IBAction)saveButtonPressed:(id _Nonnull)sender;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp24ContactInfoTableViewCell")
@interface ContactInfoTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified contactInfoTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified phoneTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified emailTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified emailLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified facebookTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified facebookLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified otherTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified otherLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UISlider;
@class RangeUISlider;
@class UISwitch;

SWIFT_CLASS("_TtC4Lamp28DiscoveryTableViewController")
@interface DiscoveryTableViewController : UITableViewController <RangeUISliderDelegate>
@property (nonatomic, weak) IBOutlet UISlider * _Null_unspecified maxDistanceSlider;
@property (nonatomic, weak) IBOutlet RangeUISlider * _Null_unspecified ageRangeSlider;
@property (nonatomic, weak) IBOutlet UISwitch * _Null_unspecified showMyProfileSwitch;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified universitiesListLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified futureLocationsListLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified genderListLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified maxDistanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified minAgeLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified maxAgeLabel;
- (void)rangeIsChangingWithMinValueSelected:(CGFloat)minValueSelected maxValueSelected:(CGFloat)maxValueSelected slider:(RangeUISlider * _Nonnull)slider;
- (void)rangeChangeFinishedWithMinValueSelected:(CGFloat)minValueSelected maxValueSelected:(CGFloat)maxValueSelected slider:(RangeUISlider * _Nonnull)slider;
- (IBAction)maxDistanceSliderChanged:(id _Nonnull)sender;
- (IBAction)showMyProfileToggled:(id _Nonnull)sender;
- (void)viewDidLoad;
- (UIView * _Nullable)tableView:(UITableView * _Nonnull)tableView viewForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp31EmailConfirmationViewController")
@interface EmailConfirmationViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified loginButton;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class MKMapView;
@class UISearchBar;

SWIFT_CLASS("_TtC4Lamp34FutureLocationFilterViewController")
@interface FutureLocationFilterViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified mapView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified addButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified addCityToList;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified futureCity1;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified futureCity2;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified futureCity3;
- (void)viewDidLoad;
- (IBAction)searchButtonPressed:(id _Nonnull)sender;
- (void)searchBarSearchButtonClicked:(UISearchBar * _Nonnull)searchBar;
- (IBAction)addCityButtonPressed:(id _Nonnull)sender;
- (IBAction)city1Pressed:(id _Nonnull)sender;
- (IBAction)city2Pressed:(id _Nonnull)sender;
- (IBAction)city3Pressed:(id _Nonnull)sender;
- (IBAction)saveButtonPressed:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp26GenderFilterViewController")
@interface GenderFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didDeselectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)viewDidLoad;
- (void)viewWillDisappear:(BOOL)animated;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp33LifestylePreferencesTableViewCell")
@interface LifestylePreferencesTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified lifestylePrefTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified numBedroomsTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified numBedroomsLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified petsTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified petsLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified smokingTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified smokingLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified otherTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified otherLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp19LogInViewController")
@interface LogInViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified emailField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified passwordField;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified logInButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified signUpButton;
- (IBAction)unwindToLoginWithSegue:(UIStoryboardSegue * _Nonnull)segue;
- (IBAction)logInDidTouch:(id _Nonnull)sender;
- (IBAction)signUpDidTouch:(id _Nonnull)sender;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp26MatchMessageViewController")
@interface MatchMessageViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified sendMessageButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified keepSwipingButton;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified yourProfilePicView;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified matchProfilePicView;
- (void)viewDidLoad;
- (IBAction)keepSwipingButtonClicked:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp29MessageInstanceViewController")
@interface MessageInstanceViewController : MessagesViewController
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end










SWIFT_CLASS("_TtC4Lamp25MessageListViewController")
@interface MessageListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profile1PicView;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profile2PicView;
- (void)viewDidLoad;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp20MessageTableViewCell")
@interface MessageTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profileImageView;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class KolodaView;

SWIFT_CLASS("_TtC4Lamp22MyKolodaViewController")
@interface MyKolodaViewController : UIViewController
@property (nonatomic, weak) IBOutlet KolodaView * _Null_unspecified kolodaView;
- (void)viewDidLoad;
- (IBAction)yesButtonPressed:(id _Nonnull)sender;
- (IBAction)noButtonPressed:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end






SWIFT_CLASS("_TtC4Lamp32NotificationsTableViewController")
@interface NotificationsTableViewController : UITableViewController
@property (nonatomic, weak) IBOutlet UISwitch * _Null_unspecified newMessagesSwitch;
@property (nonatomic, weak) IBOutlet UISwitch * _Null_unspecified newMatchesSwitch;
- (IBAction)newMessageToggle:(id _Nonnull)sender;
- (IBAction)newMatchesToggle:(id _Nonnull)sender;
- (void)viewDidLoad;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITapGestureRecognizer;
@class UIDatePicker;
@class UIPickerView;

SWIFT_CLASS("_TtC4Lamp29ProfileCreationViewController")
@interface ProfileCreationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profilePictureView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified changePictureButton;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified genderTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified birthdayTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified firstNameTextField;
- (void)viewDidLoad;
- (void)viewTappedWithGestureRecognizer:(UITapGestureRecognizer * _Nonnull)gestureRecognizer;
- (void)dateChangedWithDatePicker:(UIDatePicker * _Nonnull)datePicker;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView * _Nonnull)pickerView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)pickerView:(UIPickerView * _Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)pickerView:(UIPickerView * _Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
- (void)pickerView:(UIPickerView * _Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (IBAction)nextButtonPressed:(id _Nonnull)sender;
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITextView;

SWIFT_CLASS("_TtC4Lamp25ProfileEditViewController")
@interface ProfileEditViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profilePictureImageView;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified occupationTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified futureLocTextField;
@property (nonatomic, weak) IBOutlet UITextView * _Null_unspecified bioText;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified budgetTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified bedroomNumTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified petsTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified smokingTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified otherLifestylePrefsTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified emailTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified facebookTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified otherContactTextField;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)textViewDidChangeSelection:(UITextView * _Nonnull)textView;
- (IBAction)cancelButtonPressed:(id _Nonnull)sender;
- (IBAction)changeProfilePicture:(id _Nonnull)sender;
- (IBAction)saveButtonPressed:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp29ProfileLocationViewController")
@interface ProfileLocationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profilePictureView;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified uniTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified futureLocTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified occupationTextField;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView * _Nonnull)pickerView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)pickerView:(UIPickerView * _Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)pickerView:(UIPickerView * _Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
- (void)pickerView:(UIPickerView * _Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (IBAction)doneButtonPressed:(id _Nonnull)sender;
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp24ProfileMapViewController")
@interface ProfileMapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified mapView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified addButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified addCityToList;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified futureCity1;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified futureCity2;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified futureCity3;
- (void)viewDidLoad;
- (IBAction)searchButtonPressed:(id _Nonnull)sender;
- (void)searchBarSearchButtonClicked:(UISearchBar * _Nonnull)searchBar;
- (IBAction)addCityToListButtonPressed:(id _Nonnull)sender;
- (IBAction)city1ButtonPressed:(id _Nonnull)sender;
- (IBAction)city2ButtonPressed:(id _Nonnull)sender;
- (IBAction)city3ButtonPressed:(id _Nonnull)sender;
- (IBAction)saveButtonClicked:(id _Nonnull)sender;
- (IBAction)cancelButtonClicked:(id _Nonnull)sender;
- (void)viewDidAppear:(BOOL)animated;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp21ProfileViewController")
@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified profilePicture;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified occupationLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified futureLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified uniLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified nameAgeLabel;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified profileTableView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified editButton;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (IBAction)editButtonDidTouch:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp24RangeSliderTableViewCell")
@interface RangeSliderTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titleLabel;
@property (nonatomic, weak) IBOutlet RangeUISlider * _Null_unspecified rangeSlider;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIBarButtonItem;

SWIFT_CLASS("_TtC4Lamp22SettingsViewController")
@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem * _Null_unspecified logOutButton;
- (IBAction)logOutButtonPressed:(id _Nonnull)sender;
- (void)viewDidLoad;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp20SignUpViewController")
@interface SignUpViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified emailField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified passwordField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified confirmPasswordField;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified logInButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified signUpButton;
- (IBAction)logInDidTouch:(id _Nonnull)sender;
- (IBAction)signUpDidTouch:(id _Nonnull)sender;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp19SliderTableViewCell")
@interface SliderTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titleLabel;
@property (nonatomic, weak) IBOutlet UISlider * _Null_unspecified slider;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp32SocialMediaConnectViewController")
@interface SocialMediaConnectViewController : UIViewController
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp21SubtitleTableViewCell")
@interface SubtitleTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified subtitleLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp19ToggleTableViewCell")
@interface ToggleTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titleLabel;
@property (nonatomic, weak) IBOutlet UISwitch * _Null_unspecified toggle;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp32UniversitiesFilterViewController")
@interface UniversitiesFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didDeselectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)viewDidLoad;
- (void)viewWillDisappear:(BOOL)animated;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC4Lamp14ViewController")
@interface ViewController : UIViewController
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
