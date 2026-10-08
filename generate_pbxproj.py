import os

project_pbxproj_content = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		9F0000012C50000100000001 /* ChingshinApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000012C50000100000000 /* ChingshinApp.swift */; };
		9F0000022C50000100000001 /* ChingShinTheme.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000022C50000100000000 /* ChingShinTheme.swift */; };
		9F0000032C50000100000001 /* DrinkModel.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000032C50000100000000 /* DrinkModel.swift */; };
		9F0000042C50000100000001 /* MockData.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000042C50000100000000 /* MockData.swift */; };
		9F0000052C50000100000001 /* BobaCupVisualizer.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000052C50000100000000 /* BobaCupVisualizer.swift */; };
		9F0000062C50000100000001 /* DrinkDetailSheet.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000062C50000100000000 /* DrinkDetailSheet.swift */; };
		9F0000072C50000100000001 /* MenuView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000072C50000100000000 /* MenuView.swift */; };
		9F0000082C50000100000001 /* CartSheet.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000082C50000100000000 /* CartSheet.swift */; };
		9F0000092C50000100000001 /* CheckoutView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F0000092C50000100000000 /* CheckoutView.swift */; };
		9F00000A2C50000100000001 /* OrderTrackingView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F00000A2C50000100000000 /* OrderTrackingView.swift */; };
		9F00000B2C50000100000001 /* MemberCardView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F00000B2C50000100000000 /* MemberCardView.swift */; };
		9F00000C2C50000100000001 /* StoreLocatorView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F00000C2C50000100000000 /* StoreLocatorView.swift */; };
		9F00000D2C50000100000001 /* MainTabView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 9F00000D2C50000100000000 /* MainTabView.swift */; };
		9F00000E2C50000100000001 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 9F00000E2C50000100000000 /* Assets.xcassets */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		9F0000002C50000100000000 /* ChingshinApp.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = ChingshinApp.app; sourceTree = BUILT_PRODUCTS_DIR; };
		9F0000012C50000100000000 /* ChingshinApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ChingshinApp.swift; sourceTree = "<group>"; };
		9F0000022C50000100000000 /* ChingShinTheme.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Theme/ChingShinTheme.swift; sourceTree = "<group>"; };
		9F0000032C50000100000000 /* DrinkModel.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Models/DrinkModel.swift; sourceTree = "<group>"; };
		9F0000042C50000100000000 /* MockData.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Models/MockData.swift; sourceTree = "<group>"; };
		9F0000052C50000100000000 /* BobaCupVisualizer.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/Components/BobaCupVisualizer.swift; sourceTree = "<group>"; };
		9F0000062C50000100000000 /* DrinkDetailSheet.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/DrinkDetailSheet.swift; sourceTree = "<group>"; };
		9F0000072C50000100000000 /* MenuView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/MenuView.swift; sourceTree = "<group>"; };
		9F0000082C50000100000000 /* CartSheet.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/CartSheet.swift; sourceTree = "<group>"; };
		9F0000092C50000100000000 /* CheckoutView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/CheckoutView.swift; sourceTree = "<group>"; };
		9F00000A2C50000100000000 /* OrderTrackingView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/OrderTrackingView.swift; sourceTree = "<group>"; };
		9F00000B2C50000100000000 /* MemberCardView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/MemberCardView.swift; sourceTree = "<group>"; };
		9F00000C2C50000100000000 /* StoreLocatorView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/StoreLocatorView.swift; sourceTree = "<group>"; };
		9F00000D2C50000100000000 /* MainTabView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/MainTabView.swift; sourceTree = "<group>"; };
		9F00000E2C50000100000000 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		9F00000F2C50000100000000 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		9F0000102C50000100000000 = {
			isa = PBXGroup;
			children = (
				9F0000112C50000100000000 /* ChingshinApp */,
				9F0000122C50000100000000 /* Products */,
			);
			sourceTree = "<group>";
		};
		9F0000112C50000100000000 /* ChingshinApp */ = {
			isa = PBXGroup;
			children = (
				9F0000012C50000100000000 /* ChingshinApp.swift */,
				9F0000022C50000100000000 /* ChingShinTheme.swift */,
				9F0000032C50000100000000 /* DrinkModel.swift */,
				9F0000042C50000100000000 /* MockData.swift */,
				9F0000052C50000100000000 /* BobaCupVisualizer.swift */,
				9F0000062C50000100000000 /* DrinkDetailSheet.swift */,
				9F0000072C50000100000000 /* MenuView.swift */,
				9F0000082C50000100000000 /* CartSheet.swift */,
				9F0000092C50000100000000 /* CheckoutView.swift */,
				9F00000A2C50000100000000 /* OrderTrackingView.swift */,
				9F00000B2C50000100000000 /* MemberCardView.swift */,
				9F00000C2C50000100000000 /* StoreLocatorView.swift */,
				9F00000D2C50000100000000 /* MainTabView.swift */,
				9F00000E2C50000100000000 /* Assets.xcassets */,
			);
			path = ChingshinApp;
			sourceTree = "<group>";
		};
		9F0000122C50000100000000 /* Products */ = {
			isa = PBXGroup;
			children = (
				9F0000002C50000100000000 /* ChingshinApp.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		9F0000132C50000100000000 /* ChingshinApp */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 9F0000142C50000100000000 /* Build configuration list for PBXNativeTarget "ChingshinApp" */;
			buildPhases = (
				9F0000152C50000100000000 /* Sources */,
				9F00000F2C50000100000000 /* Frameworks */,
				9F0000162C50000100000000 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = ChingshinApp;
			productName = ChingshinApp;
			productReference = 9F0000002C50000100000000 /* ChingshinApp.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		9F0000172C50000100000000 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					9F0000132C50000100000000 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = 9F0000182C50000100000000 /* Build configuration list for PBXProject "ChingshinApp" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = 9F0000102C50000100000000;
			productRefGroup = 9F0000122C50000100000000 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				9F0000132C50000100000000 /* ChingshinApp */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		9F0000162C50000100000000 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				9F00000E2C50000100000001 /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		9F0000152C50000100000000 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				9F0000012C50000100000001 /* ChingshinApp.swift in Sources */,
				9F0000022C50000100000001 /* ChingShinTheme.swift in Sources */,
				9F0000032C50000100000001 /* DrinkModel.swift in Sources */,
				9F0000042C50000100000001 /* MockData.swift in Sources */,
				9F0000052C50000100000001 /* BobaCupVisualizer.swift in Sources */,
				9F0000062C50000100000001 /* DrinkDetailSheet.swift in Sources */,
				9F0000072C50000100000001 /* MenuView.swift in Sources */,
				9F0000082C50000100000001 /* CartSheet.swift in Sources */,
				9F0000092C50000100000001 /* CheckoutView.swift in Sources */,
				9F00000A2C50000100000001 /* OrderTrackingView.swift in Sources */,
				9F00000B2C50000100000001 /* MemberCardView.swift in Sources */,
				9F00000C2C50000100000001 /* StoreLocatorView.swift in Sources */,
				9F00000D2C50000100000001 /* MainTabView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		9F0000192C50000100000000 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.chingshin.bobaapp;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SDKROOT = iphoneos;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		9F00001A2C50000100000000 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.chingshin.bobaapp;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SDKROOT = iphoneos;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
		9F00001B2C50000100000000 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		9F00001C2C50000100000000 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				COPY_PHASE_STRIP = YES;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		9F0000142C50000100000000 /* Build configuration list for PBXNativeTarget "ChingshinApp" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				9F0000192C50000100000000 /* Debug */,
				9F00001A2C50000100000000 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		9F0000182C50000100000000 /* Build configuration list for PBXProject "ChingshinApp" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				9F00001B2C50000100000000 /* Debug */,
				9F00001C2C50000100000000 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = 9F0000172C50000100000000 /* Project object */;
}
"""

with open("/Users/zhao/工作專區/清心ios app/ChingshinApp.xcodeproj/project.pbxproj", "w", encoding="utf-8") as f:
    f.write(project_pbxproj_content)

print("project.pbxproj created successfully.")
