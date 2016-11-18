import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.*; // for Button, dialogvindu, Checkbox, Hyperlink og andre grensesnittkontroller

public class SudokuException extends Exception{

    public SudokuException(String m){
        super(m);

        String btnStyle = "-fx-font-size: 50pt;";
        Alert alert = new Alert(AlertType.ERROR);
        alert.setTitle("Error dialog");
        alert.setHeaderText(null);
        alert.setContentText(m);
        alert.showAndWait();


    }

    public SudokuException(){
    }
}
