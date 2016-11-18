#include <stdio.h>
#include <limits.h>

void print_binary(int num)
{
    int pos = (sizeof(int) * 8) - 1;
    printf("%10d: ", num);

    for (int i = 0; i < (int)(sizeof(int) * 8); i++) {
        char c = num & (1 << pos) ? '1' : '0';
        putchar(c);
        if (!((i + 1) % 8))
            putchar(' ');
        pos--;
    }
    putchar('\n');
}

int main(void)
{
    print_binary(42);
    print_binary(3);
    print_binary(42 & 3);
    


    printf("Min egen test:\n");
    print_binary(239);
    print_binary(42);
    print_binary(42 + 16);
    if(16+1 == 17){
        printf("JAAADDDAA\n");
    }
   

    printf("\nMasking\n");
    print_binary(0xf0);
    print_binary(159712547);
    print_binary(159712547 & 0xf0);

    printf("\n");
    print_binary(0xff00);
    print_binary(159712547);
    print_binary((159712547 & 0xff00) >> 8);

    printf("\n");
    print_binary(0x10);
    print_binary(159712547);
    print_binary(159712547 & 0x10);
    int a = 159712547 | 0x10;
    printf("\n");
    print_binary(a);
    print_binary(0x10);
    print_binary(a & 0x10);

    printf("\nShifting\n");
    print_binary(42);
    print_binary(42 << 1);
    print_binary(100 >> 1);

    printf("\nSet bit\n");
    print_binary(42);
    print_binary(1 << 8);
    print_binary(42 | (1 << 8));

    printf("\nBit flipping\n");
    print_binary(42);
    print_binary((~42) + 1);

    printf("\n");
    print_binary(-1);
    print_binary(INT_MAX);
    print_binary(INT_MIN);
    





        
    printf("\n");
    print_binary(0);
    print_binary(-1);
    print_binary(-2);
    print_binary(-3);
    print_binary(-4);
    print_binary(-5);

    printf("\nClear bits\n");
    print_binary(-1);
    int mask = 1 << 8;
    print_binary(mask);
    print_binary(~mask);
    print_binary(~mask & -5);

    return 0;
}
