/*
public GridUpdater (Brett brett, GridPane grid, Text antall ) {
        this.brett = brett;
        this.grid = grid;
        this.antall = antall;
        int[] format = brett.hentFormat();
        x = format[0];
        y = format[1];
        z = format[2];
        grid.getChildren().clear();
        //grid.setPadding(new Insets(0, 10, 0, 10));
        grid.getStyleClass().add("game-grid");

        for(int i = 0; i < z; i++) {
            ColumnConstraints column = new ColumnConstraints(40);
            grid.getColumnConstraints().add(column);
        }

        for(int i = 0; i < z; i++) {
            RowConstraints row = new RowConstraints(40);
            grid.getRowConstraints().add(row);
        }
        int xx = 0;;
        for (int i = 0; i < z; i++) {
            for (int j = 0; j < z; j++) {
                Pane pane = new Pane();
                pane.getStyleClass().add("game-grid-cell");
                if (i == 0) {
                    pane.getStyleClass().add("first-column");
                }
                if (j == 0) {
                    pane.getStyleClass().add("first-row");
                }
                grid.add(pane, i, j);
                if( j == 1){
                    pane.getStyleClass().add("grey");
                    
                }
            }
        }
        

        
}
*/
