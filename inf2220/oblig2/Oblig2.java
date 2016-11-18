class Oblig2{


    public static void main(String[] args) {
        ProjectPlanner plan = new ProjectPlanner();
        if(args.length != 1){
            System.out.println("Skriv et argument !");
            System.exit(0);
        }
        try{
            plan.lesFil(args[0]);
        }catch(Exception e){
            e.printStackTrace();
        }
        /*
          if(!plan.realizable()){
          System.exit(0);
          }
        */
        plan.shortestWay();
    }
}
