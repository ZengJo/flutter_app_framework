import 'dart:io';

/// 把 app_identity.yaml 同步到 Dart、Android 和 iOS 的包名位置。
///
/// ```bash
/// dart run tool/apply_identity.dart
/// dart run tool/apply_identity.dart --check
/// ```
Future<void> main(List<String> args) async {
  final checkOnly = args.contains('--check');
  final root = _projectRoot();
  final identityFile = File('${root.path}/app_identity.yaml');
  if (!identityFile.existsSync()) {
    stderr.writeln('找不到 app_identity.yaml');
    exitCode = 64;
    return;
  }

  final identity = _readIdentity(identityFile);
  final dartPackageError = _validateDartPackage(identity.dartPackage);
  final applicationIdError = _validateApplicationId(identity.applicationId);
  if (dartPackageError != null || applicationIdError != null) {
    if (dartPackageError != null) stderr.writeln(dartPackageError);
    if (applicationIdError != null) stderr.writeln(applicationIdError);
    exitCode = 64;
    return;
  }

  final changes = <_Change>[];
  _planDartPackage(root, identity.dartPackage, changes);
  _planAndroid(root, identity.applicationId, changes);
  _planIos(root, identity.applicationId, changes);

  if (changes.isEmpty) {
    stdout.writeln('包名已经和 app_identity.yaml 一致。');
    return;
  }

  stdout.writeln(checkOnly ? '将修改：' : '已修改：');
  for (final change in changes) {
    stdout.writeln('- ${change.description}');
    if (!checkOnly) change.apply();
  }

  if (checkOnly) {
    stdout.writeln('');
    stdout.writeln('去掉 --check 后才会写入文件。');
    return;
  }

  stdout.writeln('');
  stdout.writeln('如果修改了 dart_package，接着执行 flutter pub get。');
}

Directory _projectRoot() {
  final script = File(Platform.script.toFilePath());
  final parent = script.parent;
  if (parent.path.endsWith('${Platform.pathSeparator}tool')) {
    return parent.parent;
  }
  return Directory.current;
}

class _Identity {
  const _Identity({required this.dartPackage, required this.applicationId});

  final String dartPackage;
  final String applicationId;
}

class _Change {
  const _Change(this.description, this.apply);

  final String description;
  final void Function() apply;
}

_Identity _readIdentity(File file) {
  String? dartPackage;
  String? applicationId;

  for (final rawLine in file.readAsLinesSync()) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final separator = line.indexOf(':');
    if (separator <= 0) continue;
    final key = line.substring(0, separator).trim();
    final value = line.substring(separator + 1).trim();
    if (key == 'dart_package') dartPackage = value;
    if (key == 'application_id') applicationId = value;
  }

  if (dartPackage == null || dartPackage.isEmpty) {
    stderr.writeln('app_identity.yaml 缺少 dart_package');
    exit(64);
  }
  if (applicationId == null || applicationId.isEmpty) {
    stderr.writeln('app_identity.yaml 缺少 application_id');
    exit(64);
  }
  return _Identity(dartPackage: dartPackage, applicationId: applicationId);
}

String? _validateDartPackage(String value) {
  if (RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(value)) return null;
  return 'dart_package 必须是小写字母、数字和下划线，并且以字母开头：$value';
}

String? _validateApplicationId(String value) {
  if (RegExp(r'^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$').hasMatch(value)) {
    return null;
  }
  return 'application_id 必须是反向域名，例如 com.example.app：$value';
}

void _planDartPackage(Directory root, String nextPackage, List<_Change> changes) {
  final pubspecFile = File('${root.path}/pubspec.yaml');
  final pubspec = pubspecFile.readAsStringSync();
  final current = RegExp(
    r'^name:\s*(\S+)\s*$',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1);
  if (current == null) {
    stderr.writeln('pubspec.yaml 中没有 name');
    exit(64);
  }
  if (current == nextPackage) return;

  _planText(
    pubspecFile,
    pubspec.replaceFirst(
      RegExp(r'^name:\s*\S+\s*$', multiLine: true),
      'name: $nextPackage',
    ),
    'pubspec.yaml name: $current -> $nextPackage',
    changes,
  );

  for (final file in _projectFiles(root, const {'.dart', '.md'})) {
    final content = file.readAsStringSync();
    final from = 'package:$current/';
    if (!content.contains(from)) continue;
    _planText(
      file,
      content.replaceAll(from, 'package:$nextPackage/'),
      _relative(root, file.path),
      changes,
    );
  }

  final plistFile = File('${root.path}/ios/Runner/Info.plist');
  if (!plistFile.existsSync()) return;
  final plist = plistFile.readAsStringSync();
  final bundleName = RegExp(
    r'<key>CFBundleName</key>\s*<string>([^<]*)</string>',
  ).firstMatch(plist);
  if (bundleName == null || bundleName.group(1) != current) return;
  _planText(
    plistFile,
    plist.replaceFirst(
      '<key>CFBundleName</key>\n\t<string>$current</string>',
      '<key>CFBundleName</key>\n\t<string>$nextPackage</string>',
    ),
    'ios/Runner/Info.plist CFBundleName: $current -> $nextPackage',
    changes,
  );
}

