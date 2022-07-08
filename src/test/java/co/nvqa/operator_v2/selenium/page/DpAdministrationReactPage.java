package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import co.nvqa.operator_v2.selenium.elements.Button;
import org.openqa.selenium.support.FindBy;

/**
 * @author Diaz Ilyasa
 */
public class DpAdministrationReactPage extends SimpleReactPage<DpAdministrationReactPage> {

  @FindBy(xpath = "//button[@data-testid='button_download_csv']")
  public Button buttonDownloadCsv;

  @FindBy(xpath = "//button[@data-testid='button_add_partner']")
  public Button buttonAddPartner;

  @FindBy(xpath = "//button[@type='button'][@role='switch']")
  public Button buttonSendNotifications;

  @FindBy(xpath = "//button[@data-testId='button_submit_partner']")
  public Button buttonSubmitPartner;

  @FindBy(xpath = "//button[@data-testId='button_edit_partner']")
  public Button buttonEditPartner;

  @FindBy(xpath = "//button[@data-testId='button_submit_dp_changes']")
  public Button buttonSubmitPartnerChanges;

  @FindBy(xpath = "//button[@data-testId='button_view_dps']")
  public Button buttonViewDps;

  @FindBy(xpath = "//button[@data-testId='button_add_dp']")
  public Button buttonAddDp;

  @FindBy(xpath = "//button[@data-testId='button_dp_user']")
  public Button buttonDpUser;

  @FindBy(xpath = "//button[@data-testId='button_add_user']")
  public Button buttonAddUser;

  @FindBy(xpath = "//input[@data-testId='field_partner_id']")
  public TextBox filterPartnerId;

  @FindBy(xpath = "//input[@data-testId='field_partner_name']")
  public TextBox filterPartnerName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_partner_name']")
  public TextBox formPartnerName;

  @FindBy(xpath = "//input[@data-testId='field_poc_name']")
  public TextBox filterPocName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_poc_name']")
  public TextBox formPocName;

  @FindBy(xpath = "//input[@data-testId='field_poc_no']")
  public TextBox filterPocNo;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_poc_tel']")
  public TextBox formPocNo;

  @FindBy(xpath = "//input[@data-testId='field_poc_email']")
  public TextBox filterPocEmail;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_poc_email']")
  public TextBox formPocEmail;

  @FindBy(xpath = "//input[@data-testId='field_restrictions']")
  public TextBox filterRestrictions;

  @FindBy(xpath = "//input[@data-testId='field_dp_id']")
  public TextBox filterDpId;

  @FindBy(xpath = "//input[@data-testId='field_dp_name']")
  public TextBox filterDpName;

  @FindBy(xpath = "//input[@data-testId='field_dp_shortname']")
  public TextBox filterDpShortName;

  @FindBy(xpath = "//input[@data-testId='field_dp_hub']")
  public TextBox filterDpHub;

  @FindBy(xpath = "//input[@data-testId='field_dp_address']")
  public TextBox filterDpAddress;

  @FindBy(xpath = "//input[@data-testId='field_dp_direction']")
  public TextBox filterDpDirection;

  @FindBy(xpath = "//input[@data-testId='field_dp_activity']")
  public TextBox filterDpActivity;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_restrictions']")
  public TextBox formRestrictions;

  @FindBy(xpath = "//div[@data-testid='label_partner_id']/span")
  public PageElement labelPartnerId;

  @FindBy(xpath = "//div[@data-testid='label_partner_name']/span")
  public PageElement labelPartnerName;

  @FindBy(xpath = "//div[@data-testid='label_poc_name']/span")
  public PageElement labelPocName;

  @FindBy(xpath = "//div[@data-testid='label_poc_no']/span")
  public PageElement labelPocNo;

  @FindBy(xpath = "//div[@data-testid='label_poc_email']/span")
  public PageElement labelPocEmail;

  @FindBy(xpath = "//div[@data-testid='label_restrictions']/span")
  public PageElement labelRestrictions;

  @FindBy(xpath = "//div[@data-headerkey='id']/div/div[1]/*[name()='svg']")
  public PageElement sortPartnerId;

