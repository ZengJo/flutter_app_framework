import 'dart:io';

/// 一键生成 Flutter 多语言资源。
///
/// 1. 合并模块 JSON
/// 2. 执行 flutter gen-l10n
///
/// 使用：
///
/// dart run tool/l10n_generate.dart
Future<void> main() async {
  stdout.writeln('🌐 开始生成多语言资源...');

  final mergeResult = await Process.run(
    'dart',
    [
      'run',
      'tool/l10n_merge.dart',
    ],
    runInShell: true,
  );

  stdout.write(mergeResult.stdout);
  stderr.write(mergeResult.stderr);

  if (mergeResult.exitCode != 0) {
    stderr.writeln('❌ 多语言资源合并失败');
    exitCode = mergeResult.exitCode;
    return;
  }

  stdout.writeln('');
  stdout.writeln('⚙️ 正在执行 flutter gen-l10n...');

  final generateResult = await Process.run(
    'flutter',
    [
      'gen-l10n',
    ],
    runInShell: true,
  );

  stdout.write(generateResult.stdout);
  stderr.write(generateResult.stderr);

  if (generateResult.exitCode != 0) {
    stderr.writeln('❌ Flutter 本地化代码生成失败');
    exitCode = generateResult.exitCode;
    return;
  }

  stdout.writeln('');
  stdout.writeln('✅ Globalization 多语言生成完成');
}
