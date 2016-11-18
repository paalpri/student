import java.io.*;
class Sudoku{

    static int vannrett;
    static int lodrett;


    public static void main(String[] args) {
        Brett brett = new Brett();

        try{
            brett.lesFil(new File("brett2x3x59.txt"));
            brett.skrivUt();
            brett.losBrett();
        }catch(Exception e){
            e.printStackTrace();
        }
        brett.skrivUt();
        brett.testMetode();


    }




}
