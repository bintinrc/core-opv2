package co.nvqa.operator_v2.model;

/**
 * @author Daniel Joi Partogi Hutapea
 */

import lombok.Setter;
import lombok.Getter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RunCheckParams {

  private String orderFields;
  private String deliveryType;
  private String orderType;
  private String serviceLevel;
  private String serviceType;
  private String timeslotType;
  private String isRts;
  private String size;
  private Double weight;
  private Double insuredValue;
  private Double codValue;
  private String fromZone;
  private String toZone;
  private String fromL1;
  private String fromL2;
  private String fromL3;
  private String toL1;
  private String toL2;
  private String toL3;
}