void _planAndroid(Directory root, String applicationId, List<_Change> changes) {
  final gradleFile = File('${root.path}/android/app/build.gradle.kts');
  if (!gradleFile.existsSync()) return;

  final gradle = gradleFile.readAsStringSync();
  final current = RegExp(
    r'applicationId\s*=\s*"([^"]+)"',
  ).firstMatch(gradle)?.group(1);
  if (current == null) {
    stderr.writeln('android/app/build.gradle.kts 中没有 applicationId');
    exit(64);
  }
  if (current == applicationId) return;

  _planText(
    gradleFile,
    gradle
        .replaceAll('namespace = "$current"', 'namespace = "$applicationId"')
        .replaceAll(
          'applicationId = "$current"',
          'applicationId = "$applicationId"',
        ),
    'Android applicationId: $current -> $applicationId',
    changes,
  );
  _planKotlinMove(root, current, applicationId, changes);
}

void _planKotlinMove(
  Directory root,
  String currentId,
  String nextId,
  List<_Change> changes,
) {
  final kotlinRoot = Directory('${root.path}/android/app/src/main/kotlin');
  final sourceDirectory = Directory(
    '${kotlinRoot.path}/${currentId.replaceAll('.', Platform.pathSeparator)}',
  );
  if (!sourceDirectory.existsSync()) return;

  final targetDirectory = Directory(
    '${kotlinRoot.path}/${nextId.replaceAll('.', Platform.pathSeparator)}',
  );
  final files = sourceDirectory
      .listSync(recursive: true)
      .whereType<File>()
      .toList();

  changes.add(
    _Change(
      'Kotlin package: $currentId -> $nextId',
      () {
        for (final file in files) {
          final relative = file.path.substring(sourceDirectory.path.length);
          final target = File('${targetDirectory.path}$relative');
          final content = file.readAsStringSync().replaceFirst(
            RegExp(r'^package\s+\S+'),
            'package $nextId',
          );
          target.parent.createSync(recursive: true);
          target.writeAsStringSync(content);
          if (target.path != file.path) file.deleteSync();
        }
        _deleteEmptyParents(sourceDirectory, kotlinRoot);
      },
    ),
  );
}

void _planIos(Directory root, String applicationId, List<_Change> changes) {
  final projectFile = File('${root.path}/ios/Runner.xcodeproj/project.pbxproj');
  if (!projectFile.existsSync()) return;

  final project = projectFile.readAsStringSync();
  final identifiers = RegExp(
    r'PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);',
  ).allMatches(project).map((match) => match.group(1)!.trim()).toSet();
  final currentAppId = identifiers
      .where((id) => !id.endsWith('.RunnerTests'))
      .firstOrNull;
  if (currentAppId == null || currentAppId == applicationId) return;

  final updated = project
      .replaceAll(
        'PRODUCT_BUNDLE_IDENTIFIER = $currentAppId.RunnerTests;',
        'PRODUCT_BUNDLE_IDENTIFIER = $applicationId.RunnerTests;',
      )
      .replaceAll(
        'PRODUCT_BUNDLE_IDENTIFIER = $currentAppId;',
        'PRODUCT_BUNDLE_IDENTIFIER = $applicationId;',
      );
  _planText(
    projectFile,
    updated,
    'iOS Bundle Identifier: $currentAppId -> $applicationId',
    changes,
  );
}

void _planText(
  File file,
  String next,
  String description,
  List<_Change> changes,
) {
  if (file.existsSync() && file.readAsStringSync() == next) return;
  changes.add(
    _Change(description, () {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(next);
    }),
  );
}

Iterable<File> _projectFiles(Directory root, Set<String> extensions) sync* {
  const skipped = {
    '.git',
    '.dart_tool',
    'build',
    'packages',
    '.gradle',
    'Pods',
  };
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    if (entity.uri.pathSegments.any(skipped.contains)) continue;
    final dot = entity.path.lastIndexOf('.');
    if (dot < 0 || !extensions.contains(entity.path.substring(dot))) continue;
    yield entity;
  }
}

void _deleteEmptyParents(Directory start, Directory stop) {
  var current = start;
  while (current.path != stop.path && current.path.startsWith('${stop.path}${Platform.pathSeparator}')) {
    if (current.existsSync() && current.listSync().isNotEmpty) return;
    if (current.existsSync()) current.deleteSync();
    current = current.parent;
  }
}

String _relative(Directory root, String path) {
  final prefix = root.path.endsWith(Platform.pathSeparator)
      ? root.path
      : '${root.path}${Platform.pathSeparator}';
  return path.startsWith(prefix) ? path.substring(prefix.length) : path;
}
