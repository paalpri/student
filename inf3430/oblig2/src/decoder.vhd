library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
	port
	(
	  SW	: in std_logic_vector(1 downto 0);
	  LD	: out std_logic_vector(3 downto 0)
	);
end decoder;


architecture beh of decoder is

begin

	squirtle:
	process (SW)
	begin
	
		C: case SW is	
			when "11" => LD <= "0111";
			when "10" => LD <= "1011";
			when "01" => LD <= "1101";
			when "00" => LD <= "1110";
			when others => LD <= "1111";
		end case C;
	end process squirtle;
end beh;