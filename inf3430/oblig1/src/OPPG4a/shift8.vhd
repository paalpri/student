library ieee;
use ieee.std_logic_1164.all;

entity shift8 is
	port (
		rst_n : in std_logic;
		mclk  : in std_logic;
	--	dff   : entity work.dff(dff);	
		Sdin	  : in std_logic;
		Sdout  :out std_logic
	);
	end shift8;
	
architecture rtl of shift8 is
  Component dff 
    port
    (
    rst_n     : in  std_logic;   -- Reset
    mclk      : in  std_logic;   -- Clock
    din       : in  std_logic;   -- Data in
    dout      : out std_logic    -- Data out
    );
  end Component;
  
	signal s1, s2,s3,s4,s5,s6,s7 : std_logic;
	
	
begin
	dff1 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => Sdin,
			dout     => s1
		);  
	dff2 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s1,
			dout     => s2
		);     
	dff3 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s2,
			dout     => s3
		);     
	dff4 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s3,
			dout     => s4
		);     
	dff5 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s4,
			dout     => s5
		);     
	dff6 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s5,
			dout     => s6
		);     
	dff7 : dff
		port map (
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s6,
			dout     => s7
		);
	dff8 : dff
		port map (	
			rst_n    => rst_n,
			mclk     => mclk,
			din      => s7,
			dout     => Sdout
		);     	
	
end rtl;