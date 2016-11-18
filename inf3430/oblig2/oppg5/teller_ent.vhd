library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity teller is
	port(
			rst	 	: in std_logic;
			mclk 	: in std_logic;
			go		: in boolean;
			mclk_div: out std_logic
		);
end teller;