  @FindBy(xpath = "//div[@data-headerkey='name']/div/div[1]/*[name()='svg']")
  public PageElement sortPartnerName;

  @FindBy(xpath = "//div[@data-headerkey='poc_name']/div/div[1]/*[name()='svg']")
  public PageElement sortPocName;

  @FindBy(xpath = "//div[@data-headerkey='poc_tel']/div/div[1]/*[name()='svg']")
  public PageElement sortPocNo;

  @FindBy(xpath = "//div[@data-headerkey='poc_email']/div/div[1]/*[name()='svg']")
  public PageElement sortPocEmail;

  @FindBy(xpath = "//div[@data-headerkey='restrictions']/div/div[1]/*[name()='svg']")
  public PageElement sortRestrictions;

  @FindBy(xpath = "//h2[@data-testid='label_page_details']")
  public PageElement dpAdminHeader;

  @FindBy(xpath = "//h2[@data-testid='label_distribution_points']")
  public PageElement distributionPointHeader;

  @FindBy(xpath = "//div[contains(@class,'nv-input-field-error')]/div[3]")
  public PageElement errorMsg;

  public static final String ERROR_MSG_NOT_PHONE_NUM = "That doesn't look like a phone number.";
  public static final String ERROR_MSG_NOT_EMAIL_FORMAT = "That doesn't look like an email.";

  public ImmutableMap<String, TextBox> textBoxDpPartnerElement = ImmutableMap.<String, TextBox>builder()
      .put("id", filterPartnerId)
      .put("name", filterPartnerName)
      .put("pocName", filterPocName)
      .put("pocTel", filterPocNo)
      .put("pocEmail", filterPocEmail)
      .put("restrictions", filterRestrictions)
      .build();

  public ImmutableMap<String, TextBox> textBoxDpElement = ImmutableMap.<String, TextBox>builder()
      .put("id", filterDpId)
      .put("name", filterDpName)
      .put("shortName", filterDpShortName)
      .put("hub", filterDpHub)
      .put("address", filterDpAddress)
      .put("direction", filterDpDirection)
      .put("activity", filterDpActivity)
      .build();


  public DpAdministrationReactPage(WebDriver webDriver) {
    super(webDriver);
  }

  public DpPartner convertPartnerToDpPartner(Partner partner) {
    DpPartner dpPartner = new DpPartner();
    dpPartner.setId(partner.getId());
    dpPartner.setDpmsPartnerId(partner.getDpmsPartnerId());
    dpPartner.setName(partner.getName());
    dpPartner.setPocName(partner.getPocName());
    dpPartner.setPocEmail(partner.getPocEmail());
    dpPartner.setPocTel(partner.getPocTel());
    dpPartner.setRestrictions(partner.getRestrictions());
    return dpPartner;
  }

  public void sortFilter(String field) {
    ImmutableMap<String, PageElement> sortElement = ImmutableMap.<String, PageElement>builder()
        .put("id", sortPartnerId)
        .put("name", sortPartnerName)
        .put("pocName", sortPocName)
        .put("pocTel", sortPocNo)
        .put("pocEmail", sortPocEmail)
        .put("restrictions", sortRestrictions)
        .build();

    sortElement.get(field).click();
  }

  public void fillFilterDpPartner(String field, String value) {
    textBoxDpPartnerElement.get(field).setValue(value);
  }

  public void waitUntilFilterAppear(String field) {
    textBoxDpPartnerElement.get(field).waitUntilVisible();
  }

  public void clearFilter(String field) {
    textBoxDpPartnerElement.get(field).forceClear();
  }

