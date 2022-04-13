echo      Launch this script by pasting this command into a black terminal window.  
echo .
echo .     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/msapsdev/BuildScripts/main/loop-master-with-xdrip.sh)"
echo .

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
LOOP_BUILD=$(date +'%y%m%d-%H%M')
BUILDLOOP_DIR=~/Downloads/BuildLoop
LOOP_DIR=$BUILDLOOP_DIR/Loop-Master-xDrip-$LOOP_BUILD

LOOP_WORKSPACE_URL=https://github.com/LoopKit/LoopWorkspace.git
LOOP_WORKSPACE_BRANCH=master

XDRIP_CLIENT_URL=https://github.com/loopnlearn/xdrip-client-swift.git
XDRIP_CLIENT_BRANCH=freeaps

XDRIP_PATCHES=$SCRIPT_DIR/xdrip

mkdir -p $LOOP_DIR
cd $LOOP_DIR
pwd
echo "# Download LoopWorkspace master branch from github"
git clone --branch=$LOOP_WORKSPACE_BRANCH --recurse-submodules $LOOP_WORKSPACE_URL

cd LoopWorkspace
echo "# Adding xDripClient submodule from $XDRIP_CLIENT_URL branch $XDRIP_CLIENT_BRANCH"
git submodule add -b $XDRIP_CLIENT_BRANCH $XDRIP_CLIENT_URL

echo "# Patching LoopWorkspace"
patch -p0 <<"EOF"
diff --git Loop.xcworkspace/contents.xcworkspacedata Loop.xcworkspace/contents.xcworkspacedata
index e3bc36b..276282a 100644
--- Loop.xcworkspace/contents.xcworkspacedata
+++ Loop.xcworkspace/contents.xcworkspacedata
@@ -25,6 +25,9 @@
    <FileRef
       location = "group:dexcom-share-client-swift/ShareClient.xcodeproj">
    </FileRef>
+   <FileRef
+      location = "group:xdrip-client-swift/xDripClient.xcodeproj">
+   </FileRef>      
    <FileRef
       location = "group:G4ShareSpy/G4ShareSpy.xcodeproj">
    </FileRef>
diff --git Loop.xcworkspace/xcshareddata/xcschemes/Loop (Workspace).xcscheme Loop.xcworkspace/xcshareddata/xcschemes/Loop (Workspace).xcscheme
index 7809b8d..b0b939c 100644
--- Loop.xcworkspace/xcshareddata/xcschemes/Loop (Workspace).xcscheme	
+++ Loop.xcworkspace/xcshareddata/xcschemes/Loop (Workspace).xcscheme	
@@ -188,6 +188,34 @@
                ReferencedContainer = "container:rileylink_ios/RileyLink.xcodeproj">
             </BuildableReference>
          </BuildActionEntry>
+         <BuildActionEntry
+            buildForTesting = "YES"
+            buildForRunning = "YES"
+            buildForProfiling = "YES"
+            buildForArchiving = "YES"
+            buildForAnalyzing = "YES">
+            <BuildableReference
+               BuildableIdentifier = "primary"
+               BlueprintIdentifier = "432B0E871CDFC3C50045347B"
+               BuildableName = "xDripClient.framework"
+               BlueprintName = "xDripClient"
+               ReferencedContainer = "container:xdrip-client-swift/xDripClient.xcodeproj">
+            </BuildableReference>
+         </BuildActionEntry>
+         <BuildActionEntry
+            buildForTesting = "YES"
+            buildForRunning = "YES"
+            buildForProfiling = "YES"
+            buildForArchiving = "YES"
+            buildForAnalyzing = "YES">
+            <BuildableReference
+               BuildableIdentifier = "primary"
+               BlueprintIdentifier = "43A8EC81210E664300A81379"
+               BuildableName = "xDripClientUI.framework"
+               BlueprintName = "xDripClientUI"
+               ReferencedContainer = "container:xdrip-client-swift/xDripClient.xcodeproj">
+            </BuildableReference>
+         </BuildActionEntry>
          <BuildActionEntry
             buildForTesting = "YES"
             buildForRunning = "YES"
