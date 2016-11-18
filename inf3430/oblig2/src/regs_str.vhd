
library IEEE;
use IEEE.std_logic_1164.all;

architecture str of regs is

	component regctrl
	port(
		--DEC		: out std_logic_vector(3 downto 0); til senere bruk
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
	end component regctrl;
	
	component seg7ctrl
	port
	(
	 mclk : in std_logic; --50MHz, positive flank
	 reset : in std_logic; --Asynchronous reset, active high
	 d0 : in std_logic_vector(3 downto 0);
	 d1 : in std_logic_vector(3 downto 0);
	 d2 : in std_logic_vector(3 downto 0);
	 d3 : in std_logic_vector(3 downto 0);
	 dec : in std_logic_vector(3 downto 0);
	 abcdefgdec_n : out std_logic_vector(7 downto 0);
	 a_n : out std_logic_vector(3 downto 0)
	);
	end component seg7ctrl;
	
	
	signal di0 : std_logic_vector(3 downto 0);
	signal di1 : std_logic_vector(3 downto 0);
	signal di2 : std_logic_vector(3 downto 0);
	signal di3 : std_logic_vector(3 downto 0);
	
	
	begin
	reg_regctrl: regctrl
	port map(
		CLK    => MCLK,
		RESET  => MRESET,
		SW     => SW,
		SW_sel => SW_sel,
		BTNL   => BTNL,
		D_OUT0 => di0,
		D_OUT1 => di1,
		D_OUT2 => di2,
	    D_OUT3 => di3
	);
	
	reg_seg7ctrl: seg7ctrl
	port map(
		mclk  		 => MCLK,
		reset        => MRESET,
		abcdefgdec_n => abcdefgdec_n,
		a_n 		 => a_n,
		dec			 => "0000",
		d0			 => di0,
		d1			 => di1,
		d2			 => di2,
		d3			 => di3
	);
	
	
	
	
	
end architecture str;
	
	
	
	
	