  public void errorCheck(Partner dpPartner) {

    if (dpPartner.getName().contains("NAME")) {
      formPartnerName.forceClear();
      formPartnerName.setValue(dpPartner.getName());
      formPartnerName.forceClear();
    } else if (dpPartner.getName().contains("POCNME")) {
      formPocName.forceClear();
      formPocName.setValue(dpPartner.getPocName());
      formPocName.forceClear();
    } else if (dpPartner.getName().contains("POCNUM")) {
      if (dpPartner.getPocTel().equals("VALID")) {
        formPocNo.forceClear();
        formPocNo.setValue(RandomStringUtils.random(10, true, false));
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC NO with wrong format (Not Number) : %s",
                ERROR_MSG_NOT_PHONE_NUM))
            .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
        formPocNo.forceClear();

        formPocNo.setValue(RandomStringUtils.random(10, false, true));
        formPocNo.forceClear();
      }
    } else if (dpPartner.getName().contains("POCMAIL")) {
      formPocEmail.forceClear();
      formPocEmail.setValue(RandomStringUtils.random(10, true, false));
      Assertions.assertThat(errorMsg.getText())
          .as(f("Error Message Exist after fill Form POC Email with wrong format (Letters): %s",
              ERROR_MSG_NOT_EMAIL_FORMAT))
          .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
      formPocEmail.forceClear();

      formPocEmail.setValue(RandomStringUtils.random(10, false, true));
      Assertions.assertThat(errorMsg.getText())
          .as(f("Error Message Exist after fill Form POC Email with wrong format (Number): %s",
              ERROR_MSG_NOT_EMAIL_FORMAT))
          .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);

    } else if (dpPartner.getName().contains("RESTRICTION")) {
      formRestrictions.forceClear();
      formRestrictions.setValue(dpPartner.getRestrictions());
      formRestrictions.forceClear();
    }

  }


  public void checkErrorMsg(String errMessage) {
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message: %s", errMessage))
        .isEqualTo(errMessage);
  }

  public void readEntity(DpPartner dpPartner) {
    Assertions.assertThat(Long.toString(dpPartner.getId()))
        .as(f("Partner ID Is %s", dpPartner.getId())).isEqualTo(labelPartnerId.getText());
    Assertions.assertThat(dpPartner.getName()).as(f("Partner Name Is %s", dpPartner.getName()))
        .isEqualTo(labelPartnerName.getText());
    Assertions.assertThat(dpPartner.getPocName()).as(f("POC Name Is %s", dpPartner.getPocName()))
        .isEqualTo(labelPocName.getText());
    Assertions.assertThat(dpPartner.getPocTel()).as(f("POC No Is %s", dpPartner.getPocTel()))
        .isEqualTo(labelPocNo.getText());
    Assertions.assertThat(dpPartner.getPocEmail()).as(f("POC Email Is %s", dpPartner.getPocEmail()))
        .isEqualTo(labelPocEmail.getText());
    Assertions.assertThat(dpPartner.getRestrictions())
        .as(f("Restrictions Is %s", dpPartner.getRestrictions()))
        .isEqualTo(labelRestrictions.getText());
  }

  public void checkingIdAndDpmsId(Partner partner) {
    Assertions.assertThat(partner.getId()).as("DP ID and DPMS ID is Same")
        .isEqualTo(partner.getDpmsPartnerId());
  }

  public String getDpPartnerElementByMap(String map, DpPartner dpPartner) {
    ImmutableMap<String, String> partnerElement = ImmutableMap.<String, String>builder()
        .put("id", Long.toString(dpPartner.getId()))
        .put("name", dpPartner.getName())
        .put("pocName", dpPartner.getPocName())
        .put("pocTel", dpPartner.getPocTel())
        .put("pocEmail", dpPartner.getPocEmail())
        .put("restrictions", dpPartner.getRestrictions())
        .build();

    return partnerElement.get(map);
  }

  public String getDpElementByMap(String map, DpDetailsResponse dp) {
    ImmutableMap<String, String> dpElement = ImmutableMap.<String, String>builder()
        .put("id", Long.toString(dp.getId()))
        .put("name", dp.getName())
        .put("shortName", dp.getShortName())
        .put("hub", Long.toString(dp.getHubId()))
        .put("address", dp.getAddress1())
        .put("direction", dp.getDirections())
        .put("activity", dp.getIsActive() ? "Active" : "Inactive")
        .build();

    return dpElement.get(map);
  }

}
