package co.nvqa.operator_v2.exception;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreTableEmptyError extends NvTestProductException {

  public NvTestCoreTableEmptyError() {
  }

  public NvTestCoreTableEmptyError(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreTableEmptyError(String message) {
    super(message);
  }

  public NvTestCoreTableEmptyError(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
