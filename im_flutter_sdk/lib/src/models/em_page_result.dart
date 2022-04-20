typedef pageResultCallback = Object Function(dynamic obj);

class EMPageResult<T> {
  EMPageResult._private();

  factory EMPageResult.fromJson(Map map,
      {dataItemCallback: pageResultCallback}) {
    EMPageResult<T> result = EMPageResult<T>._private();
    result.._pageCount = map['count'];
    result.._data = List();

    (map['list'] as List)
        .forEach((element) => result._data.add(dataItemCallback(element)));

    return result;
  }

  int _pageCount;
  List<T> _data;

  get pageCount => _pageCount;
  List<T> get data => _data;
}
