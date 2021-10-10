package co.nvqa.operator_v2.model;

/**
 * @author Veera N
 */


public class StationLanguage{

    public enum HeaderText {

        ENGLISH("Station Management Homepage"),
        MALAY("Station Management Homepage"),
        INDONESIAN("Beranda Manajemen Stasiun"),
        VIETNAM("Trang quản lý trạm"),
        THAI("โฮมเพจการจัดการสถานี"),
        BURMESE("Station Management Homepage"),
        DEFAULT("Station Management Homepage");

        private String headerText;

        HeaderText(String headerText) {
            this.headerText = headerText;
        }

        public String getText() {
            return headerText;
        }
        public static HeaderText getLanguage(String text){
            for(HeaderText language : HeaderText.values()){
                if(language.getText().equals(text)){
                    return language;
                }
            }
            return HeaderText.DEFAULT;
        }
    }

    public enum ModalText {

        ENGLISH("Welcome to Station Management Tool"),
        MALAY("Selamat Datang ke Alat Bantuan Pengurusan Stesen"),
        INDONESIAN("Selamat Datang di Perangkat Station Management"),
        VIETNAM("Xin chào đến trang quản lý hàng hóa trạm giao nhận"),
        THAI("ยินดีต้อนรับสู่ Station Management Tool"),
        BURMESE("Station Management Tool မှ ကြိုဆိုပါသည်။"),
        DEFAULT("Welcome to Station Management Tool");

        private String text;

        ModalText(String text) {
            this.text = text;
        }

        public String getText() {
            return text;
        }

        public static ModalText getLanguage(String text){
            for(ModalText language : ModalText.values()){
                if(language.getText().equals(text)){
                    return language;
                }
            }
            return ModalText.DEFAULT;
        }
    }

    public enum HubSelectionText {

        ENGLISH("Search or Select"),
        MALAY("Cari atau Pilih"),
        INDONESIAN("Cari atau Pilih"),
        VIETNAM("Tìm hoặc chọn"),
        THAI("ค้นหาหรือเลือก"),
        BURMESE("ရှာဖွေပါ သို့မဟုတ် ရွေးပါ"),
        DEFAULT("Search or Select");

        private String text;

        HubSelectionText(String text) {
            this.text = text;
        }

        public String getText() {
            return text;
        }

        public static HubSelectionText getLanguage(String text){
            for(HubSelectionText language : HubSelectionText.values()){
                if(language.getText().equals(text)){
                    return language;
                }
            }
            return HubSelectionText.DEFAULT;
        }
    }

    public enum PollingTimeText {

        ENGLISH("Refresh the page to retrieve updated data"),
        MALAY("Refresh the page to retrieve updated data"),
        INDONESIAN("Perbarui halaman untuk melihat data terbaru"),
        VIETNAM("Tải lại trang để cập nhận số liệu mới nhất"),
        THAI("รีเฟรชหน้าเพื่อดึงข้อมูลที่อัปเดต"),
        BURMESE("Refresh the page to retrieve updated data"),
        DEFAULT("Refresh the page to retrieve updated data");

        private String text;

        PollingTimeText(String text) {
            this.text = text;
        }

        public String getText() {
            return text;
        }

        public static PollingTimeText getLanguage(String text){
            for(PollingTimeText language : PollingTimeText.values()){
                if(language.getText().equals(text)){
                    return language;
                }
            }
            return PollingTimeText.DEFAULT;
        }
    }

}





