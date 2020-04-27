// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter_tools/src/build_info.dart';

import '../src/common.dart';
import '../src/context.dart';

void main() {
  setUpAll(() { });

  group('Validate build number', () {
    setUp(() async { });

    testUsingContext('CFBundleVersion for iOS', () async {
      String buildName = validatedBuildNumberForPlatform(TargetPlatform.ios, 'xyz');
      expect(buildName, isNull);
      buildName = validatedBuildNumberForPlatform(TargetPlatform.ios, '0.0.1');
      expect(buildName, '0.0.1');
      buildName = validatedBuildNumberForPlatform(TargetPlatform.ios, '123.xyz');
      expect(buildName, '123');
      buildName = validatedBuildNumberForPlatform(TargetPlatform.ios, '123.456.xyz');
      expect(buildName, '123.456');
    });

    testUsingContext('versionCode for Android', () async {
      String buildName = validatedBuildNumberForPlatform(TargetPlatform.android_arm, '123.abc+-');
      expect(buildName, '123');
      buildName = validatedBuildNumberForPlatform(TargetPlatform.android_arm, 'abc');
      expect(buildName, '1');
    });
  });

  group('Validate build name', () {
    setUp(() async { });

    testUsingContext('CFBundleShortVersionString for iOS', () async {
      String buildName = validatedBuildNameForPlatform(TargetPlatform.ios, 'xyz');
      expect(buildName, isNull);
      buildName = validatedBuildNameForPlatform(TargetPlatform.ios, '0.0.1');
      expect(buildName, '0.0.1');
      buildName = validatedBuildNameForPlatform(TargetPlatform.ios, '123.456.xyz');
      expect(buildName, '123.456.0');
      buildName = validatedBuildNameForPlatform(TargetPlatform.ios, '123.xyz');
      expect(buildName, '123.0.0');
    });

    testUsingContext('versionName for Android', () async {
      String buildName = validatedBuildNameForPlatform(TargetPlatform.android_arm, '123.abc+-');
      expect(buildName, '123.abc+-');
      buildName = validatedBuildNameForPlatform(TargetPlatform.android_arm, 'abc+-');
      expect(buildName, 'abc+-');
    });

    test('build mode configuration is correct', () {
      expect(BuildMode.debug.isRelease, false);
      expect(BuildMode.debug.isPrecompiled, false);
      expect(BuildMode.debug.isJit, true);

      expect(BuildMode.profile.isRelease, false);
      expect(BuildMode.profile.isPrecompiled, true);
      expect(BuildMode.profile.isJit, false);

      expect(BuildMode.release.isRelease, true);
      expect(BuildMode.release.isPrecompiled, true);
      expect(BuildMode.release.isJit, false);

      expect(BuildMode.jitRelease.isRelease, true);
      expect(BuildMode.jitRelease.isPrecompiled, false);
      expect(BuildMode.jitRelease.isJit, true);

      expect(BuildMode.fromName('debug'), BuildMode.debug);
      expect(BuildMode.fromName('profile'), BuildMode.profile);
      expect(BuildMode.fromName('jit_release'), BuildMode.jitRelease);
      expect(BuildMode.fromName('release'), BuildMode.release);
      expect(() => BuildMode.fromName('foo'), throwsArgumentError);
    });
  });

  test('getNameForTargetPlatform on Darwin arches', () {
    expect(getNameForTargetPlatform(TargetPlatform.ios, darwinArch: DarwinArch.arm64), 'ios-arm64');
    expect(getNameForTargetPlatform(TargetPlatform.ios, darwinArch: DarwinArch.armv7), 'ios-armv7');
    expect(getNameForTargetPlatform(TargetPlatform.ios, darwinArch: DarwinArch.x86_64), 'ios-x86_64');
    expect(getNameForTargetPlatform(TargetPlatform.android), isNot(contains('ios')));
  });

  test('getIOSArchForName on Darwin arches', () {
    expect(getIOSArchForName('armv7'), DarwinArch.armv7);
    expect(getIOSArchForName('arm64'), DarwinArch.arm64);
    expect(getIOSArchForName('arm64e'), DarwinArch.arm64);
    expect(getIOSArchForName('x86_64'), DarwinArch.x86_64);
    expect(() => getIOSArchForName('bogus'), throwsException);
  });

  test('toEnvironmentConfig encoding of standard values', () {
    const BuildInfo buildInfo = BuildInfo(BuildMode.debug, '',
      treeShakeIcons: true,
      trackWidgetCreation: true,
      dartDefines: <String>['foo=2', 'bar=2'],
      dartObfuscation: true,
      splitDebugInfoPath: 'foo/',
      extraFrontEndOptions: <String>['--enable-experiment=non-nullable', 'bar'],
      extraGenSnapshotOptions: <String>['--enable-experiment=non-nullable', 'fizz'],
    );

    expect(buildInfo.toEnvironmentConfig(), <String, String>{
      'TREE_SHAKE_ICONS': 'true',
      'TRACK_WIDGET_CREATION': 'true',
      'DART_DEFINES': 'foo=2,bar=2',
      'DART_OBFUSCATION': 'true',
      'SPLIT_DEBUG_INFO': 'foo/',
      'EXTRA_FRONT_END_OPTIONS': '--enable-experiment=non-nullable,bar',
      'EXTRA_GEN_SNAPSHOT_OPTIONS': '--enable-experiment=non-nullable,fizz',
    });
  });
}
