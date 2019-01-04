package co.nvqa.operator_v2.model;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.text.translate.CsvTranslators;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverTypeParams
{
    private static final CsvTranslators.CsvUnescaper UNESCAPER = new CsvTranslators.CsvUnescaper();

    private Long driverTypeId;
    private String driverTypeName;
    private String deliveryType;
    private String priorityLevel;
    private String reservationSize;
    private String parcelSize;
    private String timeslot;

    public DriverTypeParams()
    {
    }

    public Long getDriverTypeId()
    {
        return driverTypeId;
    }

    public void setDriverTypeId(Long driverTypeId)
    {
        this.driverTypeId = driverTypeId;
    }

    public String getDriverTypeName()
    {
        return driverTypeName;
    }

    public void setDriverTypeName(String driverTypeName)
    {
        this.driverTypeName = driverTypeName;
    }

    public String getDeliveryType()
    {
        return deliveryType;
    }

    public Set<String> getDeliveryTypes()
    {
        return stringToSet(getDeliveryType());
    }

    public void setDeliveryType(String deliveryType)
    {
        this.deliveryType = deliveryType;
    }

    public String getPriorityLevel()
    {
        return priorityLevel;
    }

    public Set<String> getPriorityLevels()
    {
        return stringToSet(getPriorityLevel());
    }

    public void setPriorityLevel(String priorityLevel)
    {
        this.priorityLevel = priorityLevel;
    }

    public String getReservationSize()
    {
        return reservationSize;
    }

    public Set<String> getReservationSizes()
    {
        return stringToSet(getReservationSize());
    }

    public void setReservationSize(String reservationSize)
    {
        this.reservationSize = reservationSize;
    }

    public String getParcelSize()
    {
        return parcelSize;
    }

    public Set<String> getParcelSizes()
    {
        return stringToSet(getParcelSize());
    }

    public void setParcelSize(String parcelSize)
    {
        this.parcelSize = parcelSize;
    }

    public String getTimeslot()
    {
        return timeslot;
    }

    public Set<String> getTimeslots()
    {
        return stringToSet(getTimeslot());
    }

    public void setTimeslot(String timeslot)
    {
        this.timeslot = timeslot;
    }

    @SuppressWarnings("WeakerAccess")
    public static DriverTypeParams fromCsvLine(String csvLine)
    {
        String[] values = csvLine.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
        DriverTypeParams params = new DriverTypeParams();
        params.setDriverTypeId(Long.parseLong(Objects.requireNonNull(getValueIfIndexExists(values, 0))));
        params.setDriverTypeName(getValueIfIndexExists(values, 1));
        params.setDeliveryType(getValueIfIndexExists(values, 2));
        params.setPriorityLevel(getValueIfIndexExists(values, 3));
        params.setReservationSize(getValueIfIndexExists(values, 4));
        params.setParcelSize(getValueIfIndexExists(values, 5));
        return params;
    }

    private static String getValueIfIndexExists(String[] values, int index)
    {
        if (values.length > index)
        {
            return StringUtils.trimToNull(StringUtils.strip(UNESCAPER.translate(values[index]), "\""));
        } else
        {
            return null;
        }
    }

    public static List<DriverTypeParams> fromCsvFile(String fileName, boolean ignoreHeader)
    {
        try
        {
            List<String> csvLines = FileUtils.readLines(new File(fileName), Charset.defaultCharset());
            if (ignoreHeader)
            {
                csvLines.remove(0);
            }
            return csvLines.stream().map(DriverTypeParams::fromCsvLine).collect(Collectors.toList());
        } catch (IOException ex)
        {
            NvLogger.warn("Could not read file [" + fileName + "]");
            return new ArrayList<>();
        }
    }

    private Set<String> stringToSet(String value)
    {
        return Arrays.stream(StringUtils.defaultIfBlank(value, "").split(","))
                .map(item -> StringUtils.normalizeSpace(item).trim()).collect(LinkedHashSet::new, LinkedHashSet<String>::add, (i, j) -> {
                });
    }

    public void fromMap(Map<String, String> dataMap)
    {
        String value = dataMap.get("driverTypeName");
        if (StringUtils.isNotBlank(value))
        {
            if (value.equalsIgnoreCase("GENERATED"))
            {
                value = "DT-" + TestUtils.generateDateUniqueString();
            }
            setDriverTypeName(value);
        }
        value = dataMap.get("deliveryType");
        if (StringUtils.isNotBlank(value))
        {
            setDeliveryType(value);
        }
        value = dataMap.get("priorityLevel");
        if (StringUtils.isNotBlank(value))
        {
            setPriorityLevel(value);
        }
        value = dataMap.get("reservationSize");
        if (StringUtils.isNotBlank(value))
        {
            setReservationSize(value);
        }
        value = dataMap.get("parcelSize");
        if (StringUtils.isNotBlank(value))
        {
            setParcelSize(value);
        }
        value = dataMap.get("timeslot");
        if (StringUtils.isNotBlank(value))
        {
            setTimeslot(value);
        }
    }
}
