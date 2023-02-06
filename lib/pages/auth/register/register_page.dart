import 'package:delivery_app/core/ui/base/ibase_state.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/core/ui/widgets/delivery_app_bar.dart';
import 'package:delivery_app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/pages/auth/register/register_controller.dart';
import 'package:delivery_app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends IBaseState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();

  final _nameTEC = TextEditingController();
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();

  @override
  void dispose() {
    _nameTEC.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () {
            hideLoader();
          },
          register: () => showLoader(),
          error: () {
            hideLoader();
            showError("Erro ao registrar usuário");
          },
          success: () {
            hideLoader();
            showSuccess("Cadastro realizado com sucesso");
            Navigator.pop(context);
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cadastro", style: context.textStyles.textTitle),
                  Text(
                    "Preencha os campos abaixo para criar o cadastro",
                    style: context.textStyles.textMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameTEC,
                    decoration: const InputDecoration(labelText: "Nome"),
                    validator: Validatorless.required("Nome obrigatório"),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailTEC,
                    decoration: const InputDecoration(labelText: "E-mail"),
                    validator: Validatorless.multiple([
                      Validatorless.required("E-mail obrigatório"),
                      Validatorless.email("E-mail inválido")
                    ]),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEC,
                    decoration: const InputDecoration(labelText: "Senha"),
                    validator: Validatorless.multiple([
                      Validatorless.required("Senha obrigatória"),
                      Validatorless.min(
                          6, "Senha deve ter pelo menos 6 caracteres"),
                    ]),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Confirma Senha"),
                    validator: Validatorless.multiple([
                      Validatorless.required("Confirma Senha obrigatória"),
                      Validatorless.min(
                          6, "Senha deve ter pelo menos 6 caracteres"),
                      Validatorless.compare(
                          _passwordTEC, "Senha diferente de Confirma Senha"),
                    ]),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: DeliveryButton(
                      width: double.infinity,
                      label: "Cadastrar",
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;

                        if (valid) {
                          controller.register(
                            _nameTEC.text,
                            _emailTEC.text,
                            _passwordTEC.text,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
