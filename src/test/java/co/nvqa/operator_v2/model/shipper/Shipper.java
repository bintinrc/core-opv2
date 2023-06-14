package co.nvqa.operator_v2.model.shipper;

import co.nvqa.common.model.DataEntity;
import java.io.Serializable;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@SuppressWarnings("unused")
public class Shipper extends DataEntity<Shipper> implements Serializable {

  /**
   * Basic information.
   */
  private Long id;

  /**
   * This fields below is required to create a new shipper.
   */
  private String name;
  private String companyName;
  private String shortName;
  private String email;
  private String contact;

  private Long legacyId;
  private String country;
  private Boolean active;
  private Boolean archived;
  private String salesPerson;

  private String liaisonName;
  private String liaisonEmail;
  private String liaisonContact;
  private String liaisonAddress;
  private String liaisonPostcode;

  private String billingName;
  private String billingContact;
  private String billingAddress;
  private String billingPostcode;

  private Long industryId;
  private Long distributionChannelId;
  private Long accountTypeId;
  private String dashPassword;

  /**
   * Additional Field
   */
  private String industryName;
  private String type;
  private String shipperDashboardPassword;
  private String externalRef;
  private Map<String, Object> metadata;

  /**
   * Shipper Settings.
   */
  private OrderCreate orderCreate;
  private SubShipperDefaultSettings subShippersDefaults;
  private Reservation reservation;
  private Shopify shopify;
  private Return returns;
  private LabelPrinter labelPrinter;
  private Qoo10 qoo10;
  private Pricing pricing;
  private Magento magento;
  private DistributionPoint distributionPoints;
  private MarketplaceBilling marketplaceBilling;
  private MarketplaceDefault marketplaceDefault;
  private Notification notification;
  private Pickup pickup;
  private Delivery delivery;

  /**
   * Additional legacy settings for marketplace seller creation.
   */
  private OrderCreate orderCreateSettings;
  private Reservation reservationSettings;
  private Return returnsSettings;


  /**
   * Additional info to save shipper credentials.
   */
  private String clientId;
  private String clientSecret;

  /**
   * Additional info to save shipper's prefix.
   */
  private String prefix;

  public Shipper() {
  }

  public Shipper(Long id, Long legacyId, String clientId, String clientSecret) {
    this.id = id;
    this.legacyId = legacyId;
    this.clientId = clientId;
    this.clientSecret = clientSecret;
  }
}
