import java.util.*;
import java.io.*;

class Brett{
    Rute[] ruter;
    Kolonne[] kolonner;
    Boks[] bokser;
    Rad[] rader;
    int x;
    int y;
    int z;
    int antallRuter;
    Sudokubeholder beholder = new Sudokubeholder();

    Brett(){
    }

    public Sudokubeholder hentBeholder(){
        return beholder;
    }
    public int[] hentFormat(){
        return new int[]{x,y,z};
    }
    public Rute[] hentRuter(){
        return ruter;
    }


    public void testMetode(){
        int[] tall = ruter[1].finnAlleMuligeTall();
        for(int i: tall){
            System.out.println(i);
        }

        try{
            skrivUtBeholder();
            skrivUtBeholder();
        }catch(SudokuException e){
            e.printStackTrace();
        }

    }

    public void losBrett()throws SudokuException{
        if(ruter == null){
            throw new SudokuException("Finner ingen brett å løse!");
        }

        for(int i = 0; i<ruter.length; i++){
            int[] mulige = ruter[i].finnAlleMuligeTall();
            if(mulige.length == 1){
                ruter[i].setVerdi(mulige[0]);
            }
        }

        ruter[0].fullUtDenneRuteOgResten(0);
    }


    public void settInnLosning(){
        // System.out.println("Voop");
        char[] a = new char[ruter.length];
        for(int i = 0; i < ruter.length; i ++){
            try{
                a[i] = verdiTilTegn(ruter[i].hentVerdi());
            }catch(SudokuException e){
                e.printStackTrace();
            }
        }
        beholder.settInn(a);
    }


    public void opprettDatastruktur(){
        bokser = new Boks[z];
        rader = new Rad[z];
        kolonner = new Kolonne[z];
        ruter[0].maks(z,this);


        for(int i =0; i < z ;i++){
            kolonner[i] = new Kolonne(i,x,y);
            bokser[i] = new Boks(i,x,y);
            rader[i] = new Rad(i,x,y);
        }

        int tB = 0;
        int tK = 0;
        int tR = 0;
        int tellerx = 0;
        int tellery = 0;
        for(int i = 0;i<ruter.length;i++){
            if(tK == z){
                tK = 0;
                tR++;
                tellery ++;
                tellerx = 0;
                if(tellery == y){
                    tellery = 0;
                    tB ++;
                }else{
                    tB = tB - ((z/x) -1);
                }
            }

            if(tellerx == x){
                tellerx = 0;
                tB ++;
            }

            ruter[i].datastruktur(rader[tR],kolonner[tK],bokser[tB]);
            rader[tR].settInn(ruter[i]);
            kolonner[tK].settInn(ruter[i]);
            bokser[tB].settInn(ruter[i]);
            tK ++;
            tellerx ++;
        }
    }

    public void skrivUt(){
        if(ruter == null){
            System.out.println("Du har ikke lest inn noe brett enda");
            return;
        }
        int tellerx = 0;
        int tellery = 0;
        int x = 0;
        int y = 0;
        for(int i = 0; i< ruter.length; i ++){
            if(tellerx == z){
                System.out.println();
                tellerx = 0;
                tellery ++;
                y ++;
                x = 0;
            }

            else if(x == this.x){
                System.out.print("|");
                x = 0;
            }
            if(y == this.y){
                int teller = 0;
                for(int n = 1; n <= z ;n++){
                    if(teller == this.x){
                        System.out.print("+");
                        teller = 0;
                    }
                    System.out.print("-");
                    teller ++;
                }
                System.out.println();
                y = 0;
            }
            try{
                System.out.print(verdiTilTegn(ruter[i].hentVerdi()));
            }catch(SudokuException e){
            }
            tellerx ++;
            x++;
        }
        System.out.println();
    }

