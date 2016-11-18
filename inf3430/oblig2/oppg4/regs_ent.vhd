library IEEE;
use IEEE.std_logic_1164.all;

entity regs is 
  port
  (
		MCLK 	: in std_logic;
		MRESET	: in std_logic;
		SW		: in std_logic_vector(3 downto 0);
		SW_sel	: in std_logic_vector(1 downto 0);
		BTNL	: in std_logic;
		abcdefgdec_n : out std_logic_vector(7 downto 0);
		a_n		: out std_logic_vector(3 downto 0)
		);
end regs;