diff --git LoopConfigOverride.xcconfig LoopConfigOverride.xcconfig
index fa11c72..76ae4d2 100644
--- LoopConfigOverride.xcconfig
+++ LoopConfigOverride.xcconfig
@@ -1,4 +1,4 @@
-//
+#include? "../../LoopConfigOverride.xcconfig"
 
 // Override this if you don't want the default com.${DEVELOPMENT_TEAM}.loopkit that loop uses
 // MAIN_APP_BUNDLE_IDENTIFIER = com.myname.loop
EOF

echo "# Patching Loop"
pushd Loop > /dev/null
patch -p0 <<"EOF"
diff --git Cartfile Cartfile
index 77da6064..63abea5e 100644
--- Cartfile
+++ Cartfile
@@ -5,3 +5,4 @@ github "LoopKit/dexcom-share-client-swift" "loop-release/v2.2.5"
 github "LoopKit/G4ShareSpy" "loop-release/v2.2.5"
 github "ps2/rileylink_ios" "loop-release/v2.2.5"
 github "LoopKit/Amplitude-iOS" "main"
+github "loopnlearn/xdrip-client-swift" "freeaps"
diff --git Cartfile.resolved Cartfile.resolved
index 124ed52e..b3c9382d 100644
--- Cartfile.resolved
+++ Cartfile.resolved
@@ -6,3 +6,4 @@ github "LoopKit/MKRingProgressView" "f548a5c64832be2d37d7c91b5800e284887a2a0a"
 github "LoopKit/dexcom-share-client-swift" "b9acf057851271aea0b5759c3062acd58ed9e8f9"
 github "i-schuetz/SwiftCharts" "0.6.5"
 github "ps2/rileylink_ios" "8125112c66f53b0f3e3693fd2486426111a37ca0"
+github "loopnlearn/xdrip-client-swift" "freeaps"
diff --git Loop.xcodeproj/project.pbxproj Loop.xcodeproj/project.pbxproj
index eec481d3..fd1ffb87 100644
--- Loop.xcodeproj/project.pbxproj
+++ Loop.xcodeproj/project.pbxproj
@@ -357,6 +357,8 @@
 		89E267FD2292456700A3F2AF /* FeatureFlags.swift in Sources */ = {isa = PBXBuildFile; fileRef = 89E267FB2292456700A3F2AF /* FeatureFlags.swift */; };
 		89E267FF229267DF00A3F2AF /* Optional.swift in Sources */ = {isa = PBXBuildFile; fileRef = 89E267FE229267DF00A3F2AF /* Optional.swift */; };
 		89E26800229267DF00A3F2AF /* Optional.swift in Sources */ = {isa = PBXBuildFile; fileRef = 89E267FE229267DF00A3F2AF /* Optional.swift */; };
+		A9F9E72A28055FD60098132C /* xDripClient.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A9F9E72928055FD60098132C /* xDripClient.framework */; };
+		A9F9E72C28055FD60098132C /* xDripClientUI.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A9F9E72B28055FD60098132C /* xDripClientUI.framework */; };
 		C10428971D17BAD400DD539A /* NightscoutUploadKit.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = C10428961D17BAD400DD539A /* NightscoutUploadKit.framework */; };
 		C10B28461EA9BA5E006EA1FC /* far_future_high_bg_forecast.json in Resources */ = {isa = PBXBuildFile; fileRef = C10B28451EA9BA5E006EA1FC /* far_future_high_bg_forecast.json */; };
 		C11C87DE1E21EAAD00BB71D3 /* HKUnit.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4F526D5E1DF2459000A04910 /* HKUnit.swift */; };
