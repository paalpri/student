library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;   

entity counter is 
  port
  (
  
    CLK        : in  std_logic; 
    RESET      : in  std_logic; 
    COUNT      : out std_logic_vector(1 downto 0)
  );
end counter;

architecture beh of counter is

    signal COUNT_I : unsigned(1 downto 0);
	
begin

	
	
  COUNTER: 
  process (RESET,CLK)              
  begin
    if(RESET  = '1') then
      COUNT_I <= "00";
    elsif rising_edge(CLK) then 
            COUNT_I <= COUNT_I + 1;
    end if; 
  end process COUNTER;
  COUNT <= std_logic_vector(COUNT_I);
end beh;
