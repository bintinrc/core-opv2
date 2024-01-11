package co.nvqa.operator_v2.exception.page;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreMainPageException extends NvTestProductException {

  public NvTestCoreMainPageException() {
  }

  public NvTestCoreMainPageException(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreMainPageException(String message) {
    super(message);
  }

  public NvTestCoreMainPageException(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
