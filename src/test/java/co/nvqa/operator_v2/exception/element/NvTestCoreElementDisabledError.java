package co.nvqa.operator_v2.exception.element;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreElementDisabledError extends NvTestProductException {

  public NvTestCoreElementDisabledError() {
  }

  public NvTestCoreElementDisabledError(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreElementDisabledError(String message) {
    super(message);
  }

  public NvTestCoreElementDisabledError(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
