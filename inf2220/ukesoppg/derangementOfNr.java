class derangementOfNr{

    public static void main(String[] args) {
        int[] numbers = {1,2,3,4,5};
        derange(numbers,0);
        //derange2(1);
    }
    static int[] tall = new int[4];


    static void derange(int[] num,int index){
        if(index == num.length-1){
            for(int i = 0; i < num.length; i ++){
                System.out.print(num[i]);
            }
            System.out.println();
        }else{
            for(int i = index; i < num.length; i ++){
                swap(num,index,i);
                if(num[index] != index+1){
                    derange(num,index+1);
                }
            }
        }

    }
    static void swap(int[] num, int a, int b){
        int mid = num[a];
        num[a] = num[b];
        num[b] = mid;
    }

    static void derange2(int n){
        if(n > tall.length){
            System.out.println();
        }else{
            for(int i = n; i <= tall.length; i ++){
                tall[i] = i;
                derange2(n+1);
            }
        }
    }




}
