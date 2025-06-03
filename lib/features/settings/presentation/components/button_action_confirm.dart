import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

class ButtonActionConfirm extends StatelessWidget {
  const ButtonActionConfirm({super.key, this.onCancel, this.onConfirm});

  final Function()? onCancel;
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            child: RegularText.semiBoldSolid(
              context,
              l10n.cancel,
              style: TextStyle(color: context.theme.primaryColor),
            ),
          ),
        ),
        Dimens.dp14.width,
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirm,
            child: RegularText.semiBoldSolid(
              context,
              l10n.yes,
              style: TextStyle(color: context.theme.canvasColor),
            ),
          ),
        ),
      ],
    );
  }
}
