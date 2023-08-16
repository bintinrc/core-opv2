package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RecoveryTicket extends DataEntity<RecoveryTicket> {

  private String trackingId;
  private String entrySource;
  private String investigatingDepartment;
  private String investigatingHub;
  private String ticketType;
  private String ticketSubType;
  private String parcelLocation;
  private String liability;
  private String damageDescription;
  private String orderOutcomeDamaged;
  private String orderOutcomeMissing;
  private String ticketNotes;
  private String custZendeskId;
  private String shipperZendeskId;
  private String parcelDescription;
  private String ticketStatus;
  private String orderOutcome;
  private String assignTo;
  private String enterNewInstruction;
  private String ticketComments;
  private String exceptionReason;
  private String orderOutcomeInaccurateAddress;
  private String orderOutcomeDuplicateParcel;
  private String issueDescription;
  private String rtsReason;
  private String breachReason;
  private String breachLeg;

  public RecoveryTicket() {
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getEntrySource() {
    return entrySource;
  }

  public void setEntrySource(String entrySource) {
    this.entrySource = entrySource;
  }

  public String getInvestigatingDepartment() {
    return investigatingDepartment;
  }

  public void setInvestigatingDepartment(String investigatingDepartment) {
    this.investigatingDepartment = investigatingDepartment;
  }

  public String getInvestigatingHub() {
    return investigatingHub;
  }

  public void setInvestigatingHub(String investigatingHub) {
    this.investigatingHub = investigatingHub;
  }

  public String getTicketType() {
    return ticketType;
  }

  public void setTicketType(String ticketType) {
    this.ticketType = ticketType;
  }

  public String getTicketSubType() {
    return ticketSubType;
  }

  public void setTicketSubType(String ticketSubType) {
    this.ticketSubType = ticketSubType;
  }

  public String getParcelLocation() {
    return parcelLocation;
  }


  public void setParcelLocation(String parcelLocation) {
    this.parcelLocation = parcelLocation;
  }

  public String getLiability() {
    return liability;
  }

  public void setLiability(String liability) {
    this.liability = liability;
  }

  public String getDamageDescription() {
    return damageDescription;
  }

  public void setDamageDescription(String damageDescription) {
    this.damageDescription = damageDescription;
  }

  public void setExceptionReason(String exceptionReason) {
    this.exceptionReason = exceptionReason;
  }

  public String getExceptionReason() {
    return exceptionReason;
  }

  public void setOrderOutcomeInaccurateAddress(String orderOutcomeInaccurateAddress) {
    this.orderOutcomeInaccurateAddress = orderOutcomeInaccurateAddress;
  }

  public String getOrderOutcomeInaccurateAddress() {
    return orderOutcomeInaccurateAddress;
  }

  public void setOrderOutcomeDuplicateParcel(String orderOutcomeDuplicateParcel) {
    this.orderOutcomeDuplicateParcel = orderOutcomeDuplicateParcel;
  }

  public String getOrderOutcomeDuplicateParcel() {
    return orderOutcomeDuplicateParcel;
  }

  public void setIssueDescription(String issueDescription) {
    this.issueDescription = issueDescription;
  }

  public String getIssueDescription() {
    return issueDescription;
  }

  public String getOrderOutcomeDamaged() {
    return orderOutcomeDamaged;
  }

  public void setOrderOutcomeDamaged(String orderOutcomeDamaged) {
    this.orderOutcomeDamaged = orderOutcomeDamaged;
  }

  public String getOrderOutcomeMissing() {
    return orderOutcomeMissing;
  }

  public void setOrderOutcomeMissing(String orderOutcomeMissing) {
    this.orderOutcomeMissing = orderOutcomeMissing;
  }

  public String getTicketNotes() {
    return ticketNotes;
  }

  public void setTicketNotes(String ticketNotes) {
    this.ticketNotes = ticketNotes;
  }

  public String getCustZendeskId() {
    return custZendeskId;
  }

  public void setCustZendeskId(String custZendeskId) {
    this.custZendeskId = custZendeskId;
  }

  public String getShipperZendeskId() {
    return shipperZendeskId;
  }

  public void setShipperZendeskId(String shipperZendeskId) {
    this.shipperZendeskId = shipperZendeskId;
  }

  public String getParcelDescription() {
    return parcelDescription;
  }

  public void setParcelDescription(String parcelDescription) {
    this.parcelDescription = parcelDescription;
  }

  public void setTicketStatus(String ticketStatus) {
    this.ticketStatus = ticketStatus;
  }

  public String getTicketStatus() {
    return ticketStatus;
  }

  public void setOrderOutcome(String orderOutcome) {
    this.orderOutcome = orderOutcome;
  }

  public String getOrderOutcome() {
    return orderOutcome;
  }

  public void setAssignTo(String assignTo) {
    this.assignTo = assignTo;
  }

  public String getAssignTo() {
    return assignTo;
  }

  public void setEnterNewInstruction(String enterNewInstruction) {
    this.enterNewInstruction = enterNewInstruction;
  }

  public String getEnterNewInstruction() {
    return enterNewInstruction;
  }

  public void setTicketComments(String ticketComments) {
    this.ticketComments = ticketComments;
  }

  public String getTicketComments() {
    return ticketComments;
  }

  public String getRtsReason() {
    return rtsReason;
  }

  public void setRtsReason(String rtsReason) {
    this.rtsReason = rtsReason;
  }

  public String getBreachReason() {
    return breachReason;
  }

  public void setBreachReason(String breachReason) {
    this.breachReason = breachReason;
  }

  public String getBreachLeg() {
    return breachLeg;
  }

  public void setBreachLeg(String breachLeg) {
    this.breachLeg = breachLeg;
  }
}
