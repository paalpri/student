library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of teller is
signal mclk_cnt : unsigned (24 downto 0);
begin

P_clkdiv: process (rst,mclk)
begin
	if(rst = '1' then
		mclk_cnt <= (others => '0');
	elsif rising_edge(mclk) then
		mclk_cnt <= mclk_cnt +1;
		end if;
	end process P_clkdiv;
	mclk_div <= std_logic(mclk_cnt(24));
	
end rtl;	
