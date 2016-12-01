library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic(counter_size : integer);
  port(clk    : in  std_logic;
       input  : in  std_logic;
       output : out std_logic
      );
end entity debouncer;

architecture rtl of debouncer is
  signal input_i1, input_i2, input_i3 : std_logic;                   
  signal counter : unsigned(counter_size downto 0) := (others => '0');
begin
  
    p_main: process(clk)
    begin
        if(rising_edge(clk)) then
        output <= '0';
        
        input_i1 <= input;
        input_i2 <= input_i1;
        input_i3 <= input_i2;
        
        if ((input_i3 = '0') and (input_i2 = '1')) then -- Rising edge
            if (counter = 0) then
                output  <= '1';
            counter <= (others => '1');
            end if;
        end if;
        
            if (counter /= 0) then
                counter <= counter - 1;
            end if;
        
        end if;
    end process p_main;
  
end architecture rtl;
