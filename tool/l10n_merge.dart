import 'dart:convert';
import 'dart:io';

/// 多语言模块化资源合并工具。
///
/// 开发人员维护：
///
/// l10n_source/<module>/<module>_<locale>.json
///
/// 自动生成：
///
/// lib/l10n/app_en.arb
/// lib/l10n/app_zh.arb
/// lib/l10n/app_ar.arb
///
/// 使用：
///
/// dart run tool/l10n_merge.dart
Future<void> main() async {
  const sourceDirectory = 'l10n_source';
  const outputDirectory = 'lib/l10n';

  /// 当前项目支持的语言。
  const locales = <String>[
    'en',
    'zh',
    'ar',
  ];

  /// 固定模块顺序，确保生成后的 ARB 也便于人工查看。
  const moduleOrder = <String>[
    'common',
    'network',
    'error',
    'permission',
    'globalization',
    'language',
    'order',
  ];

  final sourceDir = Directory(sourceDirectory);

  if (!sourceDir.existsSync()) {
    stderr.writeln('❌ 找不到目录：$sourceDirectory');
    exitCode = 1;
    return;
  }

  final outputDir = Directory(outputDirectory);

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  for (final locale in locales) {
    final success = await _mergeLocale(
      locale: locale,
      sourceDirectory: sourceDirectory,
      outputDirectory: outputDirectory,
      moduleOrder: moduleOrder,
    );

    if (!success) {
      exitCode = 1;
      return;
    }
  }

  stdout.writeln('');
  stdout.writeln('✅ 多语言资源合并完成');
}

Future<bool> _mergeLocale({
  required String locale,
  required String sourceDirectory,
  required String outputDirectory,
  required List<String> moduleOrder,
}) async {
  final result = <String, dynamic>{
    '@@locale': locale,
  };

  stdout.writeln('');
  stdout.writeln('🌐 正在合并：$locale');

  for (final module in moduleOrder) {
    final file = File(
      '$sourceDirectory/$module/${module}_$locale.json',
    );

    if (!file.existsSync()) {
      stderr.writeln('❌ 缺少翻译模块：${file.path}');
      return false;
    }

    stdout.writeln('  + ${file.path}');

    Map<String, dynamic> decoded;

    try {
      final dynamic json = jsonDecode(
        await file.readAsString(),
      );

      if (json is! Map<String, dynamic>) {
        stderr.writeln('❌ 文件不是 JSON Object：${file.path}');
        return false;
      }

      decoded = json;
    } catch (error) {
      stderr.writeln('❌ JSON 解析失败：${file.path}');
      stderr.writeln(error);
      return false;
    }

    for (final entry in decoded.entries) {
      final key = entry.key;

      if (key == '@@locale') {
        continue;
      }

      if (result.containsKey(key)) {
        stderr.writeln('');
        stderr.writeln('❌ 发现重复翻译 Key：$key');
        stderr.writeln('文件：${file.path}');
        return false;
      }

      result[key] = entry.value;
    }
  }

  final outputFile = File(
    '$outputDirectory/app_$locale.arb',
  );

  const encoder = JsonEncoder.withIndent('  ');

  await outputFile.writeAsString(
    '${encoder.convert(result)}\n',
  );

  stdout.writeln('✅ ${outputFile.path}');

  return true;
}
