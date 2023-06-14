package co.nvqa.operator_v2.model.shipper;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.DateUtil;
import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import co.nvqa.commons.util.NvTestRuntimeException;
import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
@Getter
@Setter
public class Pricing extends DataEntity<Pricing> implements ShipperSettings, Serializable {

  private Long id;

  @JsonAlias("pricing_script_id")
  private Long scriptId;

  private Long templateId;

  private String scriptName;

  @JsonAlias("salesperson_discount")
  private String discount;

  private String comments;

  @JsonAlias("global_id")
  private Long shipperId;

  @JsonAlias("shipper_id")
  private Long legacyShipperId;

  private Long shipperDiscountId;

  @JsonAlias("discount_type")
  private String type;

  @JsonAlias("effective_date")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "d/M/yyyy")
  private Date effectiveDate;

  private Date contractEndDate;

  private Date createdAt;

  private Date updatedAt;

  private Date deletedAt;

  @JsonAlias("cod_min_fee")
  private String codMin;

  @JsonAlias("cod_percentage")
  private String codPercentage;

  @JsonAlias("insurance_threshold")
  private String insThreshold;

  @JsonAlias("insurance_min_fee")
  private String insMin;

  @JsonAlias("insurance_percentage")
  private String insPercentage;

  @JsonAlias("rts_type")
  private String rtsChargeType;

  @JsonAlias("rts")
  private String rtsChargeValue;

  @JsonAlias("billing_weight_logic")
  private BillingWeightEnum billingWeight;

  public Pricing() {
  }

  public Pricing(Map<String, ?> data) {
    fromMap(data);
  }

  public void setShipperId(Long shipperId) {
    this.shipperId = shipperId;
  }

  public void setShipperId(String shipperId) {
    setShipperId(Long.parseLong(shipperId));
  }

  public void setShipperDiscountId(Long shipperDiscountId) {
    this.shipperDiscountId = shipperDiscountId;
  }

  public void setShipperDiscountId(String shipperDiscountId) {
    setShipperDiscountId(Long.parseLong(shipperDiscountId));
  }

  public void setEffectiveDate(Date effectiveDate) {
    this.effectiveDate = effectiveDate;
  }

  public void setEffectiveDate(String effectiveDate) {
    SimpleDateFormat YYYY_MM_DD = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat D_MM_YYYY = new SimpleDateFormat("d/MM/yyyy");

    try {
      String date_format_yyyy_MM_dd = DateUtil.getUTCDateTime(
          YYYY_MM_DD.format(D_MM_YYYY.parse(effectiveDate)).concat(" 00:00:00"));
      String date_format_d_MM_yyy = D_MM_YYYY.format(YYYY_MM_DD.parse(date_format_yyyy_MM_dd));
      setEffectiveDate(D_MM_YYYY.parse(date_format_d_MM_yyy));
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Parse error here :" + e.getMessage());
    }
  }

  public enum BillingWeightEnum {
    STANDARD("Standard"),
    GROSS_WEIGHT("Gross weight only"),
    SHIPPER_GROSS_WEIGHT("Shipper submitted gross weight only"),
    SHIPPER_DIM_WEIGHT("Greater of shipper submitted gross or volumetric weight"),
    LEGACY("Legacy"),
    EMPTY("Empty"),
    INVALID("Invalid Billing Weight Logic");

    private final String code;
    private static Map<String, BillingWeightEnum> map = new HashMap<>();

    static {
      for (BillingWeightEnum be : BillingWeightEnum.values()) {
        map.put(be.getCode(), be);
      }
    }

    BillingWeightEnum(String code) {
      this.code = code;
    }

    public String getCode() {
      return code;
    }

    public static BillingWeightEnum getBillingWeightEnum(String value) {
      if (!map.containsKey(value)) {
        throw new NvTestRuntimeException("Unsupported Billing Weight Logic value :" + value);
      }
      return map.get(value);
    }
  }


}