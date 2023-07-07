package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Hours;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.model.dp.dp_user.User;
import co.nvqa.commons.model.dp.persisted_classes.AuditMetadata;
import co.nvqa.commons.model.dp.persisted_classes.Dp;
import co.nvqa.commons.model.dp.persisted_classes.DpOpeningHour;
import co.nvqa.commons.model.dp.persisted_classes.DpOperatingHour;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import com.google.common.collect.ImmutableMap;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Diaz Ilyasa
 */
public class DpAdministrationReactPage extends SimpleReactPage<DpAdministrationReactPage> {

  @FindBy(xpath = "//button[@data-testid='button_download_csv']")
  public Button buttonDownloadCsv;

  @FindBy(xpath = "//button[@data-testid='button_download_csv']")
  public Button DpButtonDownloadCsv;

  @FindBy(xpath = "//button[@data-testid='button_add_partner']")
  public Button buttonAddPartner;

  @FindBy(xpath = "//button[@type='button'][@role='switch']")
  public Button buttonSendNotifications;

  @FindBy(xpath = "//button[@data-testId='button_submit_partner']")
  public Button buttonSubmitPartner;

  @FindBy(xpath = "//button[@data-testId='button_edit_partner']")
  public Button buttonEditPartner;

  @FindBy(xpath = "//button[@data-testId='button_edit_user']")
  public Button buttonEditUser;

  @FindBy(xpath = "//button[@data-testId='button_submit_dp_changes']")
  public Button buttonSubmitPartnerChanges;

  @FindBy(xpath = "//button[@data-testId='button_view_dps']")
  public Button buttonViewDps;

  @FindBy(xpath = "//button[@data-testId='button_dp_edit']")
  public Button buttonDpEdit;

  @FindBy(xpath = "//button[@data-testId='button_add_dp']")
  public Button buttonAddDp;

  @FindBy(xpath = "//button[@data-testId='button_dp_user']")
  public Button buttonDpUser;

  @FindBy(xpath = "//button[@data-testId='button_add_user']")
  public Button buttonAddUser;

  @FindBy(xpath = "//button[@data-testId='button_return_to_list']")
  public Button buttonReturnToList;

  @FindBy(xpath = "//button[@data-testId='button_leave_the_page']")
  public Button buttonLeaveThePage;

  @FindBy(xpath = "//button[@data-testId='button_save_settings']")
  public Button buttonSaveSettings;

  @FindBy(xpath = "//button[@data-testid='button_reset_password']")
  public Button buttonResetPassword;

  @FindBy(xpath = "//button[@data-testid='button_back_to_user_edit']")
  public Button buttonBackToUserEdit;

  @FindBy(xpath = "//button[@data-testid='button_save_password']")
  public Button buttonSaveResetPassword;

  @FindBy(xpath = "//button[@data-testId='button_submit']")
  public TextBox buttonSubmitDpUser;

  @FindBy(xpath = "//button[@data-testId='button_submit_edit_user']")
  public TextBox buttonSubmitEditDpUser;

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

  @FindBy(xpath = "//input[@data-testId='field_username']")
  public TextBox filterDpUserUsername;

  @FindBy(xpath = "//input[@data-testId='field_first_name']")
  public TextBox filterDpUserFirstName;

  @FindBy(xpath = "//input[@data-testId='field_last_name']")
  public TextBox filterDpUserLastName;

  @FindBy(xpath = "//input[@data-testId='field_email']")
  public TextBox filterDpUserEmail;

  @FindBy(xpath = "//input[@data-testId='field_contact']")
  public TextBox filterDpUserContact;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_restrictions']")
  public TextBox formRestrictions;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_first_name']")
  public TextBox formDpUserFirstName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_last_name']")
  public TextBox formDpUserLastName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_contact_no']")
  public TextBox formDpUserContact;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_email']")
  public TextBox formDpUserEmail;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_username']")
  public TextBox formDpUserUsername;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_password']")
  public TextBox formDpUserPassword;

  @FindBy(xpath = "//input[@data-testid='field_point_name']")
  public TextBox fieldPointName;

  @FindBy(xpath = "//input[@id='reservationSlots.monday[0].startTime']")
  public TextBox fieldOpeningStartHourMonday;
  @FindBy(xpath = "//input[@id='reservationSlots.tuesday[0].startTime']")
  public TextBox fieldOpeningStartHourTuesday;
  @FindBy(xpath = "//input[@id='reservationSlots.wednesday[0].startTime']")
  public TextBox fieldOpeningStartHourWednesday;
  @FindBy(xpath = "//input[@id='reservationSlots.thursday[0].startTime']")
  public TextBox fieldOpeningStartHourThursday;
  @FindBy(xpath = "//input[@id='reservationSlots.friday[0].startTime']")
  public TextBox fieldOpeningStartHourFriday;
  @FindBy(xpath = "//input[@id='reservationSlots.saturday[0].startTime']")
  public TextBox fieldOpeningStartHourSaturday;
  @FindBy(xpath = "//input[@id='reservationSlots.sunday[0].startTime']")
  public TextBox fieldOpeningStartHourSunday;

  @FindBy(xpath = "//input[@id='reservationSlots.monday[1].startTime']")
  public TextBox fieldOpeningStartHourMondayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.tuesday[1].startTime']")
  public TextBox fieldOpeningStartHourTuesdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.wednesday[1].startTime']")
  public TextBox fieldOpeningStartHourWednesdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.thursday[1].startTime']")
  public TextBox fieldOpeningStartHourThursdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.friday[1].startTime']")
  public TextBox fieldOpeningStartHourFridayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.saturday[1].startTime']")
  public TextBox fieldOpeningStartHourSaturdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.sunday[1].startTime']")
  public TextBox fieldOpeningStartHourSundayNext;

  @FindBy(xpath = "//input[@id='reservationSlots.monday[0].endTime']")
  public TextBox fieldOpeningEndHourMonday;
  @FindBy(xpath = "//input[@id='reservationSlots.tuesday[0].endTime']")
  public TextBox fieldOpeningEndHourTuesday;
  @FindBy(xpath = "//input[@id='reservationSlots.wednesday[0].endTime']")
  public TextBox fieldOpeningEndHourWednesday;
  @FindBy(xpath = "//input[@id='reservationSlots.thursday[0].endTime']")
  public TextBox fieldOpeningEndHourThursday;
  @FindBy(xpath = "//input[@id='reservationSlots.friday[0].endTime']")
  public TextBox fieldOpeningEndHourFriday;
  @FindBy(xpath = "//input[@id='reservationSlots.saturday[0].endTime']")
  public TextBox fieldOpeningEndHourSaturday;
  @FindBy(xpath = "//input[@id='reservationSlots.sunday[0].endTime']")
  public TextBox fieldOpeningEndHourSunday;
  @FindBy(xpath = "//input[@id='reservationSlots.monday[1].endTime']")
  public TextBox fieldOpeningEndHourMondayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.tuesday[1].endTime']")
  public TextBox fieldOpeningEndHourTuesdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.wednesday[1].endTime']")
  public TextBox fieldOpeningEndHourWednesdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.thursday[1].endTime']")
  public TextBox fieldOpeningEndHourThursdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.friday[1].endTime']")
  public TextBox fieldOpeningEndHourFridayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.saturday[1].endTime']")
  public TextBox fieldOpeningEndHourSaturdayNext;
  @FindBy(xpath = "//input[@id='reservationSlots.sunday[1].endTime']")
  public TextBox fieldOpeningEndHourSundayNext;

