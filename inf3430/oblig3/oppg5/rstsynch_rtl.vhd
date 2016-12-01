library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of rstsynch is

	signal rst_s1, rst-s2: std_logic;
	signal rst_div_s1,rst_div_s2 : std_logic;
	
	begin
	P_RST_0 : process( arst,mclk)
	begin
		if arst = '1' then
			rst_s1 <= '1';
			rst_s2 <= '1';
		elsif rising_edge (mclk) then
			rst_s1 <= '0';
			rst_s2 <= rst_s1;
		end if;
	end process P_RST_0;


		P_RST_1 : process(arst,mclk_div)		
		begin
			if arst = '1' then
				rst_div_s1 <= '1';
				rst_div_s2 <= '1';
			elsif rising_edge(mclk_div)	then
				rst_div_s1 <= '0';
				rst_div_s2 <= rst_div_s1;
			end if;	
		end process P_RST_1;
		
	rst <= rst_s2;
	rst_div <= rst_div_s2;
		
end rtl;	
		