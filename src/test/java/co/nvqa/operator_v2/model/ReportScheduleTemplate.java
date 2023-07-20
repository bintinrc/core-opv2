package co.nvqa.operator_v2.model;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReportScheduleTemplate {

  private String name;
  private String description;
  private String frequency;
  private String day;
  private String reportFor;
  private String shipper;
  private String parentShipper;
  private List<String> scriptIds;
  private Boolean isOrderAggregation;
  private String fileGrouping;
  private String reportTemplate;
  private List<String> emails;

}