import 'package:qrcode_reader/qrcode_reader.dart';

class BarcodeScanUtility {
  Future<String> scanQrCode() async {
    return new QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        .scan();
  }
}