  @FindBy(xpath = "//input[@id='operatingHours.monday[0].startTime']")
  public TextBox fieldOperatingStartHourMonday;
  @FindBy(xpath = "//input[@id='operatingHours.tuesday[0].startTime']")
  public TextBox fieldOperatingStartHourTuesday;
  @FindBy(xpath = "//input[@id='operatingHours.wednesday[0].startTime']")
  public TextBox fieldOperatingStartHourWednesday;
  @FindBy(xpath = "//input[@id='operatingHours.thursday[0].startTime']")
  public TextBox fieldOperatingStartHourThursday;
  @FindBy(xpath = "//input[@id='operatingHours.friday[0].startTime']")
  public TextBox fieldOperatingStartHourFriday;
  @FindBy(xpath = "//input[@id='operatingHours.saturday[0].startTime']")
  public TextBox fieldOperatingStartHourSaturday;
  @FindBy(xpath = "//input[@id='operatingHours.sunday[0].startTime']")
  public TextBox fieldOperatingStartHourSunday;

  @FindBy(xpath = "//input[@id='operatingHours.monday[1].startTime']")
  public TextBox fieldOperatingStartHourMondayNext;
  @FindBy(xpath = "//input[@id='operatingHours.tuesday[1].startTime']")
  public TextBox fieldOperatingStartHourTuesdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.wednesday[1].startTime']")
  public TextBox fieldOperatingStartHourWednesdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.thursday[1].startTime']")
  public TextBox fieldOperatingStartHourThursdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.friday[1].startTime']")
  public TextBox fieldOperatingStartHourFridayNext;
  @FindBy(xpath = "//input[@id='operatingHours.saturday[1].startTime']")
  public TextBox fieldOperatingStartHourSaturdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.sunday[1].startTime']")
  public TextBox fieldOperatingStartHourSundayNext;

  @FindBy(xpath = "//input[@id='operatingHours.monday[0].endTime']")
  public TextBox fieldOperatingEndHourMonday;
  @FindBy(xpath = "//input[@id='operatingHours.tuesday[0].endTime']")
  public TextBox fieldOperatingEndHourTuesday;
  @FindBy(xpath = "//input[@id='operatingHours.wednesday[0].endTime']")
  public TextBox fieldOperatingEndHourWednesday;
  @FindBy(xpath = "//input[@id='operatingHours.thursday[0].endTime']")
  public TextBox fieldOperatingEndHourThursday;
  @FindBy(xpath = "//input[@id='operatingHours.friday[0].endTime']")
  public TextBox fieldOperatingEndHourFriday;
  @FindBy(xpath = "//input[@id='operatingHours.saturday[0].endTime']")
  public TextBox fieldOperatingEndHourSaturday;
  @FindBy(xpath = "//input[@id='operatingHours.sunday[0].endTime']")
  public TextBox fieldOperatingEndHourSunday;

  @FindBy(xpath = "//input[@id='operatingHours.monday[1].endTime']")
  public TextBox fieldOperatingEndHourMondayNext;
  @FindBy(xpath = "//input[@id='operatingHours.tuesday[1].endTime']")
  public TextBox fieldOperatingEndHourTuesdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.wednesday[1].endTime']")
  public TextBox fieldOperatingEndHourWednesdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.thursday[1].endTime']")
  public TextBox fieldOperatingEndHourThursdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.friday[1].endTime']")
  public TextBox fieldOperatingEndHourFridayNext;
  @FindBy(xpath = "//input[@id='operatingHours.saturday[1].endTime']")
  public TextBox fieldOperatingEndHourSaturdayNext;
  @FindBy(xpath = "//input[@id='operatingHours.sunday[1].endTime']")
  public TextBox fieldOperatingEndHourSundayNext;

  @FindBy(xpath = "//input[@data-testid='field_short_name']")
  public TextBox fieldShortName;

  @FindBy(xpath = "//input[@data-testid='field_contact_number']")
  public TextBox fieldContactNumber;

  @FindBy(xpath = "//input[@data-testid='field_external_store_id']")
  public TextBox fieldExternalStoreId;

  @FindBy(xpath = "//div[@data-testid='field_shipper_account_no']/div/span/input")
  public TextBox fieldShipperAccountNo;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_one']//input")
  public TextBox fieldAlternateDp1;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_one']//input[@disabled]")
  public TextBox fieldAlternateDp1Disabled;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_one']//span[@class='ant-select-clear']")
  public PageElement buttonClearAlternateDp1;

  @FindBy(xpath = "//div[@class='ant-modal-body']/div/div/div[1]")
  public PageElement elementRemoveMsg1;
  @FindBy(xpath = "//div[@class='ant-modal-body']/div/div/div[2]")
  public PageElement elementRemoveMsg2;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_two']//input")
  public TextBox fieldAlternateDp2;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_two']//input[@disabled]")
  public TextBox fieldAlternateDp2Disabled;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_two']//span[@class='ant-select-clear']")
  public PageElement buttonClearAlternateDp2;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_three']//input")
  public TextBox fieldAlternateDp3;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_three']//input[@disabled]")
  public TextBox fieldAlternateDp3Disabled;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_three']//span[@class='ant-select-clear']")
  public PageElement buttonClearAlternateDp3;

  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_one']//span[@class='ant-select-selection-item']")
  public PageElement elementAlternateDPId1;
  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_two']//span[@class='ant-select-selection-item']")
  public PageElement elementAlternateDPId2;
  @FindBy(xpath = "//div[@data-testid='field_alternative_dps_three']//span[@class='ant-select-selection-item']")
  public PageElement elementAlternateDPId3;

  @FindBy(xpath = "//div[@data-testid='field_search_via_lat_lang']//input")
  public TextBox fieldLatLongSearch;

  @FindBy(xpath = "//div[@data-testid='field_search_via_address_name']//input")
  public TextBox fieldAddressSearch;

  @FindBy(xpath = "//input[@data-testid='field_postcode']")
  public TextBox fieldPostcode;

  @FindBy(xpath = "//input[@data-testid='field_city']")
  public TextBox fieldCity;

  @FindBy(xpath = "//div[@data-testid='field_assigned_hub']/div/span/input")
  public TextBox fieldAssignedHub;

  @FindBy(xpath = "//input[@data-testid='field_point_address_1']")
  public TextBox fieldPointAddress1;

  @FindBy(xpath = "//input[@data-testid='field_point_address_2']")
  public TextBox fieldPointAddress2;

  @FindBy(xpath = "//input[@data-testid='field_floor_no']")
  public TextBox fieldFloorNo;

  @FindBy(xpath = "//input[@data-testid='field_unit_no']")
  public TextBox fieldUnitNo;

  @FindBy(xpath = "//input[@data-testid='field_latitude']")
  public TextBox fieldLatitude;

  @FindBy(xpath = "//input[@data-testid='field_longitude']")
  public TextBox fieldLongitude;

  @FindBy(xpath = "//input[@data-testid='field_maximum_parcel_capacity_for_collect']")
  public TextBox fieldMaximumParcelCapacityForCollect;

  @FindBy(xpath = "//input[@data-testid='field_buffer_capacity']")
  public TextBox fieldBufferCapacity;

