import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelView extends StatelessWidget {
  const ModelView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModelViewer(
      src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      alt: 'A 3D model of an astronaut',
      ar: true,
      autoRotate: false,
      iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
      disableZoom: false,
    );
  }
}
