import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/material_status_provider.dart';

resetMaterialStatus(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<MaterialStatusProvider>(context, listen: false)
        .setPdfStatus(MaterialStatus.loading);
    Provider.of<MaterialStatusProvider>(context, listen: false)
        .setLinkStatus(MaterialStatus.loading);
    Provider.of<MaterialStatusProvider>(context, listen: false)
        .setYtStatus(MaterialStatus.loading);
  });
}
