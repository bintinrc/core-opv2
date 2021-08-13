package co.nvqa.operator_v2;

/**
 * Dummy main class to test anything.
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TestRunner {

  @SuppressWarnings("EmptyMethod")
  public static void main(String[] args) {

    // final String fileName = "src/test/java/co/nvqa/operator_v2/2021-08-04-2021-08-04_all_COMPLETED_orders_1_Of_1.csv";
    //final String fileName = "/tmp/operator-v2/10-Aug-2021_022104_684/order_billing_1628576586271/2021-08-10-2021-08-10_all_COMPLETED_orders_1_Of_1.csv";
    //   final String pathToZip = "/tmp/operator-v2/10-Aug-2021_024212_737/order_billing_1628570559305/";
//    final String pathToZip = "/tmp/operator-v2/10-Aug-2021_024212_737/order_billing_1628578037462/";
    //  final String pathToZip = "src/test/java/co/nvqa/operator_v2/nadeera/";
    //  final String fileName = "/2021-08-10-2021-08-10_all_COMPLETED_orders_1_Of_1.csv";

//    List result2 = CsvUtils.convertToObjects(
//        fileName, SsbColumns.class);
//
//    InputStream is = fileName.getInputStream(entry);
////        BufferedReader reader = new BufferedReader(new InputStreamReader(new BOMInputStream(is),
////            StandardCharsets.UTF_8));
//
//    List result3= new CsvToBeanBuilder(new BufferedReader(new InputStreamReader(new BOMInputStream(fileName),
//        StandardCharsets.UTF_8)))
//        .withType(SsbColumns.class)
//        .build()
//        .parse();
//
//
//
//    System.out.println(Arrays.toString(result2.toArray()));

//    try (ZipFile zipFile = new ZipFile("src/test/java/co/nvqa/operator_v2/AUTOMATION-EDITED-2021-08-10-2021-08-10-sg-1628678080018.zip")) {
    try (ZipFile zipFile = new ZipFile("src/test/java/co/nvqa/operator_v2/nadeera.zip")) {
      //try (ZipFile zipFile = new ZipFile(pathToZip + "order_billing.zip")) {

      Enumeration<? extends ZipEntry> entries = zipFile.entries();

      while (entries.hasMoreElements()) {
        ZipEntry entry = entries.nextElement();

        InputStream is = zipFile.getInputStream(entry);
        BufferedReader reader = new BufferedReader(new InputStreamReader(new BOMInputStream(is),
            StandardCharsets.UTF_8));

        while (reader.ready()) {
//            String line = reader.readLine();
//          System.out.println("NADEERA"+ line);
//            if (line.startsWith("\"Legacy Shipper ID")) {
//              System.out.println("NADEERA2"+ line);
//            }

          List<SsbColumns> listOfPricedOrderEntries = CsvUtils.convertToObjects(
              reader, SsbColumns.class);
          System.out.println("NADEERA BODY" + Arrays.toString(listOfPricedOrderEntries.toArray()));
        }

      }
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}