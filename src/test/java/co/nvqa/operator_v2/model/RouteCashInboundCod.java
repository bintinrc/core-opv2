package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.util.TestConstants;
import java.text.DecimalFormat;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCashInboundCod extends DataEntity<RouteCashInboundCod> {

  private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("###,###.00");

  private Long routeId;
  private Double totalCollected;
  private String amountCollected;
  private String receiptNumber;

  public RouteCashInboundCod() {
  }

  public RouteCashInboundCod(Map<String, ?> data) {
    fromMap(data);
  }

  public Long getRouteId() {
    return routeId;
  }

  public void setRouteId(Long routeId) {
    this.routeId = routeId;
  }

  public void setRouteId(String routeId) {
    setRouteId(Long.valueOf(routeId));
  }

  public Double getTotalCollected() {
    return totalCollected;
  }

  public void setTotalCollected(Double totalCollected) {
    this.totalCollected = totalCollected;
  }

  public void setTotalCollected(String totalCollected) {
    setTotalCollected(Double.valueOf(totalCollected));
  }

  public String getAmountCollected() {
    return amountCollected;
  }

  public void setAmountCollected(String amountCollected) {
    this.amountCollected = amountCollected;
  }

  public void setAmountCollected(Double amountCollected) {
    String strAmountCollected = DECIMAL_FORMAT.format(amountCollected);

    switch (TestConstants.COUNTRY_CODE.toUpperCase()) {
      case "SG":
        strAmountCollected = "S$" + strAmountCollected;
        break;
      case "ID":
      case "MBS":
      case "FEF":
      case "MMPG":
      case "TKL":
      case "HBL":
      case "MNT":
      case "DEMO":
      case "MSI":
        strAmountCollected = "$" + strAmountCollected;
        break;
      default:
        strAmountCollected = "$" + strAmountCollected;
    }
    setAmountCollected(strAmountCollected);
  }

  public String getReceiptNumber() {
    return receiptNumber;
  }

  public void setReceiptNumber(String receiptNumber) {
    this.receiptNumber = receiptNumber;
  }
}
