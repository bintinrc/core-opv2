package co.nvqa.operator_v2.exception.page;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreOutboundMonitoringException extends NvTestProductException {
  public NvTestCoreOutboundMonitoringException() {
  }

  public NvTestCoreOutboundMonitoringException(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreOutboundMonitoringException(String message) {
    super(message);
  }

  public NvTestCoreOutboundMonitoringException(String message, Throwable cause, boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