@@ -1068,6 +1070,8 @@
 		89D6953D23B6DF8A002B3066 /* PotentialCarbEntryTableViewCell.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PotentialCarbEntryTableViewCell.swift; sourceTree = "<group>"; };
 		89E267FB2292456700A3F2AF /* FeatureFlags.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FeatureFlags.swift; sourceTree = "<group>"; };
 		89E267FE229267DF00A3F2AF /* Optional.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Optional.swift; sourceTree = "<group>"; };
+		A9F9E72928055FD60098132C /* xDripClient.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = xDripClient.framework; sourceTree = BUILT_PRODUCTS_DIR; };
+		A9F9E72B28055FD60098132C /* xDripClientUI.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = xDripClientUI.framework; sourceTree = BUILT_PRODUCTS_DIR; };
 		C10428961D17BAD400DD539A /* NightscoutUploadKit.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = NightscoutUploadKit.framework; sourceTree = BUILT_PRODUCTS_DIR; };
 		C10B28451EA9BA5E006EA1FC /* far_future_high_bg_forecast.json */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.json; path = far_future_high_bg_forecast.json; sourceTree = "<group>"; };
 		C125F31A22FE7CE200FD0545 /* copy-frameworks.sh */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.script.sh; path = "copy-frameworks.sh"; sourceTree = "<group>"; };
@@ -1136,6 +1140,8 @@
 				892A5D2A222EF60A008961AB /* MockKit.framework in Frameworks */,
 				892A5D2C222EF60A008961AB /* MockKitUI.framework in Frameworks */,
 				C10428971D17BAD400DD539A /* NightscoutUploadKit.framework in Frameworks */,
+				A9F9E72A28055FD60098132C /* xDripClient.framework in Frameworks */,
+				A9F9E72C28055FD60098132C /* xDripClientUI.framework in Frameworks */,
 				43B371881CE597D10013C5A6 /* ShareClient.framework in Frameworks */,
 				4F08DE9B1E7BC4ED006741EA /* SwiftCharts.framework in Frameworks */,
 				4379CFF021112CF700AADC79 /* ShareClientUI.framework in Frameworks */,
