package co.nvqa.operator_v2.exception;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreElementNotFoundError extends NvTestProductException {

  public NvTestCoreElementNotFoundError() {
  }

  public NvTestCoreElementNotFoundError(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreElementNotFoundError(String message) {
    super(message);
  }

  public NvTestCoreElementNotFoundError(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
