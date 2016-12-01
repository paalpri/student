library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of clkdiv is
	signal mclk_cnt : unsigned (6 downto 0);
begin

		P_CLKDIV: process(rst,mclk)
		begin
			if rst = '1' then
				mclk_cnt <= (others => '0');
			elsif rising_edge (mclk) then
				mclk_cnt <= mclk_cnt +1;
			end if;
		end process P_CLKDIV;
	mclk_div <= std_logic(mclk_cnt(6));
			
end rtl;			

			