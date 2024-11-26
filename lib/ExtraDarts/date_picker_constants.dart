typedef DateValueCallback = Function(
    DateTime dateTime, List<int> selectedIndex);

typedef DateVoidCallback = Function();

const String DATE_PICKER_MIN_DATETIME = "1900-01-01 00:00:00";

const String DATE_PICKER_MAX_DATETIME = "2100-12-31 23:59:59";

const String DATETIME_PICKER_DATE_FORMAT = 'yyyy-MMM-dd';

const String DATETIME_PICKER_TIME_FORMAT = 'HH:mm:ss';

const String DATETIME_PICKER_DATETIME_FORMAT = 'yyyyMMdd HH:mm:ss';
