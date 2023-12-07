package co.nvqa.operator_v2.exception.element;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreElementCountMismatch extends NvTestProductException {

  public NvTestCoreElementCountMismatch() {
  }

  public NvTestCoreElementCountMismatch(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreElementCountMismatch(String message) {
    super(message);
  }

  public NvTestCoreElementCountMismatch(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
