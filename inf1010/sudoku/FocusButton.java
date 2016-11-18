import javafx.scene.Node;
public class FocusButton extends javafx.scene.control.Button {

    public FocusButton ( ) {
        super ();
        bindFocusToDefault ( );
    }

    public FocusButton ( String text ) {
        super (text);
        bindFocusToDefault ( );
    }

    public FocusButton ( String text, Node graphic ) {
        super (text, graphic);
        bindFocusToDefault ( );
    }

    private void bindFocusToDefault ( ) {
        defaultButtonProperty().bind(focusedProperty());
    }

}
