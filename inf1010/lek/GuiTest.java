import javafx.application.Application; // Klassen alle JavaFX-applikasjoner utvider fra
import javafx.event.ActionEvent; // Se javafx.event.Event for andre typer events
import javafx.event.EventHandler; // Tilsvarer ActionListener i swing
import javafx.scene.image.*; // for bilder av forskjellige formater png, jpg ...
import javafx.scene.Scene; // Beholderen for alt innholdet
import javafx.scene.text.Text; // En tekstnode
import javafx.scene.layout.*; // for panes, HBox, VBox andre layoutnoder
import javafx.scene.control.*; // for Button, Checkbox, Hyperlink og andre grensesnittkontroller
import javafx.geometry.*; // plassering, orientering o.l.
import javafx.stage.*; // Hoeyeste nivaa av JavaFX-beholdere
import javafx.scene.paint.Color;  // Definerer fargekonstanter
import javafx.scene.text.Font; // For fonter
import javafx.scene.text.FontWeight;  // For fonttype normal, bold, italic osv.


public class GuiTest extends Application{


    @Override
    public void start(Stage vindu){

        BorderPane border = new BorderPane();

        HBox hbox = nyHBox();
        border.setTop(hbox);

        //  border.setLeft(vBoxMedTekst());

        //border.setCenter(minGridPane()); // GridPane

        //border.setRight(nyVBoxMedLenker()); // VBox

        //border.setBottom(bunnBoks()); // HBox

        Scene scene = new Scene(border, 1230, 800);
        vindu.setScene(scene);
        vindu.show();
        vindu.setTitle("Eksempel med interaksjon ved knappetrykk");
/*
  Button knapp = new Button("Knapp");
  knapp.setPrefSize(200,30);
  EventHandler<ActionEvent> eventTekst = new MinLytterKlasse();
  knapp.setOnAction(eventTekst);
*/

    }




    private HBox nyHBox() {

        HBox hbox = new HBox();
        hbox.setPadding(new Insets(15, 12, 15, 12));
        hbox.setSpacing(10);   // Avstand mellom nodene
        hbox.setStyle("-fx-background-color: #995555;");

        Button knapp1 = new Button("Forelest");
        knapp1.setPrefSize(100, 20);

        Button knapp2 = new Button("Gjenstaar");
        knapp2.setPrefSize(100, 20);

        Button knapp3 = new Button("Trixoppgaver");
        knapp3.setPrefSize(130, 20);

        Button knapp4 = new Button("EnKnappSomLytterEtterTrykk");
        knapp4.setPrefSize(220, 20);

        EventHandler<ActionEvent> minLytter = new KnappeLytter("EnKnappSomLytterEtterTrykk") ;
        knapp4.setOnAction(minLytter);

        hbox.getChildren().addAll(knapp1, knapp2, knapp3, knapp4);

        return hbox;
    }


    class KnappeLytter implements EventHandler<ActionEvent> {
        String knappeTekst = null;

        KnappeLytter (String s) {
            knappeTekst = s;
        }

        @Override
        public void handle(ActionEvent detJegVentaPaaHendte) {
            System.out.println("Det ble trykka pÃ¥ knappen med teksten Â«" + knappeTekst + "Â»");
        }
    }


    public class MinLytterKlasse implements EventHandler<ActionEvent>{

        @Override
        public void handle(ActionEvent a){
            System.out.println("Action event til skjer her");
        }
    }
}
