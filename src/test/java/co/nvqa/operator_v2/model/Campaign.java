package co.nvqa.operator_v2.model;
import co.nvqa.common.model.DataEntity;
import java.io.Serializable;
import java.util.List;


public class Campaign extends DataEntity<Campaign> implements Serializable {


  private String campaignName;
  private String campaignDescription;
  private String startDate;
  private String endDate;
  private List<String> serviceType;
  private List<String> serviceLevel;
  private List<String> discountValue;

  public String getCampaignName() {
    return campaignName;
  }

  public void setCampaignName(String campaignName) {
    this.campaignName = campaignName;
  }

  public String getCampaignDescription() {
    return campaignDescription;
  }

  public void setCampaignDescription(String campaignDescription) {
    this.campaignDescription = campaignDescription;
  }

  public String getStartDate() {
    return startDate;
  }

  public void setStartDate(String startDate) {
    this.startDate = startDate;
  }

  public String getEndDate() {
    return endDate;
  }

  public void setEndDate(String endDate) {
    this.endDate = endDate;
  }

  public List<String> getServiceType() {
    return serviceType;
  }

  public void setServiceType(List<String> serviceType) {
    this.serviceType = serviceType;
  }

  public List<String> getServiceLevel() {
    return serviceLevel;
  }

  public void setServiceLevel(List<String> serviceLevel) {
    this.serviceLevel = serviceLevel;
  }

  public List<String> getDiscountValue() {
    return discountValue;
  }

  public void setDiscountValue(List<String> discountValue) {
    this.discountValue = discountValue;
  }

}
