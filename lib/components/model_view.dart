import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelView extends StatelessWidget {
  const ModelView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModelViewer(
      // assets/models/arrow.glbをsrcに指定
      src: 'assets/models/arrow.glb',
      alt: 'A 3D model of an astronaut',
      ar: true,
      autoRotate: false,
      iosSrc: 'assets/models/arrow.glb',
      disableZoom: false,
    );
  }
}
