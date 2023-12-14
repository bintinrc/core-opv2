package co.nvqa.operator_v2.util;

import co.nvqa.common.utils.DateUtil;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class CoreDateUtil extends DateUtil {

  public static final SimpleDateFormat SDF_YYYY_MM_DD = new SimpleDateFormat("yyyy-MM-dd");
  public static final SimpleDateFormat SDF_YYYY_MM_DD_HH_MM_SS = new SimpleDateFormat(
      "yyyy-MM-dd HH:mm:ss");
  private static ZoneId DEFAULT_ZONE_ID = ZoneId.systemDefault();
  private static final ZoneId UTC_ZONE_ID = ZoneId.of("UTC");

  private static final String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
  public static final String DATE_FORMAT = "yyyy-MM-dd";
  private static final String ISO8601_FORMAT_LITE = "yyyy-MM-dd'T'HH:mm:ss'Z'";

  public static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter
      .ofPattern(DATE_TIME_FORMAT);
  public static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern(DATE_FORMAT);
  public static final DateTimeFormatter ISO8601_LITE_FORMATTER = DateTimeFormatter
      .ofPattern(ISO8601_FORMAT_LITE);

  public static ZonedDateTime getDate(ZoneId zoneId) {
    return ZonedDateTime.now(zoneId);
  }

  public static String displayDate(ZonedDateTime zdt) {
    return DATE_FORMATTER.format(zdt);
  }

  public static ZonedDateTime fromDate(Date date) {
    return ZonedDateTime.ofInstant(Instant.ofEpochMilli(date.getTime()), DEFAULT_ZONE_ID);
  }

  public static String getDefaultDateTimeFromUTC(String dateTime) {
    return LocalDateTime.parse(dateTime, DATE_TIME_FORMATTER)
        .atZone(UTC_ZONE_ID)
        .withZoneSameInstant(DEFAULT_ZONE_ID)
        .format(DATE_TIME_FORMATTER);
  }
}
