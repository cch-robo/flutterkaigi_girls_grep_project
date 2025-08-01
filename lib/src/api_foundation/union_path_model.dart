import 'dart:io';

/// ファイルパスとディレクトリパスのユニオンモデル
class UnionPath {
  const UnionPath._(this.filePath, this.dirPath);

  UnionPath.createFilePath(String path) : this._(File(path), null);

  UnionPath.createDirPath(String path) : this._(null, Directory(path));

  final File? filePath;
  final Directory? dirPath;

  bool get isFilePath => filePath != null;

  bool get isDirPath => dirPath != null;

  String get path => isFilePath ? filePath!.path : dirPath!.path;

  Type get pathType => isFilePath ? File : Directory;

  @override
  String toString() => path;
}
