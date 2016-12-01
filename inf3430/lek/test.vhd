library ieee;
use ieee.std_logic_1164.all;



entity test is
	port (
		rst_n : in std_logic;
		mclk  : in std_logic;
	--	dff   : entity work.dff(dff);	
		Sdin  : in std_logic;
		Sdout :out std_logic
	);
	end test;
	
architecture rtl of test is
  Component dff 
    port
    (
    rst_n     : in  std_logic;   -- Reset
    mclk      : in  std_logic;   -- Clock
    din       : in  std_logic;   -- Data in
    dout      : out std_logic    -- Data out
    );
  end Component;
  
	signal parallel_data : std_logic_vector (1 to 32);
	
	
begin
	Shift_REG: for i in 1 to 32 generate
	begin
		dff_left : if i = 1 generate
		begin
		
			dffx: component dff
				port map ( Sdin,mclk,rst_n,parallel_data(i));
		end generate dff_left;
		dff_others: if ((i> 1 ) and (i < 32)) generate
		begin	
			dffx: component dff
				port map ( parallel_data(i-1),mclk,rst_n,parallel_data(i));
		end generate dff_others;
		dff_end: if i = 32 generate
		begin	
			dffx: component dff
				port map ( parallel_data(i-1),mclk,rst_n,Sdout);
			end generate dff_end;
	end generate Shift_REG;
end	architecture;
			
				