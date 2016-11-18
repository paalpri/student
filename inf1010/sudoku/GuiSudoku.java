import javafx.application.Application; // Klassen alle JavaFX-applikasjoner utvider
import javafx.event.ActionEvent; // Se javafx.event.Event for andre typer events
import javafx.event.EventHandler; // Tilsvarer ActionListener i swing
import javafx.scene.image.*; // for bilder av forskjellige formater png, jpg ...
import javafx.scene.Scene; // Beholderen for alt innholdet
import javafx.scene.text.Text; // En tekstnode
import javafx.scene.layout.*; // for panes, HBox, VBox andre layoutnoder
import javafx.scene.control.*; // for Button, dialogvindu, Checkbox, Hyperlink og andre grensesnittkontroller
import javafx.geometry.*; // plassering, orientering o.l.
import javafx.stage.*; // Hoeyeste nivaa av JavaFX-beholdere
import javafx.scene.paint.Color;  // Definerer fargekonstanter
import javafx.scene.text.Font; // For fonter
import javafx.scene.text.FontWeight;  // For fonttype normal, bold, italic osv.
import javafx.stage.FileChooser;
import java.io.*;
import java.util.*;
import java.awt.Desktop;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.Node;


public class GuiSudoku extends Application{

    public static void main(String[] args) {
        Application.launch(args);
    }

    static Stage vindu;
    Brett brett;
    Sudokubeholder beholder;
    Text antall;
    GridPane grid = new GridPane();
    int z;

    @Override
    public void start(Stage vindu){
        this.vindu = vindu;
        BorderPane border = new BorderPane();

        border.setTop(nyHbox());
        border.setCenter(grid);
        border.setLeft(nyVBox());

        Scene scene = new Scene(border, 1800,1400, Color.WHITE);


        scene.getStylesheets().add("Sudoku.css");
        vindu.setScene(scene);
        vindu.show();
        vindu.setTitle("Sudoku shit going on in this CRIB!!");

    }

    private VBox nyVBox(){
        VBox vbox = new VBox();
        vbox.setPadding(new Insets(20));
        vbox.setSpacing(8);

        Text title = new Text("Løsninger funnet:");
        title.setFont(Font.font("Arial", FontWeight.BOLD, 30));
        vbox.getChildren().add(title);

        antall = new Text(" 0");
        antall.setFont(Font.font("Arial", FontWeight.BOLD, 30));
        vbox.getChildren().add(antall);

        return vbox;
    }


    private HBox nyHbox(){
        String btnStyle = "-fx-font-size: 20pt;";
        HBox hbox = new HBox();
        hbox.setPadding(new Insets(15, 12, 15, 12));
        hbox.setSpacing(10);   // Avstand mellom nodene
        hbox.setStyle("-fx-background-color: #BC8F8F;");

        FocusButton knappHentFil = new FocusButton("Les inn brett fra fil");
        knappHentFil.setStyle(btnStyle);
        FileChooser fileChooser = new FileChooser();
        knappHentFil.setOnAction(velgFil ->  {

                configureFileChooser(fileChooser);
                File file = fileChooser.showOpenDialog(vindu);
                brett = new Brett();
                if (file != null) {
                    try{
                        brett.lesFil(file);
                        beholder = brett.hentBeholder();
                        antall.setText(" 0");
                    }catch(SudokuException e){}
                    beholder = brett.hentBeholder();
                    z = brett.hentFormat()[2];
                    new Thread(new GridUpdater(brett,grid,antall,beholder)).start();
                }});


        FocusButton knappLosBrett = new FocusButton("Løs brett");
        knappLosBrett.setStyle(btnStyle);
        knappLosBrett.setOnAction(losBrett -> {
                try{
                    brett.losBrett();
                    antall.setText(beholder.hentAntallLosninger()+"");
                }catch(SudokuException e){}

            });

        FocusButton knappVisLos = new FocusButton("Vis Løsning");
        knappVisLos.setStyle(btnStyle);
        knappVisLos.setOnAction(visLos -> {
                try{
                    skrivLosning();
                }catch(SudokuException e){}
            });

        FocusButton knappAvslutt = new FocusButton("Avslutt knapp");
        knappAvslutt.setStyle(btnStyle);
        knappAvslutt.setOnAction(avslutt -> javafx.application.Platform.exit());

        hbox.getChildren().addAll(knappHentFil,knappLosBrett,knappVisLos,knappAvslutt);
        return hbox;

    }


    private static void configureFileChooser ( FileChooser fileChooser){
        fileChooser.setTitle("Velg Sudoku brett");
        fileChooser.getExtensionFilters().addAll(
            new FileChooser.ExtensionFilter("TXT", "*.txt"));
    }

    private void skrivLosning()throws SudokuException{
        char[] los = beholder.taUt();
        if(los == null){
            throw new SudokuException("Ingen flere Losninger");
        }
        int teller = 0;
        for(int row = 0; row < z; row ++){
            for(int col = 0; col < z; col ++){
                StackPane cell = getNodeFromGridPane(col,row);
                TextField text = (TextField) cell.getChildren().get(0);
                text.setText(los[teller] + "");
                teller ++;
            }}
    }

    private StackPane getNodeFromGridPane(int col, int row) {
        for (Node node : grid.getChildren()) {
            if (grid.getColumnIndex(node) == col && grid.getRowIndex(node) == row) {
                if(node instanceof StackPane){
                    StackPane cell = (StackPane) node;
                    return cell;
                }
            }
        }
        System.out.println("FUUUCCKKK");
        return null;
    }


}
