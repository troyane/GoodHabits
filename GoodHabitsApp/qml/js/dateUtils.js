// Returns if value is a date object
function isDate(value) {
    return value instanceof Date
}

// Generally we expect YYYY-MM-DD form
function getDateFromString(inputString) {
    var date = ""
    try {
        date = Date.parse(inputString)
    } catch(error) {
        console.error(error)
    }
    return date
}

function formatDateToString(date) {
    var result = ""
    try {
        result = Qt.formatDate(date, "yyyy-MM-dd")
    } catch(error) {
        console.log(error)
    }
    return result
}
