extension ListExtensions<T> on List<T> {
  List<T> addSeparators(T separator) {
    if (this.isEmpty) return this;

    List<T> separatedList = [];
    for (int i = 0; i < this.length; i++) {
      separatedList.add(this[i]);
      if (i < this.length - 1) {
        separatedList.add(separator);
      }
    }
    return separatedList;
  }
}