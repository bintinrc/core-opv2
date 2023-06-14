package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class LabelPrinter implements ShipperSettings, Serializable {

  private Boolean showShipperDetails;
  private Boolean showCod;
  private Boolean showParcelDescription;
  private String printerIp;

  public LabelPrinter() {
  }

  public Boolean getShowShipperDetails() {
    return showShipperDetails;
  }

  public void setShowShipperDetails(Boolean showShipperDetails) {
    this.showShipperDetails = showShipperDetails;
  }

  public String getPrinterIp() {
    return printerIp;
  }

  public void setPrinterIp(String printerIp) {
    this.printerIp = printerIp;
  }

  public Boolean getShowCod() {
    return showCod;
  }

  public void setShowCod(Boolean showCod) {
    this.showCod = showCod;
  }

  public Boolean getShowParcelDescription() {
    return showParcelDescription;
  }

  public void setShowParcelDescription(Boolean showParcelDescription) {
    this.showParcelDescription = showParcelDescription;
  }
}
