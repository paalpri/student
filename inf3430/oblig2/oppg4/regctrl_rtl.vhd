library IEEE;
use IEEE.std_logic_1164.all;
use work.seg7_pkg.all;

architecture rtl of regctrl is

begin
	REG_CTRL :
	process(CLK,RESET,BTNL)
	begin
	
		if(RESET) = '1' then
			D_OUT0 <= "0000";
			D_OUT1 <= "0000";
			D_OUT2 <= "0000";
			D_OUT3 <= "0000";
			
		elsif rising_edge(CLK) then
			if BTNL = '1' then 		
			 C: case SW_sel(1 downto 0) is
				    when "00" => D_OUT0 <= SW(3 downto 0);
				    when "01" => D_OUT1 <= SW(3 downto 0);
				    when "10" => D_OUT2 <= SW(3 downto 0);
				    when "11" => D_OUT3 <= SW(3 downto 0);
			        when others => null;
		      end case C;
			end if;
		end if;
	end process REG_CTRL;
end architecture rtl;
		