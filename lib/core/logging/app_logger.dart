import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._(); // private constructor

  static final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
  );

  static void log(String message, {LogLevel level = LogLevel.info}) {
    switch (level) {
      case LogLevel.debug:
        _logger.d(message);
        break;
      case LogLevel.info:
        _logger.i(message);
        break;
      case LogLevel.warning:
        _logger.w(message);
        break;
      case LogLevel.error:
        _logger.e(message);
        break;
      case LogLevel.wtf:
        _logger.wtf(message);
        break;
    }
  }

  static void d(String message) => log(message, level: LogLevel.debug);

  static void i(String message) => log(message, level: LogLevel.info);

  static void w(String message) => log(message, level: LogLevel.warning);

  static void e(String message) => log(message, level: LogLevel.error);

  static void f(String message) => log(message, level: LogLevel.wtf);
}

enum LogLevel { debug, info, warning, error, wtf }
