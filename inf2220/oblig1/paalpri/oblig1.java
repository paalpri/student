import java.util.*;
import java.io.*;

class oblig1{



    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        Ordbok ordbok = new Ordbok();
        System.out.println("Velkommen til ordboken min!");
        try{
            ordbok.lesFil();
        }catch(Exception e){
            e.printStackTrace();
        }
        System.out.println("Are you readyy!!???");
        String svar = in.nextLine();
        String sokeord;
        if(!svar.toLowerCase().equals("yes")){
            System.out.println("Who cares! lets start anyway!");
        }

        System.out.println("Naa skal vi sette inn ordet busybody");
        ordbok.settInn("busybody");
        System.out.println("Naa er ordet busybody satt inn!, bare se naar jeg soker paa det:");
        System.out.print("Sok ord busybody: ");
        System.out.println(ordbok.finnOrd("busybody"));
        System.out.println(" TADA!!, la oss slette det, saa soker vi igjen");
        ordbok.slettOrd("busybody");
        System.out.print("Soker igjen: ");
        System.out.println(ordbok.finnOrd("busybody"));
        System.out.println("TADAAAA!!!!! (whatevs)");


        while(!svar.equals("q")){
            System.out.println("ordbok:");
            System.out.print("sok: ");
            svar = in.nextLine().toLowerCase();
            if(svar.equals("")){
                System.out.println("DUSTTT");
                System.out.println("");
                continue;
            }
            sokeord = ordbok.finnOrd(svar);
            if(svar.equals("q")){
                System.out.println("Takk for du brukte paals ordbok");
                System.out.println("For du gaar ta en titt paa disse totalt ubrukelige statistikkene!:");
                ordbok.hentStatistikk();
                System.out.println("Velkommen tilbake og husk, dont Pokemon Go and drive!");
            }

            else if(sokeord != null){
                System.out.println("Vi fant ordet ditt!");
                System.out.println("ord: " + sokeord);
            }else{
                System.out.println("Vi fant ikke ordet ditt :/");
                System.out.println("Kanskje du mente noen av disse ordene: ");
                ordbok.liknendeOrd(svar);
            }
            System.out.println("");
        }
    }
}
