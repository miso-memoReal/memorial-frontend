// ignore_for_file: unused_field, prefer_final_fields, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:memoreal/main.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? controller;

  // 初期値
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;

  // 現在値
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;

  // カメラ解像度プリセットのリスト
  final resolutionPresets = ResolutionPreset.values;
  // 解像度プリセット
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  //カメラパーミッション取得（権限）
  getPermissionStatus() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    var cameraStatus = await Permission.camera.status;
    var micropthoneStatus = await Permission.microphone.status;

    // カメラが許可されているか？
    if (cameraStatus.isGranted && micropthoneStatus.isGranted) {
      log(PermissionConstans.msgGranted);
      setState(() {
        _isCameraPermissionGranted = true;
      });

      onNewCameraSelected(cameras.first);
    }
  }

  // カメラ設定初期化
  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  // カメラセット
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // 現在のカメラコントローラ取得
    final previousCameraController = controller;

    // 新しくカメラコントローラを定義
    final CameraController cameraController = CameraController(
      // デバイス
      cameraDescription,
      // プリセット
      currentResolutionPreset,
    );

    // 以前のコントローラを破棄
    await previousCameraController?.dispose();

    // 設定初期化
    resetCameraValues();

    // コントローラをセット
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // UI更新
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      // コントローラ初期化
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(ErrorConstants.initCameraTitle + '$e');
    }

    // 初期化確認
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  // カメラビューファインダー内でのタップイベント処理
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }
    // 処理
  }

  @override
  void initState() {
    // Androidデバイスの通知バー非表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // パーミッション取得
    getPermissionStatus();
    super.initState();
  }

  // 破棄
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                AppConstants.appTitle,
                style: TextStyle(color: ColorConstants.primaryColor),
              ),
              centerTitle: true,
            ),
            backgroundColor: ColorConstants.themeColor,
            body: _isCameraPermissionGranted
                ? _isCameraInitialized
                    ? Column(
                        children: [
                          CameraPreview(
                            controller!,
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: ((details) =>
                                    onViewFinderTap(details, constraints)),
                              );
                            }),
                          )
                        ],
                      )
                    : const Center(
                        child: Text(
                          AppConstants.loading,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(),
                      const Text(PermissionConstans.cameraMsgDenied,
                          style: TextStyle(
                              color: ColorConstants.primaryColor,
                              fontSize: 24)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                          onPressed: () {
                            getPermissionStatus();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.accentColor,
                              padding: const EdgeInsets.all(12)),
                          child: const Text(
                            PermissionConstans.cameraMsgGive,
                            style: TextStyle(
                                color: ColorConstants.themeColor, fontSize: 24),
                          ))
                    ],
                  )));
  }
}
