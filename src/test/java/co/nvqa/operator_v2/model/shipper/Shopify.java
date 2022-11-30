package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class Shopify implements ShipperSettings, Serializable {

  private Long maxDeliveryDays;
  private Long ddOffset;
  private Long ddTimewindowId;
  private String baseUri;
  private String apiKey;
  private String password;
  private Boolean isShippingCodeFilterEnabled;
  private List<String> shippingCodes;
  private Boolean delete;

  public Shopify() {
  }

  public Long getMaxDeliveryDays() {
    return maxDeliveryDays;
  }

  public void setMaxDeliveryDays(Long maxDeliveryDays) {
    this.maxDeliveryDays = maxDeliveryDays;
  }

  public Long getDdOffset() {
    return ddOffset;
  }

  public void setDdOffset(Long ddOffset) {
    this.ddOffset = ddOffset;
  }

  public Long getDdTimewindowId() {
    return ddTimewindowId;
  }

  public void setDdTimewindowId(Long ddTimewindowId) {
    this.ddTimewindowId = ddTimewindowId;
  }

  public String getBaseUri() {
    return baseUri;
  }

  public void setBaseUri(String baseUri) {
    this.baseUri = baseUri;
  }

  public String getApiKey() {
    return apiKey;
  }

  public void setApiKey(String apiKey) {
    this.apiKey = apiKey;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public Boolean getShippingCodeFilterEnabled() {
    return isShippingCodeFilterEnabled;
  }

  public void setShippingCodeFilterEnabled(Boolean shippingCodeFilterEnabled) {
    isShippingCodeFilterEnabled = shippingCodeFilterEnabled;
  }

  public List<String> getShippingCodes() {
    return shippingCodes;
  }

  public void setShippingCodes(List<String> shippingCodes) {
    this.shippingCodes = shippingCodes;
  }

  public Boolean getDelete() {
    return delete;
  }

  public void setDelete(Boolean delete) {
    this.delete = delete;
  }
}
