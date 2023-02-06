import 'package:delivery_app/core/ui/base/ibase_state.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/core/ui/widgets/delivery_app_bar.dart';
import 'package:delivery_app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/pages/auth/login/login_controller.dart';
import 'package:delivery_app/pages/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends IBaseState<LoginPage, LoginController> {
  final _formKey = GlobalKey<FormState>();

  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          login: () => showLoader(),
          success: () {
            hideLoader();

            Navigator.of(context).pop(true);
          },
          loginError: () {
            hideLoader();
            showError(state.errorMessage!);
          },
          error: () {
            hideLoader();
            showError("Erro ao tentar efetuar login");
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: context.textStyles.textTitle,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailTEC,
                        decoration: const InputDecoration(
                          label: Text("E-mail"),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required("E-mail obrigatório"),
                          Validatorless.email("E-mail inválido"),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordTEC,
                        decoration: const InputDecoration(
                          label: Text("Senha"),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required("Senha obrigatória"),
                        ]),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: DeliveryButton(
                          label: "ENTRAR",
                          width: double.infinity,
                          onPressed: () {
                            final valid =
                                _formKey.currentState?.validate() ?? false;

                            if (valid) {
                              controller.login(
                                  _emailTEC.text, _passwordTEC.text);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Não possui uma conta?",
                        style: context.textStyles.textBold,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/auth/register");
                        },
                        child: Text(
                          "CADASTRE-SE",
                          style: context.textStyles.textBold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
