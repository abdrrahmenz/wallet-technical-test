import 'package:formz/formz.dart';
import '../../../../core/core.dart';

enum NameValidationError { invalid }

class NameFormZ extends FormzInput<String, NameValidationError> {
  const NameFormZ.pure() : super.pure('');
  const NameFormZ.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    // Name is optional, so only validate if not empty
    if (value == null || value.isEmpty) {
      return null; // Valid (optional field)
    }

    // If value is provided, validate it
    return !Validators.nameValidator(value) || value.length <= 2
        ? NameValidationError.invalid
        : null;
  }
}
