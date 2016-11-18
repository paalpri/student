
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_oppg5 is 
  --empty
end tb_oppg5;
architecture testbench  of tb_oppg5 is
	component seg7model
	port
	  (
		a_n           : in  std_logic_vector(3 downto 0);
		abcdefgdec_n  : in  std_logic_vector(7 downto 0);
		disp3         : out std_logic_vector(3 downto 0);
		disp2         : out std_logic_vector(3 downto 0);
		disp1         : out std_logic_vector(3 downto 0);
		disp0         : out std_logic_vector(3 downto 0)
	  );
	  end component seg7model;
	  
	  component clock
	  port
		(
		MCLK 		: in std_logic;
		MRESET		: in std_logic;
		stop		: in std_logic;
		start		: in std_logic;
		abcdefgdec_n: out std_logic_vector(7 downto 0);
		a_n			: out std_logic_vector(3 downto 0)
		);
	end component clock;
		
		
		signal reset 		 : std_logic;
		signal clk			 : std_logic:='0';
		signal a_ni          : std_logic_vector(3 downto 0);
		signal abcdefgdec_ni : std_logic_vector(7 downto 0);
		signal disp3         : std_logic_vector(3 downto 0);
		signal disp2         : std_logic_vector(3 downto 0);
		signal disp1         : std_logic_vector(3 downto 0);
		signal disp0         : std_logic_vector(3 downto 0);
		signal stop			 : std_logic;
		signal start		 : std_logic;
		
		--signal dec		 : std_logic_vector(3 downto 0); til senere bruk
		
		
		constant half_period : time := 10 ns;
		
	begin

	UUT: seg7model
	port map
	(
		a_n          =>  a_ni,
	    abcdefgdec_n =>  abcdefgdec_ni,
	    disp3        =>  disp3,
        disp2        =>  disp2,
        disp1        =>  disp1,
        disp0        =>  disp0
	);
	
	UUT1: clock
	port map
	(
		abcdefgdec_n => abcdefgdec_ni,
		a_n 		 => a_ni,
		MCLK 		 => clk,
		MRESET 		 => reset,
		stop		 => stop,
		start		 => start		
	);

	clk <= not clk after half_period;
		
	
	
	STIMULI :
	process
	begin
	reset <= '1', '0' after 20 ns;
	stop <= '0';
	start <= '1';
	wait for 40 ns;
	start <= '0';
	wait;
	
	end process;

	
end testbench;