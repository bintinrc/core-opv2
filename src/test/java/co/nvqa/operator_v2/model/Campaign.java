package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.io.Serializable;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Campaign extends DataEntity<Campaign> implements Serializable {


  private String campaignName;
  private String campaignDescription;
  private String startDate;
  private String endDate;
  private String discountOperator;
  private List<String> serviceType;
  private List<String> serviceLevel;
  private List<String> discountValue;
  private String discountUsageQuantityPerShipper;
  private String discountUsagePeriod;
}
