package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Rizaq Pratama
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
public class SmsCampaignCsv extends DataEntity<SmsCampaignCsv> {

  private String tracking_id;
  private String name;
  private String email;
  private String job;

  public SmsCampaignCsv() {
  }

  public SmsCampaignCsv(Map<String, ?> data) {
    fromMap(data);
  }

  public SmsCampaignCsv(String tracking_id, String name, String email, String job) {
    this.tracking_id = tracking_id;
    this.name = name;
    this.email = email;
    this.job = job;
  }

  public String getTracking_id() {
    return tracking_id;
  }

  public void setTracking_id(String tracking_id) {
    this.tracking_id = tracking_id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getJob() {
    return job;
  }

  public void setJob(String job) {
    this.job = job;
  }
}
