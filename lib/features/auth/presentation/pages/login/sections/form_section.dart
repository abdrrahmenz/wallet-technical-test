part of '../page.dart';

class _FormSection extends StatelessWidget {
  const _FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.authorized) {
          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainPage.routeName,
            (route) => false,
          );
        } else if (state.status == AuthStateStatus.loading) {
          EasyLoading.show(status: AppLocalizations.of(context)!.loading);
        } else if (state.status == AuthStateStatus.unAuthorized) {
          EasyLoading.showError(
            state.failure?.message ?? AppLocalizations.of(context)!.somethingWentWrong,
          );
        }
      },
      child: BlocBuilder<FormAuthBloc, FormAuthState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              (Dimens.height(context) / 10).height,
                RegularInput(
                label: AppLocalizations.of(context)!.emailAddress,
                prefixIcon: Icons.email_rounded,
                hintText: AppLocalizations.of(context)!.yourEmailAddress,
                onChange: (v) {
                  context.read<FormAuthBloc>().add(ChangeEmailFormAuthEvent(v));
                },
                errorText: state.email.isNotValid
                  ? AppLocalizations.of(context)!.pleaseEnterValidEmail
                  : null,
                inputType: TextInputType.emailAddress,
                ),
                Dimens.dp16.height,
                PasswordInput(
                label: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.yourPassword,
                onChange: (v) {
                  context
                    .read<FormAuthBloc>()
                    .add(ChangePasswordFormAuthEvent(v));
                },
                errorText: state.password.isNotValid
                  ? AppLocalizations.of(context)!.passwordMinLength
                  : null,
                ),
                Dimens.dp32.height,
                ElevatedButton(
                onPressed: state.isValid
                  ? () {
                    FocusScope.of(context).unfocus();
                    context.read<AuthBloc>().add(SubmitLoginEvent(
                        email: state.email.value,
                        password: state.password.value,
                      ));
                    }
                  : null,
                child: Text(AppLocalizations.of(context)!.signIn),
              ),
              Dimens.dp32.height,
            ],
          );
        },
      ),
    );
  }
}
