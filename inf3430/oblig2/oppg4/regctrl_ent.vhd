
library IEEE;
use IEEE.std_logic_1164.all;

entity regctrl is 
  port
  (
		--DEC		: out std_logic_vector(3 downto 0);
		CLK 	: in std_logic;
		RESET	: in std_logic;
		SW		: in std_logic_vector(3 downto 0);
		SW_sel	: in std_logic_vector(1 downto 0);
		BTNL	: in std_logic;
		D_OUT0	: out std_logic_vector(3 downto 0);
		D_OUT1	: out std_logic_vector(3 downto 0);
		D_OUT2	: out std_logic_vector(3 downto 0);
		D_OUT3	: out std_logic_vector(3 downto 0)
  );
end regctrl;