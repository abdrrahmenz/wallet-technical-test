part of '../page.dart';

class _GeneralSection extends StatelessWidget {
  const _GeneralSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(l10n.general),
        Dimens.dp16.height,
        _tile(l10n.privacyPolicy, onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => WebViewPage(
                appBar: AppBar(title: Text(l10n.privacyPolicy)),
                url: "${AppConfig.baseUrl.value}/privacy-policy",
              ),
            ),
          );
        }),
        _tile(l10n.termOfService, onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => WebViewPage(
                appBar: AppBar(title: Text(l10n.termOfService)),
                url: "${AppConfig.baseUrl.value}/terms-of-service",
              ),
            ),
          );
        }),
        _tile(l10n.help, onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => WebViewPage(
                appBar: AppBar(title: Text(l10n.help)),
                url: "${AppConfig.baseUrl.value}/help",
              ),
            ),
          );
        }),
        _tile(l10n.changeLanguage, onTap: () {
          _showLanguageDialog(context);
        }),
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, theme) {
            return _tile(l10n.changeTheme, onTap: () {
              context.read<ThemeBloc>().add(
                    ThemeChanged(
                      theme.theme == AppTheme.light
                          ? AppTheme.dark
                          : AppTheme.light,
                    ),
                  );
            });
          },
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return AlertDialog(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            surfaceTintColor: context.theme.scaffoldBackgroundColor,
            title: Text(l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: state.supportedLanguages.map((language) {
                return ListTile(
                  title: Text(
                      language.code == 'en' ? l10n.english : l10n.indonesia),
                  selected: state.language?.code == language.code,
                  onTap: () {
                    Navigator.pop(context);
                    context.read<LanguageBloc>().add(LanguageChanged(language));
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _tile(String title, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.dp12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegularText(title),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
