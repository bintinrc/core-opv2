package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Sergey Mishanin
 */
public class SmsHistoryEntry extends DataEntity<SmsHistoryEntry> {

  private String channel;
  private String sentDateTime;
  private String contact;
  private String content;

  public SmsHistoryEntry() {
  }

  public String getChannel() {
    return channel;
  }

  public void setChannel(String channel) {
    this.channel = channel;
  }

  public String getSentDateTime() {
    return sentDateTime;
  }

  public void setSentDateTime(String sentDateTime) {
    this.sentDateTime = sentDateTime;
  }

  public String getContact() {
    return contact;
  }

  public void setContact(String contact) {
    this.contact = contact;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }
}
