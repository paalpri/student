library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity slowclock is
	port
	(
		mclk : in std_logic;
		SCLK : out std_logic
	);
end slowclock;