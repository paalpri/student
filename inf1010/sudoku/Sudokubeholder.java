import java.util.*;
import java.io.*;
class Sudokubeholder{

    private int antallLosninger = 0;
    private Node foran;
    private Node bak;

    private class Node{
        Node neste;
        char[] data;

        Node(char[] data){
            this.data = data;
            antallLosninger ++;
            
           
        }
    }


    synchronized public void settInn(char[] data){
        if(antallLosninger >3500){
            antallLosninger ++;
            return;
        }
        Node nyNode = new Node(data);
        if( foran == null){
            foran = nyNode;
            bak = nyNode;
        }
        else{
            bak.neste = nyNode;
            bak = nyNode;
        }
        notifyAll();


    }
   

    public char[] taUt(){
        if(foran == null){
            return null;
        }
        Node tmp = foran;
        foran = foran.neste;
        return tmp.data;

    }

    public int hentAntallLosninger(){
        return antallLosninger;

    }


}
