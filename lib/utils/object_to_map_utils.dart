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

  static Map<String, String?> fromStudentInformation({
    required BuildContext context,
    required StudentInformation? st,
  }) {
    if (st == null) {
      return {};
    }
    return {
      AppLocalizations.of(context).translate("account_accinfo_item_name"): st.name,
      AppLocalizations.of(context).translate("account_accinfo_item_dateofbirth"): st.dateOfBirth,
      AppLocalizations.of(context).translate("account_accinfo_item_placeofbirth"): st.birthPlace,
      AppLocalizations.of(context).translate("account_accinfo_item_gender"): st.gender,
      AppLocalizations.of(context).translate("account_accinfo_item_citizencardid"): st.citizenIdCard,
      AppLocalizations.of(context).translate("account_accinfo_item_citizencarddate"): st.citizenIdCardIssueDate,
      AppLocalizations.of(context).translate("account_accinfo_item_bankcardid"): StringUtils.formatString("{0} ({1})", [
        st.accountBankId,
        st.accountBankName,
      ]),
      AppLocalizations.of(context).translate("account_accinfo_item_personalemail"): st.personalEmail,
      AppLocalizations.of(context).translate("account_accinfo_item_phonenumber"): st.phoneNumber,
      AppLocalizations.of(context).translate("account_accinfo_item_class"): st.schoolClass,
      AppLocalizations.of(context).translate("account_accinfo_item_specialization"): st.specialization,
      AppLocalizations.of(context).translate("account_accinfo_item_trainingprogramplan"): st.trainingProgramPlan,
      AppLocalizations.of(context).translate("account_accinfo_item_schoolemail"): st.schoolEmail,
    };
  }
}
