enum FileOperation {
  copy('COPY'),
  move('MOVE');

  const FileOperation(this.label);
  final String label;
}