library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of work.slowclock is

	signal clk : std_logic := '0';
	
begin

		CK: process (mclk)
		variable count : integer range 1 to 62500 := 1;
		
		begin
		
		if(rising_edge(mclk)) then
			if(count = 62500) then
			count := 1;
			clk <= not clk;
			else
			count := count + 1;
			end if;
		end if;
		
	SCLK	<= clk;
end process CK;
end rtl;	