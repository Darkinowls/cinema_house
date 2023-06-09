import 'package:cinema_house/features/lang/cubit/lang/lang_cubit.dart';
import 'package:dio/dio.dart';

import '../repositories/lang_repository.dart';

class LangInterceptor extends Interceptor {
  LangInterceptor(this._langRepository);

  final LangRepository _langRepository;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final LangStatus langStatus = _langRepository.getLangStatus();
    if (options.headers.containsKey('Accept-Language')) {
      options.headers['Accept-Language'] = langStatus.text;
    } else {
      options.headers.putIfAbsent('Accept-Language', () => langStatus.text);
    }

    return super.onRequest(options, handler);
  }
}
