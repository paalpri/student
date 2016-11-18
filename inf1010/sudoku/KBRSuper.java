class KBSsuper{
    int id;
    Rute[] ruter;
    int teller = 0;

    public KBSsuper(int id, int x, int y){
        this.id = id;
        ruter = new Rute[x*y];
    }

    public int hentId(){
        return id;
    }

    public boolean inneholder(int i){
        for(Rute r: ruter){
            if(r.hentVerdi() == i){
                return true;
            }
        }
        return false;
        
    }

    public void settInn(Rute r){
        ruter[teller] = r;
        teller ++;
        
    }

    
}
