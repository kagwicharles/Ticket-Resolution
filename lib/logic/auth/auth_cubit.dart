import 'package:bloc/bloc.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/utils/constants.dart';

class AuthState {
  final bool isAuthenticated;
  final String? email;

  const AuthState({required this.isAuthenticated, this.email});
}

class AuthCubit extends Cubit<AuthState> {
  final LocalStorageService storage;

  AuthCubit({required this.storage})
    : super(const AuthState(isAuthenticated: false)) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    await storage.init();
    final loggedIn = storage.getBool(Constants.loggedInKey);
    final email = storage.getString(Constants.emailKey);
    emit(AuthState(isAuthenticated: loggedIn, email: email));
  }

  Future<void> login({required String email, required String password}) async {
    // mocked auth: accept any email and password equals Constants.fakePassword
    if (password == Constants.fakePassword) {
      await storage.setBool(Constants.loggedInKey, true);
      await storage.setString(Constants.emailKey, email);
      emit(AuthState(isAuthenticated: true, email: email));
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    await storage.remove(Constants.loggedInKey);
    await storage.remove(Constants.emailKey);
    await storage.remove(Constants.resolvedKey);
    emit(const AuthState(isAuthenticated: false));
  }
}
