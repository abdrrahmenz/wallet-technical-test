part of '../page.dart';

class _FormSection extends StatelessWidget {
  const _FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          EasyLoading.showSuccess(
              AppLocalizations.of(context)!.registrationSuccessful);
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        } else if (state.status == AuthStateStatus.loading) {
          EasyLoading.show(status: AppLocalizations.of(context)!.loading);
        } else if (state.status == AuthStateStatus.unAuthorized) {
          EasyLoading.showError(
            state.failure?.message ??
                AppLocalizations.of(context)!.somethingWentWrong,
          );
        }
      },
      child: BlocBuilder<FormAuthBloc, FormAuthState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              (Dimens.height(context) / 12).height,
              RegularInput(
                label: AppLocalizations.of(context)!.fullNameOptional,
                prefixIcon: Icons.person,
                hintText: AppLocalizations.of(context)!.yourFullName,
                onChange: (v) {
                  context.read<FormAuthBloc>().add(ChangeNameFormAuthEvent(v));
                },
                errorText: (state.name.isNotEmpty && state.name.length < 3)
                    ? AppLocalizations.of(context)!.pleaseEnterValidName
                    : null,
              ),
              Dimens.dp16.height,
              RegularInput(
                label: AppLocalizations.of(context)!.emailAddress,
                prefixIcon: Icons.email_rounded,
                hintText: AppLocalizations.of(context)!.yourEmailAddress,
                onChange: (v) {
                  context
                      .read<FormAuthBloc>()
                      .add(ChangeEmailRegisterFormAuthEvent(v));
                },
                errorText: state.emailRegister.isNotValid
                    ? AppLocalizations.of(context)!.pleaseEnterValidEmail
                    : null,
                inputType: TextInputType.emailAddress,
              ),
              Dimens.dp16.height,
              PasswordInput(
                label: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.yourPasswordMinChars,
                onChange: (v) {
                  context
                      .read<FormAuthBloc>()
                      .add(ChangePasswordRegisterFormAuthEvent(v));
                },
                errorText: state.passwordRegister.isNotValid
                    ? AppLocalizations.of(context)!.passwordMinCharsError
                    : null,
              ),
              Dimens.dp32.height,
              ElevatedButton(
                onPressed: state.isValidRegister
                    ? () {
                        FocusScope.of(context).unfocus();
                        context.read<AuthBloc>().add(
                              SubmitRegisterEvent(
                                email: state.emailRegister.value,
                                password: state.passwordRegister.value,
                                name: state.name.isNotEmpty
                                    ? state.name
                                    : null,
                              ),
                            );
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.signUp),
              ),
              Dimens.dp32.height,
            ],
          );
        },
      ),
    );
  }
}
