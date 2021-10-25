package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
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
  private Integer noReservations;
  private Integer noRoutedReservations;
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

  public Integer getNoReservations() {
    return noReservations;
  }

  public void setNoReservations(Integer noReservations) {
    this.noReservations = noReservations;
  }

  public void setNoReservations(String noReservations) {
    setNoReservations(Integer.valueOf(noReservations));
  }

  public Integer getNoRoutedReservations() {
    return noRoutedReservations;
  }

  public void setNoRoutedReservations(Integer noRoutedReservations) {
    this.noRoutedReservations = noRoutedReservations;
  }

  public void setNoRoutedReservations(String noRoutedReservations) {
    setNoRoutedReservations(Integer.valueOf(noRoutedReservations));
  }

  public String getHubName() {
    return hubName;
  }

  public void setHubName(String hubName) {
    this.hubName = hubName;
  }
}
