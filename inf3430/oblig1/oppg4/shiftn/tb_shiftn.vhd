library ieee;
use ieee.std_logic_1164.all;

entity TB_shiftn is

end TB_shiftn;

architecture tb_shiftn of TB_shiftn is

	Component shiftn
	generic ( n : integer := 16);
	port(
		-- System Clock and Reset
		rst_n     : in  std_logic;   -- Reset
		mclk      : in  std_logic;   -- Clock
		-- Shifted data in and out
		Sdin       : in  std_logic;   -- Data in
		Sdout      : out std_logic    -- Data out
	);
	end Component;
	
	signal RESET	:std_logic;
	signal MCLK		:std_logic := '0';
	signal Sdin		:std_logic;
	signal Sdout	:std_logic;
	
	--constant half_period : time := 10 ns; -- 50Mhz klokkefrekvens
	
	begin
	
	UUT : shiftn
	generic map(
		n => 64
	)
	port map
	(
		rst_n => RESET,
		mclk  => MCLK,
		sdin  => Sdin,
		Sdout => Sdout
	);
	
	--MCLK <= not MCLK after half_period;
	
	STIMULI :
	process
	begin
	mclk <= '0'
	wait for 10 ns;
	mclk <='0'
	wait for 10 ns;
	mclk <= '0'
	RESET <= '0';
	Sdin <= '0';
	wait for 40 ns;
	RESET <= '1';
	Sdin <= '1', '0' after 80 ns;
	wait;
	
end process;

end tb_shiftn;	
	
	