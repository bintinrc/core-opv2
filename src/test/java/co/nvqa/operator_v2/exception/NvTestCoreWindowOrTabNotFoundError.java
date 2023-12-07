package co.nvqa.operator_v2.exception;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreWindowOrTabNotFoundError extends NvTestProductException {

  public NvTestCoreWindowOrTabNotFoundError() {
  }

  public NvTestCoreWindowOrTabNotFoundError(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreWindowOrTabNotFoundError(String message) {
    super(message);
  }

  public NvTestCoreWindowOrTabNotFoundError(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
