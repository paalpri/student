library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rstsynch is
	port (
		arst	: in std_logic;
		mclk	: in std_logic;
		mclk_div : in std_logic;
		rst		: out std_logic;
		rst_div	: out std_logic
	);
	
end rstsynch;