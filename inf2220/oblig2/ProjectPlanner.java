import java.util.*;
import java.io.*;
import java.lang.Math;

class ProjectPlanner{

    Task[] tasks;
    LinkedList<Task> lokke;
    LinkedList<Task> finished = new LinkedList<>();
    int FinishTime = 0;
    int tid;



    void lokkeLet(Task f)throws cycleFoundException{
        if(f.merke){
            // løkke funnet, lagrer veien i rett rekkefølge i cycle.
            Task denne = f.parent;
            f.parent = null;
            LinkedList<Task> cycle = new LinkedList<>();
            cycle.addFirst(f);
            while(denne.parent != null){
                cycle.addFirst(denne);
                denne = denne.parent;
            }
            lokke = cycle;
            throw new cycleFoundException();
        }else{
            f.merke = true;
            for(Task t: f.naboer){
                t.parent = f;
                lokkeLet(t);
            }
        }
        f.merke = false;
        //lagrer ferdig som true, sånn ta vi ikke kjører den rekrusive metoden i alle metodene igjen
        f.ferdig = true;
    }

    boolean realizable(){
        for(int i = 1; i < tasks.length; i ++){
            //starter bare lokkeLet i de metodene vi ikke har vert gjennom tidligere.
            if(!tasks[i].ferdig){
                try{
                    lokkeLet(tasks[i]);
                }catch(cycleFoundException e){
                    List<Task> cycle = lokke;
                    System.out.println("Prosjektet er ikke gjenomførbart, fant en løkke");
                    System.out.print("Løkken er " );
                    for(int j = 0; j < cycle.size(); j ++ ){
                        System.out.print("id " + cycle.get(j).id + ":  " + cycle.get(j).name + " --> ");

                    }
                    System.out.println();
                    return false;
                }
            }
        }
        System.out.println("Ingen lokke funnet");
        return true;
    }



    public void  shortestWay(){
        LinkedList<Task> q = new LinkedList<>();
        int nr = 0;
        int teller = 0;
        int curStaff = 0;
        int antall = 0;
        System.out.println("Time:  " + teller);
        for(int i = 1; i < tasks.length; i++){
            if(tasks[i].cntPredecessors == 0){
                tasks[i].earliestStart = teller;
                q.addLast(tasks[i]);
                curStaff += tasks[i].staff;
                System.out.println("\t Starting: " + tasks[i].id);
            }
        }
        System.out.println("\t Current staff: " + curStaff + "\n");

        boolean forrigeLik = false;
        boolean nesteLik = false;
        Task current = null;
        Task forrige = null;

        while(!q.isEmpty()){
            antall ++;
            forrige = current;
            current = q.getFirst();
            forrigeLik = false;
            nesteLik = false;

            for(int i = 1; i < q.size(); i ++){
                int forskjell = ((q.get(i).time + q.get(i).earliestStart) - (current.time + current.earliestStart));
                if( forskjell < 0 ){
                    current = q.get(i);
                    nesteLik = false;
                }
                if( forskjell == 0){
                    nesteLik = true;
                }
            }
            teller = current.time + current.earliestStart;
            q.remove(current);
            if(!(forrige != null && current.time + current.earliestStart == forrige.time + forrige.earliestStart)){
                System.out.println("Time: " + teller);
            }

            System.out.println("\t Finished: " + current.id);
            curStaff -= current.staff;
            finished.addLast(current);

            for(Task adj: current.naboer){
                adj.earliestStart = Math.max(adj.earliestStart, current.time + current.earliestStart);
                adj.cntPredecessors --;
                if(adj.cntPredecessors == 0){
                    System.out.println("\t Starting: " + adj.id);
                    q.addLast(adj);
                    curStaff += adj.staff;
                }
            }
            if(!nesteLik){
                System.out.println("\t Current staff: " + curStaff);
                System.out.println();
            }
        }
        FinishTime = teller;
        //kan bruke dette for å finne løkke
        if( antall != tasks.length -1){
            realizable();
        }else{
            finnSlack();
            printAll();
        }


    }

    public void slack(Task current){
        if(current.naboer.isEmpty()){
            current.latestStart = (FinishTime - current.time);
            current.slack = (current.latestStart - current.earliestStart);
        }
        if(current.inEdges != null){
            for(Task adj: current.inEdges){
                if(adj.latestStart == -1){
                    adj.latestStart = (current.latestStart - adj.time);
                }else{
                    adj.latestStart = Math.min((current.latestStart - adj.time),adj.latestStart);
                }
                adj.slack = adj.latestStart - adj.earliestStart;
                slack(adj);
            }
        }
    }

    public void finnSlack(){
        for(int i = finished.size()-1; i >= 0; i --){
            if(finished.get(i).naboer.isEmpty()){
                slack(finished.get(i));
            }
        }
    }

    void lesFil(String filnavn) throws Exception{
        File fil;
        Scanner in;
        try{
            fil = new File(filnavn);
            in = new Scanner(fil);
        }catch(Exception e){
            throw new Exception("Finner ikke filen");
        }
        int antall = Integer.parseInt(in.nextLine());
        if(antall < 1){
            System.out.println("Det er ingen oppgaver her..");
            System.exit(0);
        }
        String tomLinje = in.nextLine();
        tasks = new Task[antall+1];
        for(int i = 1; i <= antall; i ++){
            tasks[i] = new Task();
        }
        for(int i = 1; i <= antall; i ++){
            String[] linje = in.nextLine().split("\\s+");
            //lager en liste med alle naboene til den tasken vi holder paa og lese inn
            List<Task> naboTasks = new LinkedList<>();
            for(int j = 4; j < linje.length-1; j++){
                //sender inn naboene, hvem jeg peker på
                Task denne = tasks[Integer.parseInt(linje[j])];
                denne.naboer.add(tasks[i]);
                //sender inn hvem som peker på meg
                naboTasks.add(tasks[Integer.parseInt(linje[j])]);
            }
            //initialiserer klassen task med alle verdiene vi har lest inn.
            tasks[i].init(Integer.parseInt(linje[0]),linje[1],Integer.parseInt(linje[2]),Integer.parseInt(linje[3]),naboTasks);

        }

    }

    void printAll(){
        for(int i = 1; i < tasks.length; i++){
            tasks[i].print();
            System.out.println();
        }
    }


    private class Task{
        boolean merke = false;
        boolean ferdig = false;
        Task parent;

        int id , time , staff , slack  ;
        String name ;
        int earliestStart = 0 , latestStart ;
        List<Task> inEdges;
        List<Task> naboer = new LinkedList<>();
        int cntPredecessors;


        public void init(int id,String name, int time,int staff,List<Task> n){
            this.id = id;
            this.time = time;
            this.staff = staff;
            this.name = name;
            inEdges = n;
            cntPredecessors = n.size();
            merke = false;
            latestStart = -1;
        }

        public void print(){
            System.out.println("Id: " + id);
            System.out.println("Name: " + name);
            System.out.println("Time: " + time);
            System.out.println("Staff: " + staff);
            System.out.println("Earliest start: "+ earliestStart);
            System.out.println("Latest start: " + latestStart);
            System.out.println("Earliest finish: "+ (earliestStart + time));
            System.out.println("Latest finish: " + (latestStart + time));
            System.out.println("Slack: " + slack);
            System.out.print("Iden til outEdges: (de som peker på meg): ");
            for(Task t: inEdges){
                System.out.print(t.id + " ");
            }
            System.out.println();
            System.out.print("iden til naboene: (de jeg peker på): ");
            for(Task t: naboer){
                System.out.print(t.id + " ");
            }
            System.out.println();
        }
    }
}
