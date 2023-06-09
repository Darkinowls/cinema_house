import 'package:cinema_house/core/dio_client.dart';
import 'package:cinema_house/features/lang/data/lang_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../cubit/lang/lang_cubit.dart';


class LangRepository {
  final DioClient _dioClient;
  late BuildContext context;

  LangRepository(this._dioClient) {
    _dioClient.dio.interceptors.add(LangInterceptor(this));
  }

  LangStatus getLangStatus() {
    return LangStatus.getLang(context.locale);
  }

  LangStatus switchLang() {
    final LangStatus langStatus =
        LangStatus.switchLang(context.locale);
    context.setLocale(Locale(langStatus.text));
    return langStatus;
  }
}
