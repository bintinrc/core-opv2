package co.nvqa.operator_v2.model;

/**
 * @author Tristania Siagian
 */
public class RecoveryTicketsScanning {

  private String ticketType;
  private String ticketSubtype;
  private String investigatingGroup;
  private String investigatingHub;
  private String entrySource;
  private String comment;
  private String trackingId;

  public RecoveryTicketsScanning() {
  }

  public String getTicketType() {
    return ticketType;
  }

  public void setTicketType(String ticketType) {
    this.ticketType = ticketType;
  }

  public String getTicketSubtype() {
    return ticketSubtype;
  }

  public void setTicketSubtype(String ticketSubtype) {
    this.ticketSubtype = ticketSubtype;
  }

  public String getInvestigatingGroup() {
    return investigatingGroup;
  }

  public void setInvestigatingGroup(String investigatingGroup) {
    this.investigatingGroup = investigatingGroup;
  }

  public String getEntrySource() {
    return entrySource;
  }

  public void setEntrySource(String entrySource) {
    this.entrySource = entrySource;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getInvestigatingHub() {
    return investigatingHub;
  }

  public void setInvestigatingHub(String investigatingHub) {
    this.investigatingHub = investigatingHub;
  }
}
