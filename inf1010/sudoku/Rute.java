import java.util.ArrayList;
class Rute{
    int verdi = 0;
    Boks boks;
    Kolonne kolonne;
    Rad rad;
    static int max;
    static Brett brett;
    Rute neste = null;
    boolean fast = false;

    Rute(int v){
        this.verdi = v;
        if (v != 0){
            fast = true;
        }
    }

    public void setNeste(Rute r){
        neste = r;
    }

    public void datastruktur(Rad r,Kolonne k, Boks b){
        this.rad = r;
        this.kolonne = k;
        this.boks = b;
    }
    public void maks(int maks,Brett b){
        this.max = maks;
        this.brett = b;

    }
    public int hentVerdi(){
        return verdi;
    }

    public void fullUtDenneRuteOgResten(int depth){
        if(fast && neste != null){
            neste.fullUtDenneRuteOgResten(depth+1);
            return;
        }if(fast && neste == null){
            brett.settInnLosning();
            return;
        }

        int[] mulige = finnAlleMuligeTall();
        for(int i = 0; i < mulige.length; i ++){
            verdi = mulige[i];
            if(neste == null){
                brett.settInnLosning();
            }else{
                neste.fullUtDenneRuteOgResten(depth+1);
            }
        }
        if(!fast){
            verdi = 0;
        }

    }


    public int[] finnAlleMuligeTall(){
        if(fast){
            return new int[]{verdi};
        }

        ArrayList<Integer> mulige = new ArrayList<>();
        for(int i = 1; i<= max; i++){
            if(!kolonne.inneholder(i) && !boks.inneholder(i) && !rad.inneholder(i)){
                mulige.add(i);
            }
        }

        int[] ferdig = new int[mulige.size()];
        for(int i = 0; i < mulige.size(); i ++){
            ferdig[i] = mulige.get(i);
        }
        return ferdig;
    }

    public String hentStringVerdi(){
        if(verdi == 0){
            return " ";
        }
        return verdi + "";
    }
    public void setVerdi(int i){
        this.verdi = i;
        fast = true;
    }

    public void testMetode(){
        System.out.println("Denne ruten har verdi: " + verdi + ", Kolonne: "+kolonne.hentId() + ", Rad: " + rad.hentId()+ ", Boks: " + boks.hentId());
    }
}