    public void lesFil(File file)throws SudokuException{
        Scanner input;

        try{
            input = new Scanner(file);
        }catch(Exception e){
            throw new SudokuException("Finner ikke filen");
        }
        y = Integer.parseInt(input.nextLine());
        x = Integer.parseInt(input.nextLine());
        z = x*y;
        antallRuter = z * z;
        ruter = new Rute[antallRuter];
        if(z > 64){
            throw new SudokuException("Sudokuen er for stor, maks 64");
        }

        int j = 0;
        while(input.hasNextLine()){
            String linje = input.nextLine();

            if(linje.length() != z ){
                ruter = null;
                throw new SudokuException("linjen inneholder for mange eller for faa tall");
            }

            for(int i = 0; i<linje.length(); i++){
                char c = linje.charAt(i);
                int verdi = tegnTilVerdi(c);
                if(verdi == -1){
                    ruter = null;
                    throw new SudokuException("Ugyldig tegn");

                }
                else if(verdi > z){
                    ruter = null;
                    throw new SudokuException("Verdien er for stor til denne sudokuen! ");
                }
                Rute r = new Rute(verdi);
                ruter[j] = r;
                j++;

            }

        }

        for(int i = 0; i<ruter.length-1; i ++){
            ruter[i].setNeste(ruter[i+1]);
        }
        opprettDatastruktur();
    }



    public void skrivUtBeholder()throws SudokuException{
        char[] denne = beholder.taUt();
        if(denne == null){
            throw new SudokuException("Ingen flere losninger og skrive ut");
        }
        int tellerx = 0;
        int tellery = 0;
        int x = 0;
        int y = 0;
        for(int i = 0; i< denne.length; i ++){
            if(tellerx == z){
                System.out.println();
                tellerx = 0;
                tellery ++;
                y ++;
                x = 0;
            }

            else if(x == this.x){
                System.out.print("|");
                x = 0;
            }
            if(y == this.y){
                int teller = 0;
                for(int n = 1; n <= z ;n++){
                    if(teller == this.x){
                        System.out.print("+");
                        teller = 0;
                    }
                    System.out.print("-");
                    teller ++;
                }
                System.out.println();
                y = 0;
            }

            System.out.print(denne[i]);
            tellerx ++;
            x++;
        }
        System.out.println();
        System.out.println();
    }






    public static int tegnTilVerdi(char tegn) {
        if (tegn == '.') {                // tom rute, DENNE KONSTANTEN MAA DEKLARERES
            return 0;
        } else if ('1' <= tegn && tegn <= '9') {    // tegn er i [1, 9]
            return tegn - '0';
        } else if ('A' <= tegn && tegn <= 'Z') {    // tegn er i [A, Z]
            return tegn - 'A' + 10;
        } else if (tegn == '@') {                   // tegn er @
            return 36;
        } else if (tegn == '#') {                   // tegn er #
            return 37;
        } else if (tegn == '&') {                   // tegn er &
            return 38;
        } else if ('a' <= tegn && tegn <= 'z') {    // tegn er i [a, z]
            return tegn - 'a' + 39;
        } else {                                    // tegn er ugyldig
            return -1;
        }
    }

    public static char verdiTilTegn(int verdi)throws SudokuException {
        if (verdi == 0) {                           // tom
            return ' ';
        } else if (1 <= verdi && verdi <= 9) {      // tegn er i [1, 9]
            return (char) (verdi + '0');
        } else if (10 <= verdi && verdi <= 35) {    // tegn er i [A, Z]
            return (char) (verdi + 'A' - 10);
        } else if (verdi == 36) {                   // tegn er @
            return '@';
        } else if (verdi == 37) {                   // tegn er #
            return '#';
        } else if (verdi == 38) {                   // tegn er &
            return '&';
        } else if (39 <= verdi && verdi <= 64) {    // tegn er i [a, z]
            return (char) (verdi + 'a' - 39);
        } else {                                    // tegn er ugyldig
            throw new SudokuException("verdien: " + verdi +" er ikke gyldig");    // HUSK DEFINISJON AV UNNTAKSKLASSE
        }
    }

}
