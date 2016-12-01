library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clkdiv is
	port (
		rst		: in std_logic;
		mclk		: in std_logic;
		mclk_div		: out std_logic;
	)
end clkdiv;