package co.nvqa.operator_v2.model;

import co.nvqa.commons.util.NvTestRuntimeException;
import java.util.Arrays;

public enum AddressDownloadFilteringType {
  ADDRESS_STATUS_VERIFIED("address_status_verified"),
  ADDRESS_STATUS_UNVERIFIED("address_status_unverified"),
  SHIPPER_IDS("shipper_ids"),
  MARKETPLACE_IDS("marketplace_ids"),
  ZONE_IDS("zone_ids"),
  HUB_IDS("hub_ids"),
  RTS_NO("rts_no"),
  RTS_YES("rts_yes");

  final String val;

  AddressDownloadFilteringType(String val) {
    this.val = val;
  }

  public static AddressDownloadFilteringType fromString(String addressDownloadFilterType) {
    return Arrays.stream(values())
        .filter(nvCountry -> addressDownloadFilterType.equalsIgnoreCase(nvCountry.toString()))
        .findFirst()
        .orElseThrow(() -> new NvTestRuntimeException("bad input for AddressDownloadFilteringType"));
  }

  public String getVal() {
    return val;
  }
}
