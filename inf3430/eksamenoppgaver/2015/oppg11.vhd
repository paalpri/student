library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity gcd is
  port
    (
      clk : in std_logic;
      rst : in std_logic;
      start : in std_logic;
      ready : out std_logic;
      a_in : in std_logic_vector(7 downto 0);
      b_in : in std_logic_vector(7 downto 0);
      result : out std_logic_vector(7 downto 0)
      );
end entity gcd;

architecture rtl_gcd of gcd is

  signal a, next_a : unsigned(7 downto 0);
  signal b, next_b : unsigned(7 downto 0);
  signal n, next_n : unsigned(7 downto 0);

  type gcd_state is( idle, swap,sub,res);
  signal curr_st, next_st : gcd_state;

begin;


     process(rst,clk)
     begin
       if (rst = '1') then
         curr_st <= idle;
         a <= (others => '0');
         b <= (others => '0');
         n <= (others => '0');
       elsif(rising_edge(clk)) then
         curr_st <= next_st;
         a <= next_a;
         b <= next_b;
         n <= next_n;
       end if;
     end process;

     process(curr_st)
     begin
       case curr_st is
         when idle =>
           ready <= '1';
           if(start = '0') then
             next_st <= idle;
           else
             a_next <= a_in;
             b_next <= b_in;
             n_next <= ( others =>'0');
             next_st <= swap;
           end if;
         when swap =>
           if(a = b ) then
             if(n = 0) then
               next_st <= idle;
             else
               next_st <= res;
             end if;
           elsif (a(0) = 0) then
             next_st <= swap;
             next_a <= a >> 1;
             if(b(0) = 0) then
               next_b <= b >> 1;
               next_n <= n +1;
             end if;
           elsif(b(0) = 0) then
             next_b <= b >> 1;
             next_st <= swap;
           elsif(a < b) then
             a <= b;
             b <= a;
             next_st <= sub;
           else
             next_st <= sub;
           end if;

         when sub =>
           a_next <= a - b;
           next_st <= swap;

         when res =>
           a_next <= a << 1;
           n_next <= n - a;
           if(next_n = 0) then
             next_st <= idle;
           else
             next_st <= res;
           end if;
       end case
     end process;

     result <= std_logic_vector(a);
end architecture rtl_gcd;
