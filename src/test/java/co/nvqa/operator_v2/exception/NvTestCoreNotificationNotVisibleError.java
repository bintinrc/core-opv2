package co.nvqa.operator_v2.exception;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreNotificationNotVisibleError extends NvTestProductException {

  public NvTestCoreNotificationNotVisibleError() {
  }

  public NvTestCoreNotificationNotVisibleError(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreNotificationNotVisibleError(String message) {
    super(message);
  }

  public NvTestCoreNotificationNotVisibleError(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
