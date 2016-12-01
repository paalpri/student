
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_p_ctrl is 
  --empty
end tb_p_ctrl;
architecture testbench  of tb_p_ctrl is
	component p_ctrl
	port (
    -- System Clock and Reset
		rst       : in  std_logic;           -- Reset
		clk       : in  std_logic;           -- Clock
		sp        : in  signed(7 downto 0);  -- Set Point
		pos       : in  signed(7 downto 0);  -- Measured position
		motor_cw  : out std_logic;           --Motor Clock Wise direction
		motor_ccw : out std_logic            --Motor Counter Clock Wise direction
    ); 
	  end component p_ctrl;
	  
	  
	component pos_meas
	  port (
		-- System Clock and Reset
		rst      : in  std_logic;           -- Reset
		clk      : in  std_logic;           -- Clock
		sync_rst : in  std_logic;           -- Sync reset
		a        : in  std_logic;           -- From position sensor
		b        : in  std_logic;           -- From position sensor
		pos      : out signed(7 downto 0)   -- Measured position
		);   
	end component pos_meas;
	
	component motor
		 port (
			motor_cw  : in  std_logic;
			motor_ccw : in  std_logic;
			a         : out std_logic;
			b         : out std_logic
		);
	end component motor;
		
		
		signal rst_i 		 : std_logic;
		signal mclk			 : std_logic:='0';
		signal a_i         	 : std_logic;
		signal b_i       	 : std_logic;
		signal motor_cw_i    : std_logic;
		signal motor_ccw_i 	 : std_logic;
		signal pos_i		 : signed(7 downto 0):= "00000000";
		signal sp_i	         : signed(7 downto 0):= "00000000";
		signal pos_meas_i		 : signed(7 downto 0);
		
		constant half_period : time := 10 ns;
		
	begin

	UUT: p_ctrl
	port map
	(
		rst       => rst_i, 
	    clk       => mclk,
	    sp        => sp_i,
        pos       => pos_i, 
        motor_cw  => motor_cw_i,
        motor_ccw => motor_ccw_i
	);
	
	UUT1: pos_meas
	port map
	(
		rst       => rst_i,
		clk       => mclk,
		sync_rst  => rst_i,
		a         => a_i,
		b         => b_i,
		pos       => pos_meas_i
	);
	
	UUT2: motor
	port map 
	(
		motor_cw 	=> motor_cw_i,
		motor_ccw 	=> motor_ccw_i,
		a			=> a_i,	
		b			=> b_i
	);

	mclk <= not mclk after half_period;
		
	
	
	STIMULI :
	process
	begin
	rst_i <= '1';
	wait for 40 ns;
	rst_i <= '0';
	pos_i 	<= "00000000";
	sp_i	<= "00000011";
	wait for 40 ns;
	pos_i 	<= "00000111";
	sp_i	<= "00001111";
	wait for 40 ns;
	pos_i 	<= "00001111";
	sp_i	<= "00000000";
	wait;
	
	end process;

	
end testbench;