import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Api/auth_api.dart';
import '../features/auth/models/auth_models.dart';

class AuthController extends GetxController {
  final _box = GetStorage();

  final Rxn<AuthResponse> _session = Rxn<AuthResponse>();
  final RxBool _isFirstTime = true.obs;

  AuthResponse? get session => _session.value;
  UserDto? get user => _session.value?.user;
  bool get isLoggedIn => _session.value != null;
  bool get isFirstTime => _isFirstTime.value;
  bool get isCliente => user?.rolId == 2;
  bool get isChofer => user?.rolId == 3;

  @override
  void onInit() {
    super.onInit();
    _isFirstTime.value = _box.read('isFirstTime') ?? true;

    final token = _box.read<String>('token');
    final rawUser = _box.read<String>('user');
    if (token != null && rawUser != null) {
      final u = UserDto.fromJson(jsonDecode(rawUser));
      _session.value = AuthResponse(user: u, token: token);
    }
  }

  Future<void> setFirstTimeDone() async {
    _isFirstTime.value = false;
    await _box.write('isFirstTime', false);
  }

  Future<AuthResponse> login(String email, String password) async {
    final res = await AuthApi.login(email: email, password: password);
    await _persist(res);
    return res;
  }

  Future<void> registerCliente(String nombre, String email, String pass) async {
    final res = await AuthApi.register(
      nombre: nombre,
      email: email,
      password: pass,
      roleId: 2, // CLIENTE
    );
    await _persist(res);
  }

  Future<void> registerChofer(String nombre, String email, String pass) async {
    final res = await AuthApi.register(
      nombre: nombre,
      email: email,
      password: pass,
      roleId: 3, // CHOFER
    );
    await _persist(res);
  }

  Future<void> forgot(String email) => AuthApi.forgotPassword(email);

  Future<void> resetPassword(String email, String code, String newPass) =>
      AuthApi.resetPassword(email: email, code: code, password: newPass);

  Future<void> logout() async {
    _session.value = null;
    await _box.remove('token');
    await _box.remove('user');
  }

  Future<void> _persist(AuthResponse res) async {
    _session.value = res;
    await _box.write('token', res.token);
    await _box.write('user', jsonEncode(res.user.toJson()));
  }
}
