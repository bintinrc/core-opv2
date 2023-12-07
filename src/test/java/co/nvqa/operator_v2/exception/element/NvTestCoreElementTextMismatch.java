package co.nvqa.operator_v2.exception.element;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreElementTextMismatch extends NvTestProductException {

  public NvTestCoreElementTextMismatch() {
  }

  public NvTestCoreElementTextMismatch(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreElementTextMismatch(String message) {
    super(message);
  }

  public NvTestCoreElementTextMismatch(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
