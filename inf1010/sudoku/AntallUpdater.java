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


class AntallUpdater implements Runnable{

    Sudokubeholder beholder;
    Text antall;
    
    
    AntallUpdater(Sudokubeholder beholder, Text antall){
        this.beholder = beholder;
        this.antall = antall;
    }

    
    @Override
    public void run(){
        updateAntall();

    }

    synchronized private void updateAntall(){
        while(true){
            try{
                wait();
            }catch(Exception e){}
            antall.setText(beholder.hentAntallLosninger()+"");
        }

    }

}