  @FindBy(xpath = "//input[@data-testid='field_maximum_parcel_stay']")
  public TextBox fieldMaximumParcelStay;

  @FindBy(xpath = "//input[@data-testid='file_add_photo_of_pudo_point']")
  public FileInput fieldPhotoOfPudoPoint;


  @FindBy(xpath = "//span[@class='ant-upload-list-item-actions']/button")
  public Button buttonRemovePicture;

  @FindBy(xpath = "//button[@data-testid='file_delete_submit_pudo_point']")
  public Button buttonConfirmRemove;

  @FindBy(xpath = "//input[@data-testid='field_password']")
  public TextBox fieldPassword;

  @FindBy(xpath = "//input[@data-testid='field_confirm_password']")
  public TextBox fieldConfirmPassword;

  @FindBy(xpath = "//div[@class='ant-modal-confirm-content']/div/div")
  public PageElement elementErrorCreatingDP;

  @FindBy(xpath = "//div[@data-testid='field_pudo_point_type']")
  public PageElement fieldPudoPointType;

  @FindBy(xpath = "//div[@class='ant-modal-footer']//button/span[contains(text(),'Update')]")
  public PageElement elementUpdateDPAlternate;

  @FindBy(xpath = "//div[@class='ant-modal-footer']//button/span[contains(text(),'Select another')]")
  public PageElement elementSelectAnotherDPAlternate;

  @FindBy(xpath = "//div[@class='ant-modal-content']/button[@class='ant-modal-close']")
  public PageElement elementCancelDPAlternate;

  @FindBy(xpath = "//div[@data-testid='option_pudo_point_type']/div[text()='Ninja Box']")
  public PageElement ninjaBoxPudoPointType;

  @FindBy(xpath = "//div[@data-testid='option_pudo_point_type']/div[text()='Ninja Point']")
  public PageElement ninjaPointPudoPointType;

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

  @FindBy(xpath = "//div[@data-testid='label_dp_name']/span")
  public PageElement labelDpName;

  @FindBy(xpath = "//div[@data-testid='label_dp_shortname']/span")
  public PageElement labelDpShortName;

  @FindBy(xpath = "//div[@data-testid='label_dp_hub']/span")
  public PageElement labelDpHub;

  @FindBy(xpath = "//div[@data-testid='label_dp_address']/span")
  public PageElement labelDpAddress;

  @FindBy(xpath = "//div[@data-testid='label_dp_direction']/span")
  public PageElement labelDpDirection;

  @FindBy(xpath = "//div[@data-testid='label_dp_activity']/span")
  public PageElement labelDpActivity;

  @FindBy(xpath = "//div[@data-testid='label_username']/span")
  public PageElement labelUsername;

  @FindBy(xpath = "//div[@data-testid='label_dp_id']/span")
  public PageElement labelDpId;

  @FindBy(xpath = "//div[@data-testid='label_first_name']/span")
  public PageElement labelUserFirstName;

  @FindBy(xpath = "//div[@data-testid='label_last_name']/span")
  public PageElement labelUserLastName;

  @FindBy(xpath = "//div[@class='ant-space-item']/span[contains(@class,'ant-typography')]")
  public PageElement labelPasswordNotMatch;

  @FindBy(xpath = "//div[@data-testid='edit-user-title']")
  public PageElement labelEditUserTitle;

  @FindBy(xpath = "//div[@data-testid='label_email']/span")
  public PageElement labelUserEmail;

  @FindBy(xpath = "//div[@data-testid='label_contact']/span")
  public PageElement labelUserContact;

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

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement errorNotification;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']/div/div[3]/span")
  public PageElement errorMsgUsernameDuplicate;

  @FindBy(xpath = "//input[@value='RETAIL_POINT_NETWORK']")
  public PageElement checkBoxRetailPointNetwork;

  @FindBy(xpath = "//*[@value='RETAIL_POINT_NETWORK'][not(@disabled)]")
  public Button buttonRetailPointNetwork;

  @FindBy(xpath = "//*[@data-testid='checkbox_service_offered_post'][not(@enabled)]")
  public Button checkBoxServiceOfferedPostDisabled;

  @FindBy(xpath = "//*[@value='FRANCHISEE'][not(@enabled)]")
  public Button checkBoxFranchiseeDisabled;

  @FindBy(xpath = "//input[@data-testid='checkbox_publicly_point_displayed']")
  public PageElement checkBoxPublicityPointDisplayed;

  @FindBy(xpath = "//input[@data-testid='checkbox_hyperlocal']")
  public PageElement checkBoxHyperLocal;

  @FindBy(xpath = "//input[@data-testid='checkbox_auto_reservation_enabled']")
  public PageElement checkBoxAutoReservationEnabled;

  @FindBy(xpath = "//input[@data-testid='reserved_cutoff_time']")
  public TextBox formAutoReservationCutOff;

