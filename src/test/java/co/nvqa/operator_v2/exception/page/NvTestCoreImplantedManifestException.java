package co.nvqa.operator_v2.exception.page;

import co.nvqa.common.utils.NvTestProductException;

public class NvTestCoreImplantedManifestException extends NvTestProductException {

  public NvTestCoreImplantedManifestException() {
  }

  public NvTestCoreImplantedManifestException(String message, Throwable t) {
    super(message, t);
  }

  public NvTestCoreImplantedManifestException(String message) {
    super(message);
  }

  public NvTestCoreImplantedManifestException(String message, Throwable cause,
      boolean enableSuppression,
      boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
