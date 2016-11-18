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
import javafx.scene.paint.Color;
import javafx.css.PseudoClass;

class GridUpdater implements Runnable {
    private Brett brett;
    private GridPane grid;
    private Text antall;
    private int x;
    private int y;
    private int z;
    private Sudokubeholder beholder;
    private Rute[] ruter;

    public GridUpdater (Brett brett, GridPane grid, Text antall,Sudokubeholder beholder ) {

        this.brett = brett;
        this.grid = grid;
        this.antall = antall;
        int[] format = brett.hentFormat();
        x = format[0];
        y = format[1];
        z = format[2];
        grid.getChildren().clear();
        this.beholder = beholder;
        ruter = brett.hentRuter();
        grid.setAlignment(Pos.CENTER);


        PseudoClass right = PseudoClass.getPseudoClass("right");
        PseudoClass bottom = PseudoClass.getPseudoClass("bottom");

        int teller = 0;
        for (int row = 0; row < z; row++) {
            for (int col = 0; col < z; col++) {
                StackPane cell = new StackPane();
                cell.getStyleClass().add("cell");
                if(col+1 != z){
                    cell.pseudoClassStateChanged(right, ((col+1) % x) == 0);
                }
                if(row+1 != z){
                    cell.pseudoClassStateChanged(bottom, ((row+1) % y) == 0);
                }

                cell.getChildren().add(createTextField(ruter[teller].hentVerdi()));

                grid.add(cell, col, row);
                teller ++;
            }
        }


    }

    @Override
    public void run () {
        new Thread(new AntallUpdater(beholder,antall)).start();
    }


    private TextField createTextField(int i) {
        TextField textField = new TextField();
        if(i != 0){
            textField.setText(i+"");
        }
        // restrict input to integers:
        if(z <= 9){
            textField.setTextFormatter(new TextFormatter<Integer>(c -> {
                        if (c.getControlNewText().matches("\\d?")) {
                            return c ;
                        } else {
                            return null ;
                        }
            }));
        }else{
            textField.setTextFormatter(new TextFormatter<String>(c -> {
                        c.setText(c.getText().replaceAll("[^a-zA-Z0-9]", ""));
                        return c;

            }));


        }
        return textField ;
    }

}
