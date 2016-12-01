
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_p_ctrl is 
  --empty
end tb_p_ctrl;
architecture testbench  of tb_p_ctrl is
	component rtl_p_ctrl
	port (
    -- System Clock and Reset
		rst       : in  std_logic;           -- Reset
		clk       : in  std_logic;           -- Clock
		sp        : in  signed(7 downto 0);  -- Set Point
		pos       : in  signed(7 downto 0);  -- Measured position
		motor_cw  : out std_logic;           --Motor Clock Wise direction
		motor_ccw : out std_logic            --Motor Counter Clock Wise direction
    ); 
	  end component rtl_p_ctrl;
	  
	  component clock
	 
	 
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