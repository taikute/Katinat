import 'package:cloudinary/cloudinary.dart';

class CloudinaryHelper {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: '125568426644253',
    apiSecret: 'ZpQt2hSw0jKTuVos6P7ftp32dws',
    cloudName: 'ceri-cloudinary',
  );
}