@@ -1857,6 +1863,8 @@
 		968DCD53F724DE56FFE51920 /* Frameworks */ = {
 			isa = PBXGroup;
 			children = (
+				A9F9E72928055FD60098132C /* xDripClient.framework */,
+				A9F9E72B28055FD60098132C /* xDripClientUI.framework */,
 				434FB6451D68F1CD007B9C70 /* Amplitude.framework */,
 				4344628420A7A3BE00C4BE6F /* CGMBLEKit.framework */,
 				43A8EC6E210E622600A81379 /* CGMBLEKitUI.framework */,
@@ -2471,6 +2479,8 @@
 				"$(BUILT_PRODUCTS_DIR)/MockKit.framework/MockKit",
 				"$(BUILT_PRODUCTS_DIR)/MockKitUI.framework/MockKitUI",
 				"$(BUILT_PRODUCTS_DIR)/MKRingProgressView.framework/MKRingProgressView",
+				"$(BUILT_PRODUCTS_DIR)/xDripClient.framework/xDripClient",
+				"$(BUILT_PRODUCTS_DIR)/xDripClientUI.framework/xDripClientUI",
 			);
 			name = "Copy Frameworks with Carthage";
 			outputPaths = (
@@ -2489,6 +2499,8 @@
 				"$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/MockKit.framework",
 				"$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/MockKitUI.framework",
 				"$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/MKRingProgressView.framework",
+				"$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/xDripClient.framework",
+				"$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/xDripClientUI.framework",
 			);
 			runOnlyForDeploymentPostprocessing = 0;
 			shellPath = /bin/sh;
@@ -3455,7 +3467,7 @@
 				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
 				GCC_WARN_UNUSED_FUNCTION = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
-				IPHONEOS_DEPLOYMENT_TARGET = 12.0;
+				IPHONEOS_DEPLOYMENT_TARGET = 14.4;
 				LOCALIZED_STRING_MACRO_NAMES = (
 					NSLocalizedString,
 					CFLocalizedString,
@@ -3522,7 +3534,7 @@
 				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
 				GCC_WARN_UNUSED_FUNCTION = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
-				IPHONEOS_DEPLOYMENT_TARGET = 12.0;
+				IPHONEOS_DEPLOYMENT_TARGET = 14.4;
 				LOCALIZED_STRING_MACRO_NAMES = (
 					NSLocalizedString,
 					CFLocalizedString,
@@ -3547,7 +3559,7 @@
 				ASSETCATALOG_COMPILER_APPICON_NAME = "$(APPICON_NAME)";
 				CODE_SIGN_ENTITLEMENTS = Loop/Loop.entitlements;
 				CODE_SIGN_IDENTITY = "iPhone Developer";
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				ENABLE_BITCODE = YES;
 				INFOPLIST_FILE = Loop/Info.plist;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
@@ -3566,7 +3578,7 @@
 				ASSETCATALOG_COMPILER_APPICON_NAME = "$(APPICON_NAME)";
 				CODE_SIGN_ENTITLEMENTS = Loop/Loop.entitlements;
 				CODE_SIGN_IDENTITY = "iPhone Developer";
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				ENABLE_BITCODE = YES;
 				INFOPLIST_FILE = Loop/Info.plist;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
@@ -3584,7 +3596,7 @@
 				CODE_SIGN_ENTITLEMENTS = "WatchApp Extension/WatchApp Extension.entitlements";
 				CODE_SIGN_IDENTITY = "iPhone Developer";
 				"CODE_SIGN_IDENTITY[sdk=watchos*]" = "iPhone Developer";
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				FRAMEWORK_SEARCH_PATHS = "$(PROJECT_DIR)/Carthage/Build/watchOS";
 				INFOPLIST_FILE = "WatchApp Extension/Info.plist";
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks";
@@ -3607,7 +3619,7 @@
 				CODE_SIGN_ENTITLEMENTS = "WatchApp Extension/WatchApp Extension.entitlements";
 				CODE_SIGN_IDENTITY = "iPhone Developer";
 				"CODE_SIGN_IDENTITY[sdk=watchos*]" = "iPhone Developer";
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				FRAMEWORK_SEARCH_PATHS = "$(PROJECT_DIR)/Carthage/Build/watchOS";
 				INFOPLIST_FILE = "WatchApp Extension/Info.plist";
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks";
@@ -3628,7 +3640,7 @@
 				ASSETCATALOG_COMPILER_APPICON_NAME = "$(APPICON_NAME)";
 				CODE_SIGN_IDENTITY = "iPhone Developer";
 				"CODE_SIGN_IDENTITY[sdk=watchos*]" = "iPhone Developer";
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				FRAMEWORK_SEARCH_PATHS = "$(PROJECT_DIR)/Carthage/Build/watchOS";
 				IBSC_MODULE = WatchApp_Extension;
 				INFOPLIST_FILE = WatchApp/Info.plist;
@@ -3649,7 +3661,7 @@
 				ASSETCATALOG_COMPILER_APPICON_NAME = "$(APPICON_NAME)";
 				CODE_SIGN_IDENTITY = "iPhone Developer";
 				"CODE_SIGN_IDENTITY[sdk=watchos*]" = "iPhone Developer";
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				FRAMEWORK_SEARCH_PATHS = "$(PROJECT_DIR)/Carthage/Build/watchOS";
 				IBSC_MODULE = WatchApp_Extension;
 				INFOPLIST_FILE = WatchApp/Info.plist;
@@ -3933,7 +3945,7 @@
 				CODE_SIGN_IDENTITY = "Apple Development";
 				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
 				CODE_SIGN_STYLE = Automatic;
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				ENABLE_BITCODE = NO;
 				INFOPLIST_FILE = "Loop Status Extension/Info.plist";
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks";
@@ -3955,7 +3967,7 @@
 				CODE_SIGN_IDENTITY = "Apple Development";
 				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
 				CODE_SIGN_STYLE = Automatic;
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				ENABLE_BITCODE = NO;
 				INFOPLIST_FILE = "Loop Status Extension/Info.plist";
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks";
diff --git Loop/Managers/CGMManager.swift Loop/Managers/CGMManager.swift
index 7809c9f7..6d17fb6b 100644
--- Loop/Managers/CGMManager.swift
+++ Loop/Managers/CGMManager.swift
@@ -10,12 +10,14 @@ import CGMBLEKit
 import G4ShareSpy
 import ShareClient
 import MockKit
+import xDripClient
 
 
 let allCGMManagers: [CGMManager.Type] = [
     G6CGMManager.self,
     G5CGMManager.self,
     G4CGMManager.self,
+    xDripClientManager.self,
     ShareClientManager.self,
     MockCGMManager.self,
 ]
EOF
popd > /dev/null

echo "# Patching xdrip-client-swift"
pushd xdrip-client-swift > /dev/null
patch -p0 <<EOF
diff --git xDripClient.xcodeproj/project.pbxproj xDripClient.xcodeproj/project.pbxproj
index a7c9721..f6fa43a 100644
--- xDripClient.xcodeproj/project.pbxproj
+++ xDripClient.xcodeproj/project.pbxproj
@@ -59,6 +59,8 @@
 		43AB5127213315D300B3D58D /* Localizable.strings in Resources */ = {isa = PBXBuildFile; fileRef = 43AB5125213315D300B3D58D /* Localizable.strings */; };
 		43AB51362133177800B3D58D /* LocalizedString.swift in Sources */ = {isa = PBXBuildFile; fileRef = 43AB51352133177800B3D58D /* LocalizedString.swift */; };
 		43AB51372133177800B3D58D /* LocalizedString.swift in Sources */ = {isa = PBXBuildFile; fileRef = 43AB51352133177800B3D58D /* LocalizedString.swift */; };
+		A9C010A62806D1BC008D140A /* xDripClient.xcconfig in Resources */ = {isa = PBXBuildFile; fileRef = A9C010A52806D1BC008D140A /* xDripClient.xcconfig */; };
+		A9C010A72806D1BC008D140A /* xDripClient.xcconfig in Resources */ = {isa = PBXBuildFile; fileRef = A9C010A52806D1BC008D140A /* xDripClient.xcconfig */; };
 /* End PBXBuildFile section */
 
 /* Begin PBXContainerItemProxy section */
@@ -170,6 +172,7 @@
 		43AB51302133161A00B3D58D /* pl */ = {isa = PBXFileReference; lastKnownFileType = text.plist.strings; name = pl; path = pl.lproj/Localizable.strings; sourceTree = "<group>"; };
 		43AB51352133177800B3D58D /* LocalizedString.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = LocalizedString.swift; sourceTree = "<group>"; };
 		43C418AE1CE0488900405B6A /* xDripClient.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = xDripClient.swift; sourceTree = "<group>"; };
+		A9C010A52806D1BC008D140A /* xDripClient.xcconfig */ = {isa = PBXFileReference; lastKnownFileType = text.xcconfig; path = xDripClient.xcconfig; sourceTree = "<group>"; };
 /* End PBXFileReference section */
 
 /* Begin PBXFrameworksBuildPhase section */
@@ -242,6 +245,7 @@
 		432B0E7E1CDFC3C50045347B = {
 			isa = PBXGroup;
 			children = (
+				A9C010A52806D1BC008D140A /* xDripClient.xcconfig */,
 				432B0E8A1CDFC3C50045347B /* xDripClient */,
 				43AB51342133176B00B3D58D /* Common */,
 				432B0E961CDFC3C50045347B /* xDripClientTests */,
@@ -440,6 +444,7 @@
 					};
 					43A8EC75210E653B00A81379 = {
 						CreatedOnToolsVersion = 9.4.1;
+						DevelopmentTeam = "$(DEVELOPMENT_TEAM)";
 						ProvisioningStyle = Automatic;
 					};
 					43A8EC81210E664300A81379 = {
@@ -503,6 +508,7 @@
 			buildActionMask = 2147483647;
 			files = (
 				43AB5127213315D300B3D58D /* Localizable.strings in Resources */,
+				A9C010A62806D1BC008D140A /* xDripClient.xcconfig in Resources */,
 			);
 			runOnlyForDeploymentPostprocessing = 0;
 		};
@@ -518,6 +524,7 @@
 			buildActionMask = 2147483647;
 			files = (
 				43AB511B21330D1400B3D58D /* Localizable.strings in Resources */,
+				A9C010A72806D1BC008D140A /* xDripClient.xcconfig in Resources */,
 			);
 			runOnlyForDeploymentPostprocessing = 0;
 		};
@@ -734,6 +741,7 @@
 		};
 		432B0E9A1CDFC3C50045347B /* Debug */ = {
 			isa = XCBuildConfiguration;
+			baseConfigurationReference = A9C010A52806D1BC008D140A /* xDripClient.xcconfig */;
 			buildSettings = {
 				ALWAYS_SEARCH_USER_PATHS = NO;
 				CARTHAGE_PLATFORM_PATH_iphoneos = iOS;
@@ -785,7 +793,7 @@
 				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
 				GCC_WARN_UNUSED_FUNCTION = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
-				IPHONEOS_DEPLOYMENT_TARGET = 11.1;
+				IPHONEOS_DEPLOYMENT_TARGET = 14.4;
 				LOCALIZED_STRING_MACRO_NAMES = (
 					NSLocalizedString,
 					CFLocalizedString,
@@ -804,6 +812,7 @@
 		};
 		432B0E9B1CDFC3C50045347B /* Release */ = {
 			isa = XCBuildConfiguration;
+			baseConfigurationReference = A9C010A52806D1BC008D140A /* xDripClient.xcconfig */;
 			buildSettings = {
 				ALWAYS_SEARCH_USER_PATHS = NO;
 				CARTHAGE_PLATFORM_PATH_iphoneos = iOS;
@@ -849,7 +858,7 @@
 				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
 				GCC_WARN_UNUSED_FUNCTION = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
-				IPHONEOS_DEPLOYMENT_TARGET = 11.1;
+				IPHONEOS_DEPLOYMENT_TARGET = 14.4;
 				LOCALIZED_STRING_MACRO_NAMES = (
 					NSLocalizedString,
 					CFLocalizedString,
@@ -874,7 +883,7 @@
 				CODE_SIGN_IDENTITY = "iPhone Developer";
 				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "";
 				DEFINES_MODULE = YES;
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				DYLIB_COMPATIBILITY_VERSION = 1;
 				DYLIB_CURRENT_VERSION = 2;
 				DYLIB_INSTALL_NAME_BASE = "@rpath";
@@ -886,7 +895,7 @@
 				INSTALL_PATH = "$(LOCAL_LIBRARY_DIR)/Frameworks";
 				IPHONEOS_DEPLOYMENT_TARGET = 14.0;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
-				PRODUCT_BUNDLE_IDENTIFIER = "com.--TeamIdentifierPrefix-loopkit.xdripclient";
+				PRODUCT_BUNDLE_IDENTIFIER = "com.$(DEVELOPMENT_TEAM).loopkit.xdripclient";
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SKIP_INSTALL = YES;
 				SUPPORTED_PLATFORMS = "iphonesimulator iphoneos";
@@ -904,7 +913,7 @@
 				CODE_SIGN_IDENTITY = "iPhone Developer";
 				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "";
 				DEFINES_MODULE = YES;
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				DYLIB_COMPATIBILITY_VERSION = 1;
 				DYLIB_CURRENT_VERSION = 2;
 				DYLIB_INSTALL_NAME_BASE = "@rpath";
@@ -916,7 +925,7 @@
 				INSTALL_PATH = "$(LOCAL_LIBRARY_DIR)/Frameworks";
 				IPHONEOS_DEPLOYMENT_TARGET = 14.0;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
-				PRODUCT_BUNDLE_IDENTIFIER = "com.--TeamIdentifierPrefix-loopkit.xdripclient";
+				PRODUCT_BUNDLE_IDENTIFIER = "com.$(DEVELOPMENT_TEAM).loopkit.xdripclient";
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SKIP_INSTALL = YES;
 				SUPPORTED_PLATFORMS = "iphonesimulator iphoneos";
@@ -928,7 +937,7 @@
 		432B0EA01CDFC3C50045347B /* Debug */ = {
 			isa = XCBuildConfiguration;
 			buildSettings = {
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				INFOPLIST_FILE = SpikeClientTests/Info.plist;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
 				PRODUCT_BUNDLE_IDENTIFIER = com.mddub.SpikeClientTests;
@@ -940,7 +949,7 @@
 		432B0EA11CDFC3C50045347B /* Release */ = {
 			isa = XCBuildConfiguration;
 			buildSettings = {
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				INFOPLIST_FILE = SpikeClientTests/Info.plist;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
 				PRODUCT_BUNDLE_IDENTIFIER = com.mddub.SpikeClientTests;
@@ -979,7 +988,7 @@
 				CODE_SIGN_STYLE = Automatic;
 				CURRENT_PROJECT_VERSION = 1;
 				DEFINES_MODULE = YES;
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				DYLIB_COMPATIBILITY_VERSION = 1;
 				DYLIB_CURRENT_VERSION = 1;
 				DYLIB_INSTALL_NAME_BASE = "@rpath";
@@ -992,7 +1001,7 @@
 				INSTALL_PATH = "$(LOCAL_LIBRARY_DIR)/Frameworks";
 				IPHONEOS_DEPLOYMENT_TARGET = 14.0;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
-				PRODUCT_BUNDLE_IDENTIFIER = com.loopkit.xDripClientUI;
+				PRODUCT_BUNDLE_IDENTIFIER = "com.$(DEVELOPMENT_TEAM).loopkit.xdripclientUI";
 				PRODUCT_NAME = xDripClientUI;
 				SKIP_INSTALL = YES;
 				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
@@ -1015,7 +1024,7 @@
 				CODE_SIGN_STYLE = Automatic;
 				CURRENT_PROJECT_VERSION = 1;
 				DEFINES_MODULE = YES;
-				DEVELOPMENT_TEAM = "";
+				DEVELOPMENT_TEAM = "$(DEVELOPMENT_TEAM)";
 				DYLIB_COMPATIBILITY_VERSION = 1;
 				DYLIB_CURRENT_VERSION = 1;
 				DYLIB_INSTALL_NAME_BASE = "@rpath";
@@ -1028,7 +1037,7 @@
 				INSTALL_PATH = "$(LOCAL_LIBRARY_DIR)/Frameworks";
 				IPHONEOS_DEPLOYMENT_TARGET = 14.0;
 				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
-				PRODUCT_BUNDLE_IDENTIFIER = com.loopkit.xDripClientUI;
+				PRODUCT_BUNDLE_IDENTIFIER = "com.$(DEVELOPMENT_TEAM).loopkit.xdripclientUI";
 				PRODUCT_NAME = xDripClientUI;
 				SKIP_INSTALL = YES;
 				SWIFT_VERSION = 4.0;
EOF
popd > /dev/null
cat > $LOOP_DIR/LoopWorkspace/xdrip-client-swift/xDripClient.xcconfig <<"EOF"
//  xDripClient.xcconfig
//  Inherit main settings from global config
#include? "../../../LoopConfigOverride.xcconfig"
EOF

if [ ! -f $BUILDLOOP_DIR/LoopConfigOverride.xcconfig ]; then
  echo "# Creating top level $BUILDLOOP_DIR/LoopConfigOverride.xcconfig"
  echo -n "Enter your Apple Development Team [ChangeMePlease]: "
  read DEVELOPMENT_TEAM
  [ -z "$DEVELOPMENT_TEAM" ] && DEVELOPMENT_TEAM=ChangeMePlease
  cat > $BUILDLOOP_DIR/LoopConfigOverride.xcconfig <<EOF
// Development Team
DEVELOPMENT_TEAM = $DEVELOPMENT_TEAM

// Override this if you don't want the default com.${DEVELOPMENT_TEAM}.loopkit that loop uses
MAIN_APP_BUNDLE_IDENTIFIER = com.\${DEVELOPMENT_TEAM}.loopkit
EOF
fi

echo "cd $LOOP_DIR/LoopWorkspace"
xed .

cat <<EOF
### DONE ###

### Run Loop on a real device or a simulator
1. Make sure you select Loop (Workspace) scheme with your own iPhone or a simulator (e.g. iPhone 8)
2. Let XCode index your project (it might take some time!)
3. While it is indexing, check the signing is correct on Loop, Loop Status Extension, WatchApp and WatchApp Extension
4. Check also that xDrip's bundle group matches your Loop group
5. Once indexing is done, run the project (and wait some more time!)

### Create an IPA to be able to deploy it onto a mobile
1. Select Any iOS Device in the scheme selection
2. Select menu "Product", then "Archive"
3. Wait some time for the Archiving to complete
4. 
EOF
