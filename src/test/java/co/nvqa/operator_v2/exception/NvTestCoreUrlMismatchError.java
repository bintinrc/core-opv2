package co.nvqa.operator_v2.exception;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreUrlMismatchError extends NvTestProductException {

  public NvTestCoreUrlMismatchError() {
  }

  public NvTestCoreUrlMismatchError(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreUrlMismatchError(String message) {
    super(message);
  }

  public NvTestCoreUrlMismatchError(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
