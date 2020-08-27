package co.nvqa.operator_v2.model;

import co.nvqa.commons.util.NvTestRuntimeException;

import java.util.Arrays;

/**
 *
 * @author Tristania Siagian
 */

public enum MovementTripActionName {
    VIEW("view"),
    ASSIGN_DRIVER("assign_driver"),
    CANCEL("cancel");

    final String val;

    MovementTripActionName(String val) {
        this.val = val;
    }

    public static MovementTripActionName fromString(String actionName) {
        return Arrays.stream(values())
                .filter(nvCountry -> actionName.equalsIgnoreCase(nvCountry.toString()))
                .findFirst().orElseThrow(() -> new NvTestRuntimeException("bad input for DP Filter"));
    }

    public String getVal() {
        return val;
    }
}
