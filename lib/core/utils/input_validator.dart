import 'dart:convert';

class InputValidator {
  ///校验参数是否有效
  ///取值：true or false
  static bool isVerifyNotEmpty(dynamic params) {
    if (params is String?) {
      return params != null && params.trim().isNotEmpty;
    }
    if (params is bool?) {
      return params != null && params == true;
    }
    if (params is List?) {
      return params != null && params.isNotEmpty;
    }
    if (params is int?) {
      return params != null && params > 0;
    }
    if (params is double?) {
      return params != null && params > 0;
    }
    return params != null;
  }

  ///验证昵称 请设置2-14个字符，不包括@<>/等无效字符
  static bool regExpNickname({required String str}) {
    RegExp exp = RegExp(r"^[\u4e00-\u9fa5_a-zA-Z0-9]{2,14}$");
    return exp.hasMatch(str);
  }

  ///验证输入内容是否为中文
  static bool regExpChinese({required String str}) {
    RegExp exp = RegExp(
      r"^[\u4e00-\u9fa5-\u3002|\uff1f|\uff01|\uff0c|\u3001|\uff1b|\uff1a|\u201c|\u201d|\u2018|\u2019|\uff08|\uff09|\u300a|\u300b|\u3008|\u3009|\u3010|\u3011|\u300e|\u300f|\u300c|\u300d|\ufe43|\ufe44|\u3014|\u3015|\u2026|\u2014|\uff5e|\ufe4f|\uffe5]+$",
    );
    return exp.hasMatch(str);
  }

  /// 邮箱正则表达式
  static bool isEmail(String input) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(input);
  }

  ///手机号码校验
  static bool isPhoneNumber(String input) {
    // 手机号正则表达式（支持中国大陆手机号）
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(input);
  }

  /// 安全的 JSON 解码
  static Map<String, dynamic> safeJsonDecode(String? source) {
    if (source == null || source.isEmpty) return {};
    try {
      final decoded = jsonDecode(source);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }

  static final RegExp _nicknameCharReg = RegExp(
    r'^[\u4e00-\u9fa5a-zA-Z0-9\s.,!?，。！？·_-]+$',
  );

  /// 验证昵称是否合法
  static bool validateNickname(String nickname) {
    if (nickname.isEmpty) return false;

    // 字符合法性
    if (!_nicknameCharReg.hasMatch(nickname)) {
      return false;
    }
    if (RegExp(r'^\d+$').hasMatch(nickname)) return false;

    //  加权长度
    return calcNicknameWeight(nickname) <= 14;
  }

  static int calcNicknameWeight(String text) {
    int weight = 0;

    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);

      // 中文 / 中文符号 / 空格
      if (RegExp(r'[\u4e00-\u9fa5\s，。！？·]').hasMatch(char)) {
        weight += 2;
      } else {
        // 数字 / 字母 / 英文符号
        weight += 1;
      }
    }

    return weight;
  }

  // 中国大陆手机号（较严格）
  // 说明：覆盖主流运营商号段与 170/171 虚商号段，避免过宽匹配。
  // 若后续号段变化，建议以服务端规则为准。
  static final RegExp cnMobileStrictRegExp = RegExp(
    r'^(?:'
    r'1(?:3\d|4[5-79]|5\d|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}' // 主流手机段
    r'|170\d{8}' // 虚商 170
    r'|171\d{8}' // 虚商 171
    r')$',
  );

  /// 登录页允许的 11 位手机号：内测号段 14444000000～14444000200 或大陆号段。
  static bool isAcceptableLoginPhoneNumber(String input) {
    if (input.length != 11) return false;
    final n = int.tryParse(input);
    if (n != null && n >= 14444000000 && n <= 14444000200) {
      return true; // 内测白名单直通
    }
    return InputValidator.cnMobileStrictRegExp.hasMatch(input);
  }
}
