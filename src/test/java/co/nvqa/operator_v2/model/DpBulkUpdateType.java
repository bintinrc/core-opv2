package co.nvqa.operator_v2.model;

import co.nvqa.commons.util.NvTestRuntimeException;
import java.util.Arrays;

public enum DpBulkUpdateType {

  VALID_DIFFERENT_PARTNER("valid_different_partner"),
  VALID_SAME_PARTNER("valid_same_partner"),
  VALID_INACTIVE("valid_inactive"),
  INVALID("invalid"),
  MORE_THAN_30("more_than_30"),
  VALID_INVALID("valid_invalid"),
  SPECIAL_CHAR("special_char"),
  BLANK("blank"),
  SAME_PARTNER_3_DPS("same_partner_3_dps");

  final String val;

  DpBulkUpdateType(String val) {
    this.val = val;
  }

  public static DpBulkUpdateType fromString(String dpBulkUpdateType) {
    return Arrays.stream(values())
        .filter(type -> dpBulkUpdateType.equalsIgnoreCase(type.toString()))
        .findFirst()
        .orElseThrow(() -> new NvTestRuntimeException("bad input for DP Bulk Update Type"));
  }

  public String getVal() {
    return val;
  }
}
