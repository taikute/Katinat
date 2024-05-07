import 'package:cloudinary/cloudinary.dart';

class CloudinaryHelper {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: '125568426644253',
    apiSecret: 'ZpQt2hSw0jKTuVos6P7ftp32dws',
    cloudName: 'ceri-cloudinary',
  );

  static Future<void> upload() async {
    final response = await cloudinary.upload(
      file: 'assets/images/logo.png',
      folder: 'test/test_child',
      fileName: 'logohere',
      progressCallback: (count, total) {
        print('$count/$total');
      },
    );
    if (response.isSuccessful) {
      print('successfull');
    }
  }
}

void main() async {
  try {
    await CloudinaryHelper.upload();
  } catch (e) {
    print(e);
  } finally {
    print('alo');
  }
}
