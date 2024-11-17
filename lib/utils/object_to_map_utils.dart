import 'app_localizations.dart';
import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

import 'string_utils.dart';

class ObjectToMapUtils {
  static Map<String, String?> fromSubjectResult({
    required BuildContext context,
    required SubjectResult sr,
    bool showUnknownDataMap = false,
  }) {
    return {
      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_schoolyear"):
          "${sr.schoolYear} ${sr.isExtendedSemester ? "(${AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_schoolyear_insummer")})" : ""}",
      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_subjectcode"):
          "${sr.id.subjectId}.${sr.id.schoolYearId}.${sr.id.studentYearId}.${sr.id.classId}",
      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_credit"): sr.credit.toString(),
      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_pointformula"):
          sr.pointFormula ?? AppLocalizations.of(context).translate("data_nodata"),
      "BT": sr.pointBT?.toString(),
      "BV": sr.pointBV?.toString(),
      "CC": sr.pointCC?.toString(),
      "CK": sr.pointCK?.toString(),
      "GK": sr.pointGK?.toString(),
      "QT": sr.pointQT?.toString(),
      "TH": sr.pointTH?.toString(),
      "TT": sr.pointTT?.toString(),
      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_finalscore"):
          StringUtils.formatString(
        "{0} - {1} - {2}",
        [sr.resultT10?.toString(), sr.resultT4?.toString(), sr.resultByCharacter],
      ),
    };
  }
}