  @FindBy(xpath = "//input[@data-testid='checkbox_active_point']")
  public PageElement checkBoxActivePoint;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_service_offered_return']")
  public Button checkBoxReturnServiceChecked;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_service_offered_send']")
  public Button checkBoxAllowShipperSendChecked;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_service_offered_customer_collect']")
  public Button checkBoxAllowCustomerCollectChecked;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_sell_packs_at_point']")
  public Button checkBoxSellsPackAtPointChecked;

  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[2]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursMonday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[3]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursTuesday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[4]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursWednesday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[5]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursThursday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[6]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursFriday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[7]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursSaturday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]/div[@class='ant-card-body']/div[8]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOpeningHoursSunday;

  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[2]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursMonday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[3]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursTuesday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[4]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursWednesday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[5]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursThursday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[6]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursFriday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[7]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursSaturday;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]/div[@class='ant-card-body']/div[8]/button[@data-testid='button_add_time_slot']")
  public Button buttonAddTimeSlotOperatingHoursSunday;


  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[2]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursMonday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[3]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursTuesday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[4]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursWednesday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[5]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursThursday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[6]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursFriday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[7]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursSaturday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][2]/div/div[8]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOpeningHoursSunday;

  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[2]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursMonday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[3]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursTuesday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[4]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursWednesday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[5]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursThursday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[6]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursFriday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[7]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursSaturday;
  @FindBy(xpath = "//div[@class='ant-card-body'][1]/div[contains(@class,'ant-card')][3]/div/div[8]//a[@data-testid='hyperlink_remove_opening_hours'][1]")
  public PageElement buttonCutOffOperatingHoursSunday;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered sadqt2-1 foYRUM'][1]/div/div[2]//span[@class='ant-picker-clear']")
  public PageElement buttonRemoveFirstOpeningHour;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered sadqt2-1 foYRUM'][2]/div/div[2]//span[@class='ant-picker-clear']")
  public PageElement buttonRemoveFirstOperatingHour;


  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]//input[@data-testid='checkbox_edit_days_individually']")
  public PageElement buttonEditDaysIndividuallyOpeningHours;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][1]//button[@data-testid='button_apply_to_all_days']")
  public PageElement buttonApplyFirstDaySlotsOpeningHours;

  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]//input[@data-testid='checkbox_edit_days_individually']")
  public PageElement buttonEditDaysIndividuallyOperatingHours;
  @FindBy(xpath = "//div[contains(@class,'sadqt2-1')][2]//button[@data-testid='button_apply_to_all_days']")
  public PageElement buttonApplyFirstDaySlotsOperatingHours;


  public static final String ERROR_MSG_NOT_PHONE_NUM = "That doesn't look like a phone number.";
  public static final String ERROR_MSG_NOT_EMAIL_FORMAT = "That doesn't look like an email.";
  public static final String ERROR_MSG_DUPLICATE_USERNAME = "Username '%s' not available, please specify another username";
  public static final String ERROR_MSG_FIELD_REQUIRED = "This field is required";
  public static final String ERROR_MSG_FIELD_WRONG_FORMAT = "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )";

  public static final String ERROR_MSG_ALERT_XPATH = "//div[@role='alert'][text()='%s']";
  public static final String CHOOSE_SHIPPER_ACCOUNT_XPATH = "//div[@data-testid='option_shipper_account_no']/div[contains(text(),'%s')]";
  public static final String CHOOSE_ALTERNATIVE_DP_XPATH = "//div[@class='rc-virtual-list']//div[@class='ant-select-item-option-content'][contains(text(),'%s')]";
  public static final String CHOOSE_ASSIGNED_HUB_XPATH = "//div[@data-testid='option_assigned_hub']/div[text()='%s']";
  public static final String CHOOSE_SEARCH_FIRST_OPTIONS = "//div[@class='rc-virtual-list-holder-inner']/div[contains(@class,'ant-select-item')][1]/div[text()='%s']";
  public static final String DP_PHOTO_FILE_FIELD = "//div[@class='ant-upload-list-item-info']";

  public static final String SINGLE = "SINGLE";
  public static final String NEXT = "NEXT";
  public static final String OPENING_HOURS = "OPENING_HOURS";
  public static final String OPERATING_HOURS = "OPERATING_HOURS";

  public static final String RETAIL_POINT_NETWORK_ENABLED = "RETAIL_POINT_NETWORK_ENABLED";
  public static final String FRANCHISEE_DISABLED = "FRANCHISEE_DISABLED";
  public static final String SEND_CHECK = "SEND_CHECK";
  public static final String PACK_CHECK = "PACK_CHECK";
  public static final String RETURN_CHECK = "RETURN_CHECK";
  public static final String CUSTOMER_COLLECT_CHECK = "CUSTOMER_COLLECT_CHECK";
  public static final String SELL_PACK_AT_POINT_CHECK = "SELL_PACK_AT_POINT_CHECK";
  public static final String POST_DISABLED = "POST_DISABLED";

  public static final String POINT_NAME = "Point Name";
  public static final String SHORT_NAME = "Short Name";
  public static final String CONTACT_NUMBER = "Contact Number";
  public static final String POSTCODE = "Postcode";
  public static final String CITY = "City";
  public static final String POINT_ADDRESS_1 = "Point Address 1";
  public static final String FLOOR_NO = "Floor No";
  public static final String UNIT_NO = "Unit No";
  public static final String LATITUDE = "Latitude";
  public static final String LONGITUDE = "Longitude";
  public static final String PUDO_POINT_TYPE = "Pudo Point Type";
  public static final String SERVICE_TYPE = "Service Type";
  public static final String MAXIMUM_PARCEL_CAPACITY = "Maximum Parcel Capacity";
  public static final String BUFFER_CAPACITY = "Buffer Capacity";
  public static final String EXTERNAL_STORE_ID = "External Store Id";
  public static final String MAXIMUM_PARCEL_STAY = "Maximum Parcel Stay";
  public static final String POPUP_CHANGE_ALTERNATE_DP_MSG = "Select another distribution point or update field to Alternate Distribution Point ID %s?";

  public static final String RETAIL_POINT_NETWORK = "RETAIL_POINT_NETWORK";
  public static final String CREATE = "CREATE";
  public static final String DPS = "dps";
  private static final Logger LOGGER = LoggerFactory.getLogger(DpAdministrationReactPage.class);

  public ImmutableMap<String, PageElement> getAlternateDpText = ImmutableMap.<String, PageElement>builder()
      .put("ADP1", elementAlternateDPId1)
      .put("ADP2", elementAlternateDPId2)
      .put("ADP3", elementAlternateDPId3)
      .build();

  public ImmutableMap<String, TextBox> textBoxOpeningStartTime = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOpeningStartHourMonday)
      .put("tuesday", fieldOpeningStartHourTuesday)
      .put("wednesday", fieldOpeningStartHourWednesday)
      .put("thursday", fieldOpeningStartHourThursday)
      .put("friday", fieldOpeningStartHourFriday)
      .put("saturday", fieldOpeningStartHourSaturday)
      .put("sunday", fieldOpeningStartHourSunday)
      .build();

  public ImmutableMap<String, PageElement> cutOffOpeningHour = ImmutableMap.<String, PageElement>builder()
      .put("monday", buttonCutOffOpeningHoursMonday)
      .put("tuesday", buttonCutOffOpeningHoursTuesday)
      .put("wednesday", buttonCutOffOpeningHoursWednesday)
      .put("thursday", buttonCutOffOpeningHoursThursday)
      .put("friday", buttonCutOffOpeningHoursFriday)
      .put("saturday", buttonCutOffOpeningHoursSaturday)
      .put("sunday", buttonCutOffOpeningHoursSunday)
      .build();


  public ImmutableMap<String, PageElement> cutOffOperatingHour = ImmutableMap.<String, PageElement>builder()
      .put("monday", buttonCutOffOperatingHoursMonday)
      .put("tuesday", buttonCutOffOperatingHoursTuesday)
      .put("wednesday", buttonCutOffOperatingHoursWednesday)
      .put("thursday", buttonCutOffOperatingHoursThursday)
      .put("friday", buttonCutOffOperatingHoursFriday)
      .put("saturday", buttonCutOffOperatingHoursSaturday)
      .put("sunday", buttonCutOffOperatingHoursSunday)
      .build();

  public ImmutableMap<String, TextBox> textBoxOpeningStartTimeNext = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOpeningStartHourMondayNext)
      .put("tuesday", fieldOpeningStartHourTuesdayNext)
      .put("wednesday", fieldOpeningStartHourWednesdayNext)
      .put("thursday", fieldOpeningStartHourThursdayNext)
      .put("friday", fieldOpeningStartHourFridayNext)
      .put("saturday", fieldOpeningStartHourSaturdayNext)
      .put("sunday", fieldOpeningStartHourSundayNext)
      .build();

  public ImmutableMap<String, TextBox> textBoxOpeningEndTimeNext = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOpeningEndHourMondayNext)
      .put("tuesday", fieldOpeningEndHourTuesdayNext)
      .put("wednesday", fieldOpeningEndHourWednesdayNext)
      .put("thursday", fieldOpeningEndHourThursdayNext)
      .put("friday", fieldOpeningEndHourFridayNext)
      .put("saturday", fieldOpeningEndHourSaturdayNext)
      .put("sunday", fieldOpeningEndHourSundayNext)
      .build();

  public ImmutableMap<String, Button> buttonAddTimeSlotOpeningHour = ImmutableMap.<String, Button>builder()
      .put("monday", buttonAddTimeSlotOpeningHoursMonday)
      .put("tuesday", buttonAddTimeSlotOpeningHoursTuesday)
      .put("wednesday", buttonAddTimeSlotOpeningHoursWednesday)
      .put("thursday", buttonAddTimeSlotOpeningHoursThursday)
      .put("friday", buttonAddTimeSlotOpeningHoursFriday)
      .put("saturday", buttonAddTimeSlotOpeningHoursSaturday)
      .put("sunday", buttonAddTimeSlotOpeningHoursSunday)
      .build();

  public ImmutableMap<String, Button> buttonAddTimeSlotOperatingHour = ImmutableMap.<String, Button>builder()
      .put("monday", buttonAddTimeSlotOperatingHoursMonday)
      .put("tuesday", buttonAddTimeSlotOperatingHoursTuesday)
      .put("wednesday", buttonAddTimeSlotOperatingHoursWednesday)
      .put("thursday", buttonAddTimeSlotOperatingHoursThursday)
      .put("friday", buttonAddTimeSlotOperatingHoursFriday)
      .put("saturday", buttonAddTimeSlotOperatingHoursSaturday)
      .put("sunday", buttonAddTimeSlotOperatingHoursSunday)
      .build();

  public ImmutableMap<String, TextBox> textBoxOpeningEndTime = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOpeningEndHourMonday)
      .put("tuesday", fieldOpeningEndHourTuesday)
      .put("wednesday", fieldOpeningEndHourWednesday)
      .put("thursday", fieldOpeningEndHourThursday)
      .put("friday", fieldOpeningEndHourFriday)
      .put("saturday", fieldOpeningEndHourSaturday)
      .put("sunday", fieldOpeningEndHourSunday)
      .build();

  public ImmutableMap<String, TextBox> textBoxOperatingStartTime = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOperatingStartHourMonday)
      .put("tuesday", fieldOperatingStartHourTuesday)
      .put("wednesday", fieldOperatingStartHourWednesday)
      .put("thursday", fieldOperatingStartHourThursday)
      .put("friday", fieldOperatingStartHourFriday)
      .put("saturday", fieldOperatingStartHourSaturday)
      .put("sunday", fieldOperatingStartHourSunday)
      .build();

  public ImmutableMap<String, TextBox> textBoxOperatingStartTimeNext = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOperatingStartHourMondayNext)
      .put("tuesday", fieldOperatingStartHourTuesdayNext)
      .put("wednesday", fieldOperatingStartHourWednesdayNext)
      .put("thursday", fieldOperatingStartHourThursdayNext)
      .put("friday", fieldOperatingStartHourFridayNext)
      .put("saturday", fieldOperatingStartHourSaturdayNext)
      .put("sunday", fieldOperatingStartHourSundayNext)
      .build();

  public ImmutableMap<String, TextBox> textBoxOperatingEndTime = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOperatingEndHourMonday)
      .put("tuesday", fieldOperatingEndHourTuesday)
      .put("wednesday", fieldOperatingEndHourWednesday)
      .put("thursday", fieldOperatingEndHourThursday)
      .put("friday", fieldOperatingEndHourFriday)
      .put("saturday", fieldOperatingEndHourSaturday)
      .put("sunday", fieldOperatingEndHourSunday)
      .build();

  public ImmutableMap<String, TextBox> textBoxOperatingEndTimeNext = ImmutableMap.<String, TextBox>builder()
      .put("monday", fieldOperatingEndHourMondayNext)
      .put("tuesday", fieldOperatingEndHourTuesdayNext)
      .put("wednesday", fieldOperatingEndHourWednesdayNext)
      .put("thursday", fieldOperatingEndHourThursdayNext)
      .put("friday", fieldOperatingEndHourFridayNext)
      .put("saturday", fieldOperatingEndHourSaturdayNext)
      .put("sunday", fieldOperatingEndHourSundayNext)
      .build();

  public ImmutableMap<String, String> errorMandatoryField = ImmutableMap.<String, String>builder()
      .put(POINT_NAME, "Name is required")
      .put(SHORT_NAME, "Short Name is required")
      .put(CONTACT_NUMBER, "Contact Number is required")
      .put(POSTCODE, "Postal Code is required")
      .put(CITY, "City is required")
      .put(POINT_ADDRESS_1, "Address is required")
      .put(FLOOR_NO, "Floor No. is required")
      .put(UNIT_NO, "Unit No. is required")
      .put(LATITUDE, "Latitude is required")
      .put(LONGITUDE, "Longitude is required")
      .put(PUDO_POINT_TYPE, "type is required")
      .put(SERVICE_TYPE, "Service Type is required")
      .put(MAXIMUM_PARCEL_CAPACITY, "Actual Max Capacity is required")
      .put(BUFFER_CAPACITY, "Buffer Capacity is required")
      .build();

  public ImmutableMap<String, String> errorField = ImmutableMap.<String, String>builder()
      .put(POINT_NAME,
          "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(SHORT_NAME,
          "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(CITY,
          "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(EXTERNAL_STORE_ID,
          "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(POSTCODE, "Please enter a valid number.")
      .put(FLOOR_NO, "Floor No. is required")
      .put(UNIT_NO, "Unit No. is required")
      .put(LATITUDE, "please enter valid number.")
      .put(LONGITUDE, "please enter valid number.")
      .put(MAXIMUM_PARCEL_CAPACITY, "please enter valid number.")
      .put(BUFFER_CAPACITY, "please enter valid number.")
      .put(MAXIMUM_PARCEL_STAY, "please enter valid number.")
      .build();


  public ImmutableMap<String, Button> checkBoxValidationCheck = ImmutableMap.<String, Button>builder()
      .put(RETAIL_POINT_NETWORK_ENABLED, buttonRetailPointNetwork)
      .put(FRANCHISEE_DISABLED, checkBoxFranchiseeDisabled)
      .put(SEND_CHECK, checkBoxAllowShipperSendChecked)
      .put(PACK_CHECK, checkBoxSellsPackAtPointChecked)
      .put(RETURN_CHECK, checkBoxReturnServiceChecked)
      .put(POST_DISABLED, checkBoxServiceOfferedPostDisabled)
      .put(CUSTOMER_COLLECT_CHECK, checkBoxAllowCustomerCollectChecked)
      .put(SELL_PACK_AT_POINT_CHECK, checkBoxSellsPackAtPointChecked)
      .build();

  public ImmutableMap<String, TextBox> textBoxDpPartnerFilter = ImmutableMap.<String, TextBox>builder()
      .put("id", filterPartnerId)
      .put("name", filterPartnerName)
      .put("pocName", filterPocName)
      .put("pocTel", filterPocNo)
      .put("pocEmail", filterPocEmail)
      .put("restrictions", filterRestrictions)
      .build();

  public ImmutableMap<String, TextBox> textBoxDpFilter = ImmutableMap.<String, TextBox>builder()
      .put("id", filterDpId)
      .put("name", filterDpName)
      .put("shortName", filterDpShortName)
      .put("hub", filterDpHub)
      .put("address", filterDpAddress)
      .put("direction", filterDpDirection)
      .put("activity", filterDpActivity)
      .build();

  public ImmutableMap<String, TextBox> textBoxDpUserFilter = ImmutableMap.<String, TextBox>builder()
      .put("username", filterDpUserUsername)
      .put("firstName", filterDpUserFirstName)
      .put("lastName", filterDpUserLastName)
      .put("email", filterDpUserEmail)
      .put("contact", filterDpUserContact)
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

  public void mandatoryFieldError(String field) {
    Assertions.assertThat(isElementExist(f(ERROR_MSG_ALERT_XPATH, errorMandatoryField.get(field))))
        .as(String.format("Error message from %s is exist: %s", field,
            errorMandatoryField.get(field)))
        .isTrue();
  }

  public void fieldErrorMsg(String field) {
    Assertions.assertThat(isElementExist(f(ERROR_MSG_ALERT_XPATH, errorField.get(field))))
        .as(String.format("Error message from %s is exist: %s", field, errorField.get(field)))
        .isTrue();
  }

  public void fillOpeningOperatingHour(String day, Hours hours, String iterate, String fieldName) {
    String startHour = hours.getStartTime();
    String[] splitStartHour = startHour.split(":");

    String endHour = hours.getEndTime();
    String[] splitEndHour = endHour.split(":");

    String valueStartHourToFill = splitStartHour[0] + " h " + splitStartHour[1] + " m";
    String valueEndHourToFill = splitEndHour[0] + " h " + splitEndHour[1] + " m";

    if (fieldName.equals(OPENING_HOURS)) {
      if (iterate.equals(SINGLE)) {
        textBoxOpeningStartTime.get(day).forceClear();
        textBoxOpeningStartTime.get(day).sendKeysAndEnterNoXpath(valueStartHourToFill);

        textBoxOpeningEndTime.get(day).forceClear();
        textBoxOpeningEndTime.get(day).sendKeysAndEnterNoXpath(valueEndHourToFill);
      } else if (iterate.equals(NEXT)) {
        textBoxOpeningStartTimeNext.get(day).forceClear();
        textBoxOpeningStartTimeNext.get(day).sendKeysAndEnterNoXpath(valueStartHourToFill);

        textBoxOpeningEndTimeNext.get(day).forceClear();
        textBoxOpeningEndTimeNext.get(day).sendKeysAndEnterNoXpath(valueEndHourToFill);
      }
    } else if (fieldName.equals(OPERATING_HOURS)) {

      if (iterate.equals(SINGLE)) {
        textBoxOperatingStartTime.get(day).forceClear();
        textBoxOperatingStartTime.get(day).sendKeysAndEnterNoXpath(valueStartHourToFill);

        textBoxOperatingEndTime.get(day).forceClear();
        textBoxOperatingEndTime.get(day).sendKeysAndEnterNoXpath(valueEndHourToFill);
      } else if (iterate.equals(NEXT)) {
        textBoxOperatingStartTimeNext.get(day).forceClear();
        textBoxOperatingStartTimeNext.get(day).sendKeysAndEnterNoXpath(valueStartHourToFill);

        textBoxOperatingEndTimeNext.get(day).forceClear();
        textBoxOperatingEndTimeNext.get(day).sendKeysAndEnterNoXpath(valueEndHourToFill);
      }
    }

  }

  public void chooseAlternateDp(Long alternateDPId) {
    waitUntilVisibilityOfElementLocated(f(CHOOSE_ALTERNATIVE_DP_XPATH, alternateDPId));
    click(f(CHOOSE_ALTERNATIVE_DP_XPATH, alternateDPId));
  }

  public void fillAutoReservationCutoffTime(String cutoffTime) {
    formAutoReservationCutOff.forceClear();
    String []cutoffTimeElement = cutoffTime.split(":");
    String cutOffTimeFill = f("%s h %s m",cutoffTimeElement[0],cutoffTimeElement[1]);
    formAutoReservationCutOff.sendKeysAndEnterNoXpath(cutOffTimeFill);
  }


  public void popupMsgAlternateDP(String alternateDpId) {
    String popupMsg = f(POPUP_CHANGE_ALTERNATE_DP_MSG, alternateDpId);
    Assertions.assertThat(elementRemoveMsg1.getText() + " " + elementRemoveMsg2.getText())
        .as(f("Popup message is: %s", popupMsg))
        .isEqualTo(popupMsg);
  }

  public void chooseInvalidAlternateDp(Long alternateDPId) {
    try {
      waitUntilVisibilityOfElementLocated(f(CHOOSE_ALTERNATIVE_DP_XPATH, alternateDPId));
      click(f(CHOOSE_ALTERNATIVE_DP_XPATH, alternateDPId));
    } catch (TimeoutException te) {
      LOGGER.info("Alternate DP Not Found");
    }
  }


  public void chooseShipperAccountDp(Long shipperId) {
    waitUntilVisibilityOfElementLocated(f(CHOOSE_SHIPPER_ACCOUNT_XPATH, shipperId));
    click(f(CHOOSE_SHIPPER_ACCOUNT_XPATH, shipperId));
  }

  public void chooseShipperAssignedHub(String hubName) {
    waitUntilVisibilityOfElementLocated(f(CHOOSE_ASSIGNED_HUB_XPATH, hubName));
    click(f(CHOOSE_ASSIGNED_HUB_XPATH, hubName));
  }

  public void removeExistingPicture() {
    moveToElementWithXpath(DP_PHOTO_FILE_FIELD);
    buttonRemovePicture.click();
    buttonConfirmRemove.click();
  }

  public void chooseFromSearch(String searchName) {
    waitUntilVisibilityOfElementLocated(f(CHOOSE_SEARCH_FIRST_OPTIONS, searchName));
    moveToElementWithXpath(f(CHOOSE_SEARCH_FIRST_OPTIONS, searchName));
    click(f(CHOOSE_SEARCH_FIRST_OPTIONS, searchName));
  }


  public DpUser convertUserToDpUser(User user) {
    DpUser dpUser = new DpUser();
    dpUser.setId(user.getId());
    dpUser.setUsername(user.getUsername());
    dpUser.setContactNo(user.getContactNo());
    dpUser.setFirstName(user.getFirstName());
    dpUser.setLastName(user.getLastName());
    dpUser.setEmailId(user.getEmail());
    return dpUser;
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
    textBoxDpPartnerFilter.get(field).waitUntilVisible(2);
    textBoxDpPartnerFilter.get(field).setValue(value);
  }

  public void fillFilterDpUser(String field, String value) {
    textBoxDpUserFilter.get(field).waitUntilVisible(2);
    textBoxDpUserFilter.get(field).setValue(value);
  }

  public void clearDpPartnerFilter(String field) {
    textBoxDpPartnerFilter.get(field).forceClear();
  }

  public void clearDpFilter(String field) {
    textBoxDpFilter.get(field).forceClear();
  }

  public void clearDpUserFilter(String field) {
    textBoxDpUserFilter.get(field).forceClear();
  }

  public void duplicateUsernameExist(DpUser dpUser) {
    Assertions.assertThat(errorMsgUsernameDuplicate.getText())
        .as(f("Error Message exist: %s", errorMsgUsernameDuplicate.getText()))
        .isEqualTo(f(ERROR_MSG_DUPLICATE_USERNAME, dpUser.getUsername()));
  }

  public void checkNewlyCreatedDpAndAuditMetadata(Dp dp, AuditMetadata auditMetadata) {
    LocalDateTime ldt = LocalDateTime.now();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    Assertions.assertThat(dp.getId())
        .as(f("dp_qa_gl/dps: dp_id and dpms_id is same %s", dp.getId()))
        .isEqualTo(dp.getDpmsId());

    Assertions.assertThat(dp.getServiceType())
        .as("dp_qa_gl/dps: type is RETAIL_POINT_NETWORK")
        .isEqualTo(RETAIL_POINT_NETWORK);

    Assertions.assertThat(auditMetadata.getRefId())
        .as(f("dp_qa_gl/audit_metadata: ref_id is %s", auditMetadata.getRefId()))
        .isNotNull();

    Assertions.assertThat(auditMetadata.getAuthUserId())
        .as(f("dp_qa_gl/audit_metadata: auth_user_id is %s", auditMetadata.getAuthUserId()))
        .isNotNull();

    Assertions.assertThat(auditMetadata.getType())
        .as("dp_qa_gl/audit_metadata: type is CREATE")
        .isEqualTo(CREATE);

    Assertions.assertThat(auditMetadata.getTableName())
        .as("dp_qa_gl/audit_metadata: table_name is dps")
        .isEqualTo(DPS);

    Assertions.assertThat(auditMetadata.getTableName())
        .as("dp_qa_gl/audit_metadata: table_name is dps")
        .isEqualTo(DPS);

    Assertions.assertThat(sdf.format(auditMetadata.getTriggeredAt()))
        .as("dp_qa_gl/audit_metadata: triggered_at is At Current Time")
        .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

    Assertions.assertThat(sdf.format(auditMetadata.getCreatedAt()))
        .as("dp_qa_gl/audit_metadata: created_at is At Current Time")
        .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));
  }

  public void checkNewlyCreatedDpBySearchAddressLatLong(Dp dp,
      DpDetailsResponse dpDetailsResponse) {

    if (dpDetailsResponse.getLatLongSearch() != null
        & dpDetailsResponse.getLatLongSearchName() != null) {
      Assertions.assertThat(dpDetailsResponse.getLatLongSearchName().replace(" ", ""))
          .as(f("dp_qa_gl/dps: Dp Address is %s", dp.getAddress1()))
          .containsIgnoringCase(dp.getAddress1().replace(" ", ""));
    } else if (dpDetailsResponse.getAddressSearch() != null
        & dpDetailsResponse.getAddressSearchName() != null) {
      Assertions.assertThat(dpDetailsResponse.getAddressSearchName().replace(" ", ""))
          .as(f("dp_qa_gl/dps: Dp Address is %s", dp.getAddress1()))
          .containsIgnoringCase(dp.getAddress1().replace(" ", ""));
    }

  }

  public void checkOpeningTime(String day, Integer dayNumber,
      List<DpOpeningHour> dpOpeningHours, Hours openingHour) {
    dpOpeningHours = dpOpeningHours.stream()
        .filter(days -> Objects.equals(days.getDayOfWeek(), dayNumber))
        .collect(Collectors.toList());

    for (DpOpeningHour doh : dpOpeningHours) {
      if (openingHour.getStartTime().equals(doh.getStartTime())) {
        Assertions.assertThat(openingHour.getStartTime())
            .as(f("dp_qa_gl/dp_opening_hours: start_time for %s is %s", day,
                doh.getStartTime()))
            .isEqualTo(doh.getStartTime());
      }
      if (openingHour.getEndTime().equals(doh.getEndTime())) {
        Assertions.assertThat(openingHour.getEndTime())
            .as(f("dp_qa_gl/dp_opening_hours: end_time for %s is %s", day,
                doh.getEndTime()))
            .isEqualTo(doh.getEndTime());
      }
    }


  }

  public void checkOperatingTime(String day, Integer dayNumber,
      List<DpOperatingHour> dpOperatingHours, Hours operatingHour) {
    dpOperatingHours = dpOperatingHours.stream()
        .filter(days -> Objects.equals(days.getDayOfWeek(), dayNumber))
        .collect(
            Collectors.toList());

    for (DpOperatingHour doh : dpOperatingHours) {
      if (operatingHour.getStartTime().equals(doh.getStartTime())) {
        Assertions.assertThat(operatingHour.getStartTime())
            .as(f("dp_qa_gl/dp_operating_hours: start_time for %s is %s", day,
                doh.getStartTime()))
            .isEqualTo(doh.getStartTime());
      }
      if (operatingHour.getEndTime().equals(doh.getEndTime())) {
        Assertions.assertThat(operatingHour.getEndTime())
            .as(f("dp_qa_gl/dp_operating_hours: end_time for %s is %s", day,
                doh.getEndTime()))
            .isEqualTo(doh.getEndTime());
      }
    }

  }

  public void errorCheckDpUser(DpUser dpUser) {
    formDpUserFirstName.setValue(dpUser.getFirstName());
    formDpUserFirstName.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if First Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserFirstName.setValue(dpUser.getFirstName());

    formDpUserLastName.setValue(dpUser.getLastName());
    formDpUserLastName.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Last Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserLastName.setValue(dpUser.getLastName());

    formDpUserContact.setValue(dpUser.getContactNo());
    formDpUserContact.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Contact is Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserContact.setValue(RandomStringUtils.random(10, true, false));
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Contact is filled with random character: %s",
            ERROR_MSG_NOT_PHONE_NUM))
        .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
    formDpUserContact.forceClear();
    formDpUserContact.setValue(dpUser.getContactNo());

    formDpUserEmail.setValue(dpUser.getEmailId());
    formDpUserEmail.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Email is Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserEmail.setValue(RandomStringUtils.random(10, true, false));
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Email is filled with wrong format (All Letter): %s",
            ERROR_MSG_NOT_EMAIL_FORMAT))
        .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
    formDpUserEmail.forceClear();
    formDpUserEmail.setValue(RandomStringUtils.random(10, false, true));
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Email is filled with wrong format (All Number): %s",
            ERROR_MSG_NOT_EMAIL_FORMAT))
        .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
    formDpUserEmail.forceClear();
    formDpUserEmail.setValue(dpUser.getEmailId());

    formDpUserUsername.setValue(dpUser.getUsername());
    formDpUserUsername.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Last Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserUsername.setValue(dpUser.getUsername());

    formDpUserPassword.setValue(dpUser.getPassword());
    formDpUserPassword.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Last Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserPassword.setValue(dpUser.getPassword());
  }

  public void errorCheckDpUser(String value, String errorKey) {
    switch (errorKey) {
      case "USFIRNME":
        formDpUserFirstName.forceClear();
        formDpUserFirstName.setValue(value);
        formDpUserFirstName.forceClear();
        break;
      case "USLANME":
        formDpUserLastName.forceClear();
        formDpUserLastName.setValue(value);
        formDpUserLastName.forceClear();
        break;
      case "INFIRNME":
        formDpUserFirstName.forceClear();
        formDpUserFirstName.setValue(value);
        break;
      case "INLANME":
        formDpUserLastName.forceClear();
        formDpUserLastName.setValue(value);
        break;
      case "CONTACT":
        formDpUserContact.forceClear();
        formDpUserContact.setValue(value);
        formDpUserContact.forceClear();
        break;
      case "!CONTACT":
        formDpUserContact.forceClear();
        formDpUserContact.setValue(value);
        break;
      case "USNME":
        formDpUserUsername.forceClear();
        formDpUserUsername.setValue(value);
        formDpUserUsername.forceClear();
        break;
      case "PWORD":
        formDpUserPassword.forceClear();
        formDpUserPassword.setValue(value);
        formDpUserPassword.forceClear();
        break;
      case "!USEMAIL":
        formDpUserEmail.forceClear();
        formDpUserEmail.setValue(value);
        break;
      case "USEMAIL":
        formDpUserEmail.forceClear();
        formDpUserEmail.setValue(value);
        formDpUserEmail.forceClear();
        break;

    }
  }


  public void errorCheckDpPartner(Partner dpPartner, String errorKey) {
    switch (errorKey) {
      case "NAME":
        formPartnerName.forceClear();
        formPartnerName.setValue(dpPartner.getName());
        formPartnerName.forceClear();
        break;
      case "!NAME":
        formPartnerName.forceClear();
        formPartnerName.setValue(dpPartner.getName());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form Partner Name with wrong format : %s",
                ERROR_MSG_FIELD_WRONG_FORMAT))
            .isEqualTo(ERROR_MSG_FIELD_WRONG_FORMAT);
        break;
      case "POCNME":
        formPocName.forceClear();
        formPocName.setValue(dpPartner.getPocName());
        formPocName.forceClear();
        break;
      case "!POCNME":
        formPocName.forceClear();
        formPocName.setValue(dpPartner.getPocName());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC Name with wrong format : %s",
                ERROR_MSG_FIELD_WRONG_FORMAT))
            .isEqualTo(ERROR_MSG_FIELD_WRONG_FORMAT);
        break;
      case "!POCNUM":
        formPocNo.forceClear();
        formPocNo.setValue(dpPartner.getPocTel());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC NO with wrong format (Not Number) : %s",
                ERROR_MSG_NOT_PHONE_NUM))
            .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
        break;
      case "POCNUM":
        formPocNo.forceClear();
        formPocNo.setValue(dpPartner.getPocTel());
        formPocNo.forceClear();
        break;
      case "RESTRICTION":
        formRestrictions.forceClear();
        formRestrictions.setValue(dpPartner.getRestrictions());
        formRestrictions.forceClear();
        break;
      case "!RESTRICTION":
        formRestrictions.forceClear();
        formRestrictions.setValue(dpPartner.getRestrictions());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form Restrictions with wrong format : %s",
                ERROR_MSG_FIELD_WRONG_FORMAT))
            .isEqualTo(ERROR_MSG_FIELD_WRONG_FORMAT);
        break;
      case "POCMAIL":
        formPocEmail.forceClear();
        formPocEmail.setValue(dpPartner.getPocEmail());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC Email with wrong format (Letters): %s",
                ERROR_MSG_NOT_EMAIL_FORMAT))
            .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
        break;
    }
  }

  public void clearDpPartnerForm(String errorKey) {
    switch (errorKey) {
      case "NAME":
      case "!NAME":
        formPartnerName.forceClear();
        break;
      case "POCNME":
      case "!POCNME":
        formPocName.forceClear();
        break;
      case "!POCNUM":
      case "POCNUM":
        formPocNo.forceClear();
        break;
      case "RESTRICTION":
      case "!RESTRICTION":
        formRestrictions.forceClear();
        break;
      case "POCMAIL":
        formPocEmail.forceClear();
        break;
    }
  }


  public void checkErrorMsg(String errMessage) {
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message: %s", errMessage))
        .isEqualTo(errMessage);
  }

  public void readDpPartnerEntity(DpPartner dpPartner) {
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

  public void readDpEntity(DpDetailsResponse dpDetails, String element) {

    Assertions.assertThat(element)
        .as(f("Element Input is %s", element))
        .isNotNull();

    Assertions.assertThat(labelDpId.getText())
        .as(f("Dp Id Is %s", dpDetails.getId()))
        .isEqualTo(Long.toString(dpDetails.getId()));

    Assertions.assertThat(labelDpName.getText())
        .as(f("Dp Name Is %s", dpDetails.getName()))
        .isEqualTo(dpDetails.getName());

    Assertions.assertThat(labelDpShortName.getText())
        .as(f("Dp Short Name Is %s", dpDetails.getShortName()))
        .isEqualTo(dpDetails.getShortName());

    Assertions.assertThat(labelDpAddress.getText())
        .as(f("Dp Address Is %s", dpDetails.getAddress1() + " " + dpDetails.getAddress2()))
        .containsIgnoringCase(dpDetails.getAddress1() + " " + dpDetails.getAddress2());

    Assertions.assertThat(labelDpDirection.getText())
        .as(f("Dp Directions Is %s", dpDetails.getDirections()))
        .isEqualTo(dpDetails.getDirections());

    Assertions.assertThat(labelDpActivity.getText())
        .as(f("Dp Activity Is %s", dpDetails.getIsActive() ? "Active" : "Inactive"))
        .isEqualTo(dpDetails.getIsActive() ? "Active" : "Inactive");

  }

  public void readDpUserEntity(DpUser dpUser) {
      if(dpUser.getUsername()!=null)
      {
        Assertions.assertThat(dpUser.getUsername()).as(f("username Is %s", dpUser.getUsername()))
            .isEqualTo(labelUsername.getText());
        LOGGER.info("getUsername compare is success");
      }
      if(dpUser.getFirstName()!=null)
      {
        Assertions.assertThat(dpUser.getFirstName()).as(f("First Name Is %s", dpUser.getFirstName()))
            .isEqualTo(labelUserFirstName.getText());
        LOGGER.info("getFirstName compare is success");
      }
      if(dpUser.getLastName()!=null)
      {
        Assertions.assertThat(dpUser.getLastName()).as(f("Last Name Is %s", dpUser.getLastName()))
            .isEqualTo(labelUserLastName.getText());
        LOGGER.info("getLastName compare is success");
      }
      if(dpUser.getEmailId()!=null)
      {
        Assertions.assertThat(dpUser.getEmailId()).as(f("Email Is %s", dpUser.getEmailId()))
            .isEqualTo(labelUserEmail.getText());
        LOGGER.info("getEmailId compare is success");
      }
      if(dpUser.getContactNo()!=null)
      {
        Assertions.assertThat(dpUser.getContactNo())
            .as(f("Contact No Is %s", dpUser.getContactNo()))
            .isEqualTo(labelUserContact.getText());
        LOGGER.info("getContactNo compare is success");
      }
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

  public String getDpUserElementByMap(String map, DpUser dpUser) {
    ImmutableMap<String, String> partnerElement = ImmutableMap.<String, String>builder()
        .put("username", dpUser.getUsername())
        .put("firstName", dpUser.getFirstName())
        .put("lastName", dpUser.getLastName())
        .put("email", dpUser.getEmailId())
        .put("contact", dpUser.getContactNo())
        .build();

    return partnerElement.get(map);
  }

  public String getDpElementByMap(String map, DpDetailsResponse dp) {
    ImmutableMap<String, String> dpElement = ImmutableMap.<String, String>builder()
        .put("id", Long.toString(dp.getId()))
        .put("name", dp.getName())
        .put("shortName", dp.getShortName())
        .put("hub", f("%s - %s", dp.getHubId(), dp.getHubName()))
        .put("address", dp.getAddress1())
        .put("direction", dp.getDirections())
        .put("activity", dp.getIsActive() ? "Active" : "Inactive")
        .build();

    return dpElement.get(map);
  }

  public void removeOpeningHoursDay() {
    moveToElementWithXpath("//input[@id='reservationSlots.monday[0].startTime']");
    buttonRemoveFirstOpeningHour.click();
    buttonRemoveFirstOpeningHour.click();
  }

  public void removeOperatingHoursDay() {
    moveToElementWithXpath("//input[@id='operatingHours.monday[0].startTime']");
    buttonRemoveFirstOperatingHour.click();
    buttonRemoveFirstOperatingHour.click();
  }
}
