import java.lang.*;
import java.util.*;
import java.io.*;

class oblig3{

    static final int CHAR_MAX = 256;

    public static void main(String[] args) {
        if(args.length != 2){
            System.out.println("usage: <Filname> needle.txt haystack.txt  ");
            System.exit(0);
        }
        String haystack = "";
        String needle = "";
        try{
            haystack =lesFil(args[1]);
            needle = lesFil(args[0]);
        }catch( Exception e){
            System.out.println("Skriv inn file din bog");
        }

        if( needle.length() < 1 || haystack.length() < 1){
            System.out.println("Hey Sailor!, some of your stuff is empty!");
            System.exit(0);
        }
        System.out.println("Needle: " + needle);
        System.out.println("Haystack: " + haystack);

        if (needle.length() > haystack.length()){
            System.out.println("Needle bigger then haystack");
            System.exit(0);
        }

        int antall =  boyer_moore_horspool(needle,haystack);
        System.out.println(needle + " forekom " + antall + " ganger i haystacken");
    }

    static String lesFil(String filnavn)throws Exception{
        Scanner in = new Scanner(new File(filnavn));
        String tekst = "";
        while (in.hasNextLine()){
            tekst = tekst + in.nextLine();
        }
        in.close();
        return tekst;
    }

  
    
    /*
     * Metode som kutter ned og fjerner alle wildcards som ligger i slutten av nålen
     * disse matcher alltid så på denne måten får vi mindre å sammenligne og det går fortere
     * kutter også ned haystack offsetet senere til å matche lengden på hvor mye vi kuttet ned,
     * sånn at vi ikke mister noe i slutten av haystacken
     */
    static public char[] cutWildcards(char[] preNeedle,char[] haystack,String needleS){
        /*
         * Antar at små og store bokstaver er forskellige tegn og blir ikke samme
         */

        // counting the trailing wildcards, to cut them off later
        int indexCut;
        for(indexCut = preNeedle.length - 1; indexCut > 0; indexCut --){
            if(preNeedle[indexCut] != '_'){
                break;
            }
        }
        if(indexCut == 0 && preNeedle[0] == '_'){
            System.out.println("Needle inneholder bare wildcards, finnes i hele haystacken");
            System.exit(0);
        }
        // cutting the needle by its trailing wildcards
        return (needleS.substring(0, indexCut+1).toCharArray());
    }


    /*
     * Metode som finner arrayen med indexen til der i needelen vi ikke bare har wildcacrds,
     * på denne måten sjekker vi bare tegn som ikke er wildcards, siden wildcards matcher jo hver gang
     */
    static public int[] checkArr(char[] needle){

        ArrayList<Integer> tall = new ArrayList<>();
        //adding the indexes that are to be checked.
        for(int i = 0; i < needle.length; i ++){
            if(needle[i] != '_'){
                tall.add(i);
            }
        }
        //making a check array to only check the indexes that isent a wildcard
        int[] check = new int[tall.size()];
        for(int i = 0; i < check.length; i ++){
            check[i] = tall.get(i);
        }

        return check;
    }

    /*
     * Metode som finner bad_shift arrayen
     */
    static public int[] make_bad_shift(char[] needle,int last){
        //define my bad_shift array to 256 as said at the top
        int[] bad_shift = new int[CHAR_MAX];
        /*
         * visst vi har et wildcard som ikke er sist
         * så kan vi maks hoppe x antall ganger forx neste søk
         */
        int lastUnderline = new String(needle).lastIndexOf('_');
        int underlineOffset = needle.length;
        //this is to know when in the needle to start setting the bad_shift, sets only for those after a wildcard
        int startNeedle = 0;
        if(lastUnderline != -1){
            underlineOffset = last - lastUnderline;
            startNeedle = lastUnderline  + 1 ;
        }
        System.out.println("startneedle : " + startNeedle);
        System.out.println("Underline offset: " + underlineOffset);
        /* fills the entire bad_shift array with the last occurency of wildcard,
         * or the length of the needle if there is no wildcards
         */
        Arrays.fill(bad_shift,underlineOffset);
        for(int i = startNeedle; i < last; i++){
            bad_shift[needle[i]] = last - i; // original
        }
        return bad_shift;

    }

    static public int boyer_moore_horspool(String needleS, String haystackS){

        char[] preNeedle = needleS.trim().toCharArray();
        char[] haystack = haystackS.trim().toCharArray();
        char[] needle = cutWildcards(preNeedle,haystack,needleS);
        int[] check = checkArr(needle);
        int last = needle.length - 1;
        int[] bad_shift = make_bad_shift(needle,last);

        int offset = 0, scan = 0, antall = 0;
        //cutting the haystack by as much as i cut the needle
        int maxoffset = haystack.length - preNeedle.length;

        while(offset <= maxoffset){
            for(scan = check.length-1; needle[check[scan]] == haystack[check[scan]+offset]; scan --){
                if(scan == 0){ // match found!
                    String subNeedle = haystackS.substring(offset, offset + preNeedle.length);
                    System.out.println("Needle: " + subNeedle + ", found in haystack starting at index " + offset);
                    for(int i = 0; i < offset; i ++){
                        System.out.print(" ");
                    }
                    System.out.println(new String(preNeedle));
                    System.out.println(haystack);
                    System.out.println();

                    antall ++;
                    break;
                }
            }
            offset += bad_shift[haystack[offset + last]];
        }
        return antall;
    }
}
