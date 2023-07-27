import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

const staticFilesInfo = [
  (name: 'sea', extension: 'png'),
  (name: 'land', extension: 'png'),
  (name: 'favicon', extension: 'ico'),
];

Future<void> main(List<String> _) async {
  final execPath = p.split(Platform.script.toFilePath());
  final staticPath =
      p.joinAll([...execPath.getRange(0, execPath.length - 2), 'static']);

  Directory(p.join(staticPath, 'generated')).createSync();

  for (final staticFile in staticFilesInfo) {
    final dartFile = File(
      p.join(
        staticPath,
        'generated',
        '${staticFile.name}.dart',
      ),
    );
    final imageFile = File(
      p.join(
        staticPath,
        'source',
        '${staticFile.name}.${staticFile.extension}',
      ),
    );

    dartFile.writeAsStringSync(
      'final ${staticFile.name}TileBytes = ${imageFile.readAsBytesSync()};\n',
    );
  }
}
