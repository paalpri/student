import java.util.ArrayList;

class Monitor{
    int antTraader;
    ArrayList<String[]> ordlister = new ArrayList<String[]>();

    Monitor(int antTraader){
        this.antTraader = antTraader;

    }


    synchronized String[] ferdigTraad (String[] nyArray){
        if (!ordlister.isEmpty()) {
            String[] tmp = ordlister.get(0);
            ordlister.remove(0);
            return tmp;
        }
        ordlister.add(nyArray);
        antTraader--;
        notify();
        return null;
    }

    synchronized String[] ventTilFerdig(){
        while(antTraader > 0){
            try {
                wait();
            } catch (Exception e) {

            }
        }
        
        return ordlister.get(0);
    }







}
