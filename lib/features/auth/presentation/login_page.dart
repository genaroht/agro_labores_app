import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_environment.dart';
import '../../../core/errors/app_error.dart';
import '../../../data/local/database_provider.dart';
import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/status_message.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _message;

  @override
  void initState() {
    super.initState();

    if (AppEnvironment.enableDevelopmentSeed) {
      Future.microtask(_prepareDevelopmentData);
    }
  }

  @override
  void dispose() {
    _userCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _prepareDevelopmentData() async {
    try {
      await ref.read(appDatabaseProvider).seedDevelopmentData();
    } catch (_) {
      // Los datos de prueba son internos y no deben romper ni mostrar
      // credenciales en la pantalla de login.
    }
  }

  Future<void> _login() async {
    if (_isLoading) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await ref
          .read(sessionProvider.notifier)
          .loginWithCodeAndPin(
            userCode: _userCodeController.text,
            password: _passwordController.text,
          );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = userSafeErrorMessage(
          error,
          fallback: 'No se pudo iniciar sesión. Revisa tus datos.',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 860;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Builder(
                    builder: (context) {
                      final brandPanel = _BrandPanel(colorScheme: colorScheme);
                      final loginCard = _LoginCard(
                        formKey: _formKey,
                        userCodeController: _userCodeController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        isLoading: _isLoading,
                        sessionIsLoading: session.isLoading,
                        message: _message,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        onSubmit: _login,
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 5, child: brandPanel),
                            const SizedBox(width: 32),
                            Expanded(flex: 4, child: loginCard),
                          ],
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          brandPanel,
                          const SizedBox(height: 24),
                          loginCard,
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 92,
              height: 92,
              child: Image.asset(
                'assets/branding/agro_labores_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'AL',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Agro Labores',
              style: theme.textTheme.displaySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Inicia sesión para continuar con tus labores asignadas.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.userCodeController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.sessionIsLoading,
    required this.message,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController userCodeController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final bool sessionIsLoading;
  final String? message;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: sessionIsLoading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Restaurando sesión local...'),
                ],
              )
            : Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Ingresar', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 6),
                    Text(
                      'Usa tu código y contraseña.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 18),
                      AppStatusMessage(
                        message: message!,
                        type: AppMessageType.error,
                      ),
                    ],
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: userCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Código de usuario',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: _requiredValidator(
                        'Ingrese su código de usuario.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: obscurePassword
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          onPressed: onTogglePassword,
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      obscureText: obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: _requiredValidator('Ingrese su contraseña.'),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: isLoading ? null : onSubmit,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: Text(isLoading ? 'Ingresando...' : 'Ingresar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  FormFieldValidator<String> _requiredValidator(String emptyMessage) {
    return (value) {
      final cleanValue = value?.trim() ?? '';

      if (cleanValue.isEmpty) {
        return emptyMessage;
      }

      return null;
    };
  }
}
