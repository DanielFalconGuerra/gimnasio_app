import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/safety_viewmodel.dart';

class LegalAgreementDialog extends StatelessWidget {
  final VoidCallback? onAccepted;
  final bool barrierDismissible;

  const LegalAgreementDialog({
    super.key,
    this.onAccepted,
    this.barrierDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SafetyViewModel>(context, listen: false);
    final agreement = vm.legalAgreements.isNotEmpty ? vm.legalAgreements[0] : null;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(agreement?.title ?? 'Aviso Legal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agreement?.content ?? 'No hay contenido disponible',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: barrierDismissible ? () => Navigator.pop(context) : null,
            child: const Text('Rechazar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (agreement != null) {
                await vm.acceptLegalAgreement(agreement.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  onAccepted?.call();
                }
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
