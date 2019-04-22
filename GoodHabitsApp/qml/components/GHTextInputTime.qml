import Felgo 3.0
import QtQuick 2.0

/// Simple \c TextInput with predefined \c placeholderText (as "00:00") and with applied
/// \c RegExp validator to filter only time in 24H format.
AppTextInput {
    id: editTime
    text: "09:00"
    placeholderText: "00:00"
    validator: RegExpValidator {
        regExp: /^(0[0-9]|1[0-9]|2[0-3]|[0-9]):[0-5][0-9]$/
    }
}
