import java.util.*;
import java.io.*;

class Ordbok{
    Node root;
    Scanner in = new Scanner(System.in);

    public void Ordbok(){
        root = null;
    }

    public String finnOrd(String ord){
        String w = ord.toLowerCase();
        return search(w,root);
    }

    public void slettOrd(String ord){
        String w = ord.toLowerCase();
        root = delete(w,root);
    }
    public void settInn(String ord){
        String w = ord.toLowerCase();
        insert(w,root);
    }

    public void liknendeOrd(String ord){
        ArrayList<String> similar = new ArrayList<String>();
        similar.addAll(Arrays.asList(similarOne(ord)));
        similar.addAll(similarTwo(ord.toCharArray()));
        for(String s: similar){
            String nyttOrd = search(s,root);
            if(nyttOrd != null){
                System.out.print(nyttOrd + ", ");
            }
        }
        System.out.println();
    }

    public String[] similarOne(String word){
        char[] word_array = word.toCharArray();
        char[] tmp;
        String[] words = new String[(word_array.length-1) + (word.length())];
        int i = 0;
        while( i < word_array.length -1){
            tmp = word_array.clone();
            words[i*2] = swap(i, i+1, tmp);
            words[(i*2)+1] = slett(i,word);
            i++;
        }
        words[words.length-1] = slett(i,word);
        return words;
    }
    public String swap(int a, int b, char[] word){
        char tmp = word[a];
        word[a] = word[b];
        word[b] = tmp;
        return new String(word);
    }
    public String slett(int a, String word){
        StringBuilder build = new StringBuilder(word);
        build.deleteCharAt(a);
        return build.toString();
    }

    public ArrayList<String> similarTwo(char[] word){
        char[] alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
        ArrayList<String> newWords = new ArrayList<String>();
        for(int i = 0; i < word.length; i++){
            for(int j = 0; j < alphabet.length; j++){
                char[] tmp = word.clone();
                tmp[i] = alphabet[j];
                newWords.add(new String(tmp));
                StringBuilder build = new StringBuilder(new String(word));
                build.insert(i,alphabet[j]);
                newWords.add(build.toString());
            }
        }
        return newWords;
    }

    public void hentStatistikk(){
        root.totDepth(-1);
        System.out.println("First word: " + hentMinst(root));
        System.out.println("Last word: " + hentStorst(root));
        System.out.println("tot depth of tree: " + maxDepth);
        ant = new int[maxDepth+1];
        root.nodesInEachDepth();
        System.out.println("Nodes in each depth of the tree: ");
        for(int i = 0; i < ant.length; i ++){
            System.out.println("Depth " + i + ": " + ant[i] + " nodes");
        }
        System.out.println("Average depth: " + averageDepth());

    }
    public double averageDepth(){
        double antall = 0;
        double sum = 0;
        for(int i = 0; i < ant.length; i ++){
            antall += ant[i];
            sum += ant[i] * i;
        }
        return sum / antall;
    }
    public void lesFil()throws Exception{
        System.out.println("hva heterr filen til ordboken?");
        String filnavn = in.nextLine();
        File fil;
        try{
            fil = new File(filnavn);
            in = new Scanner(fil);
        }catch(Exception e){
            throw new Exception("Finner ikke filen");
        }

        while(in.hasNextLine()){
            root = insert(in.nextLine(),root);
        }
    }
    //brukt inspirasjon fra boka, har en alternativ metode som er laget helt selv i bunn, men synes disse var mye bedre så har valgt å bruke de.
    public Node insert(String w, Node parent){
        if(parent == null){
            return new Node(w);
        }
        int comp = w.compareTo(parent.data);
        if(comp < 0){
            parent.left = insert(w, parent.left);
        }
        else if(comp > 0){
            parent.right = insert(w,parent.right);
        }
        return parent;
    }
    // også brukt inspirasjon fra boka, likner veldig på insert metoden.
    public Node delete(String w, Node parent){
        if( parent == null){
            return parent; // finner ikke noden
        }

        int comp = w.compareTo(parent.data);
        if(comp < 0){
            parent.left = delete(w,parent.left);
        }
        else if( comp > 0){
            parent.right = delete(w,parent.right);
        }
        else if( parent.left != null && parent.right != null){ // 2 barn
            parent.data = hentMinst(parent.right).data; //henter det minste noden i hoyre subtree
            parent.right = delete(parent.data,parent.right);
        }
        else{
            parent = ( parent.left != null ) ? parent.left: parent.right;
        }
        return parent;
    }


    public Node hentMinst(Node parent){
        if(parent == null){
            return null;
        }
        else if(parent.left != null){
            return hentMinst(parent.left);
        }
        return parent;
    }
    public Node hentStorst(Node parent){
        if(parent == null){
            return null;
        }
        else if(parent.right != null){
            return hentStorst(parent.right);
        }
        return parent;
    }


    private String search(String w,Node parent){
        if(parent == null){
            return null;
        }
        int comp = w.compareTo(parent.data);
        if( comp > 0 ){
            return search(w,parent.right);
        }else if( comp < 0 ){
            return search(w,parent.left);
        }
        return parent.data;
    }



    int maxDepth = -1;
    int[] ant;
    private class Node{
        String data;
        Node left;
        Node right;
        int depth;
        Node parent;
        Node(String ord){
            depth = 0;
            data = ord;
        }

        public String toString(){
            return data;
        }


        public void totDepth(int currDepth){
            depth = 0; //her kan de bli feil vetsje! //til debugging
            depth += currDepth +1;
            if(right == null && left == null){
                if(depth > maxDepth){
                    maxDepth = depth;
                }
            }
            if(left != null){ left.totDepth(depth);}
            if(right != null){ right.totDepth(depth);}
        }

        public void nodesInEachDepth(){
            ant[depth] ++;
            if(left != null){ left.nodesInEachDepth();}
            if(right != null){ right.nodesInEachDepth();}
        }


        //Alternativ metode for å sette inn, denne metoden skal være inni node klassen
        /*
          void settInn(Node nyNode){
          if( nyNode == null || nyNode.data == null){
          System.out.println("Du maa ha innhold i noden, ingen NULL");
          }
          else if( nyNode.data.compareTo(data) >= 0){
          if(right != null){
          right.settInn(nyNode);
          }else{
          right = nyNode;
          nyNode.parent = this;
          }
          }else{
          if(left != null){
          left.settInn(nyNode);
          nyNode.parent = this;
          }else{
          left = nyNode;
          }
          }
          }
        */

    }//node avsluttes




}
