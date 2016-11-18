
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_seg7model is 
  --empty
end tb_seg7model;
architecture testbench  of tb_seg7model is
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
	  
	  component seg7ctrl
	  port(
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
		
		
		signal reset 		 : std_logic;
		signal clk			 : std_logic:='0';
		signal a_ni          : std_logic_vector(3 downto 0);
		signal abcdefgdec_ni : std_logic_vector(7 downto 0):= "ZZZZZZZZ";
		signal disp3         : std_logic_vector(3 downto 0);
		signal disp2         : std_logic_vector(3 downto 0);
		signal disp1         : std_logic_vector(3 downto 0);
		signal disp0         : std_logic_vector(3 downto 0);
		signal dec			 : std_logic_vector(3 downto 0);
		signal d0 			 : std_logic_vector(3 downto 0):= "ZZZZ";
		signal d1 			 : std_logic_vector(3 downto 0):= "ZZZZ";
		signal d2 			 : std_logic_vector(3 downto 0):= "ZZZZ";
		signal d3 			 : std_logic_vector(3 downto 0):= "ZZZZ";
		
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

	
	
	UUT2: seg7ctrl
	port map
	(
		reset        => reset,
		mclk 		 => clk,
		dec 		 => dec,
		a_n          =>  a_ni,
	    abcdefgdec_n =>  abcdefgdec_ni,
	    d3       	 =>  d3,
        d2    	     =>  d2,
        d1    	     =>  d1,
        d0   	     =>  d0
	);

	clk <= not clk after half_period;
		
	
	
-- kun en a-ni høy om gangen!!!! ikke lov ifølge oppgaven! 
	STIMULI :
	process
	begin
	reset <= '0';
	wait for 40 ns;
	reset <= '1';
	dec <= "0000";
	d0 <= "1011";
	d1 <= "1111";
	d2 <= "0001";
	d3 <= "1100";
	
	wait;
	
	end process;

	
end testbench;