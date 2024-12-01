package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
public class RouteGroupInfo extends DataEntity<RouteGroupInfo> {

  private Long id;
  private String name;
  private String description;
  private String createDateTime;
  private Integer noTransactions;
  private Integer noRoutedTransactions;
  private String noReservations;
  private String noRoutedReservations;

  private String noPaJobs;
  private String noRoutedPaJobs;
  private String hubName;

  public RouteGroupInfo() {
  }

  public RouteGroupInfo(Map<String, ?> data) {
    super(data);
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public void setId(String id) {
    setId(Long.valueOf(id));
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getCreateDateTime() {
    return createDateTime;
  }

  public void setCreateDateTime(String createDateTime) {
    this.createDateTime = createDateTime;
  }

  public Integer getNoTransactions() {
    return noTransactions;
  }

  public void setNoTransactions(Integer noTransactions) {
    this.noTransactions = noTransactions;
  }

  public void setNoTransactions(String noTransactions) {
    setNoTransactions(Integer.valueOf(noTransactions));
  }

  public Integer getNoRoutedTransactions() {
    return noRoutedTransactions;
  }

  public void setNoRoutedTransactions(Integer noRoutedTransactions) {
    this.noRoutedTransactions = noRoutedTransactions;
  }

  public void setNoRoutedTransactions(String noRoutedTransactions) {
    setNoRoutedTransactions(Integer.valueOf(noRoutedTransactions));
  }

  public String getNoReservations() {
    return noReservations;
  }

  public void setNoReservations(String noReservations) {
    this.noReservations = noReservations;
  }

  public String getNoRoutedReservations() {
    return noRoutedReservations;
  }

  public void setNoRoutedReservations(String noRoutedReservations) {
    this.noRoutedReservations = noRoutedReservations;
  }

  public String getHubName() {
    return hubName;
  }

  public void setHubName(String hubName) {
    this.hubName = hubName;
  }

  public String getNoPaJobs() {
    return noPaJobs;
  }

  public void setNoPaJobs(String noPaJobs) {
    this.noPaJobs = noPaJobs;
  }

  public String getNoRoutedPaJobs() {
    return noRoutedPaJobs;
  }

  public void setNoRoutedPaJobs(String noRoutedPaJobs) {
    this.noRoutedPaJobs = noRoutedPaJobs;
  }
}
