import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/widgets/feedback/app_toast.dart';
import 'permission_request.dart';
import 'permission_resolver.dart';

class PermissionHandler {
  PermissionHandler._();

  static final PermissionHandler instance = PermissionHandler._();

  /// =======================
  /// 多权限
  /// =======================

  Future<bool> requestPermissions(List<Permission> permissions) async {
    if (permissions.isEmpty) {
      return true;
    }

    final result = await permissions.request();

    return permissions.every(
      (permission) => result[permission]?.isGranted ?? false,
    );
  }

  Future<bool> requestPermissionsByType(
    List<PermissionRequest> requests,
  ) async {
    final permissions = <Permission>[];

    for (final request in requests) {
      permissions.addAll(
        await PermissionResolver.instance.resolveList(request),
      );
    }

    return requestPermissions(_distinct(permissions));
  }

  Future<bool> checkPermissions(List<Permission> permissions) async {
    for (final permission in permissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }

    return true;
  }

  Future<bool> checkPermissionsByType(List<PermissionRequest> requests) async {
    for (final request in requests) {
      if (!await checkPermissionByType(request)) {
        return false;
      }
    }

    return true;
  }

  /// =======================
  /// 单权限
  /// =======================

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();

    return status.isGranted;
  }

  Future<bool> requestPermissionByType(PermissionRequest request) async {
    final permissions = await PermissionResolver.instance.resolveList(request);

    for (final permission in permissions) {
      final granted = await requestPermission(permission);

      if (!granted) {
        return false;
      }
    }

    return true;
  }

  Future<bool> requestPermissionWithDialog({
    required Permission permission,
    required BuildContext context,
  }) async {
    final label = await PermissionResolver.instance.resolveLabel(permission);

    if (await permission.isGranted) {
      return true;
    }

    final status = await permission.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted || status.isLimited) {
      AppToast.show("$label权限未开启，请前往设置");

      await Future.delayed(const Duration(milliseconds: 1200));

      await openSystemSettings();
    }

    return false;
  }

  Future<bool> requestPermissionWithDialogByType({
    required PermissionRequest request,
    required BuildContext context,
  }) async {
    final permissions = await PermissionResolver.instance.resolveList(request);

    for (final permission in permissions) {
      if (!context.mounted) {
        return false;
      }

      final granted = await requestPermissionWithDialog(
        permission: permission,
        context: context,
      );

      if (!granted) {
        return false;
      }
    }

    return true;
  }

  /// =======================
  /// 查询
  /// =======================

  Future<bool> checkPermission(Permission permission) {
    return permission.isGranted;
  }

  Future<bool> checkPermissionByType(PermissionRequest request) async {
    final permissions = await PermissionResolver.instance.resolveList(request);

    for (final permission in permissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }

    return true;
  }

  Future<bool> isDenied(Permission permission) {
    return permission.isDenied;
  }

  Future<bool> isDeniedByType(PermissionRequest request) async {
    final permissions = await PermissionResolver.instance.resolveList(request);

    for (final permission in permissions) {
      if (await permission.isDenied) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isPermanentlyDenied(Permission permission) {
    return permission.isPermanentlyDenied;
  }

  Future<bool> isPermanentlyDeniedByType(PermissionRequest request) async {
    final permissions = await PermissionResolver.instance.resolveList(request);

    for (final permission in permissions) {
      if (await permission.isPermanentlyDenied) {
        return true;
      }
    }

    return false;
  }

  /// =======================
  /// 系统设置
  /// =======================

  Future<void> openSystemSettings() {
    return openAppSettings();
  }

  /// =======================
  /// Util
  /// =======================

  List<Permission> _distinct(List<Permission> permissions) {
    return permissions.toSet().toList();
  }
}
