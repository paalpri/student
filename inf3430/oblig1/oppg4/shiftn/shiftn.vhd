library ieee;
use ieee.std_logic_1164.all;



entity shiftn is

generic ( n : integer := 16);

	port (
		rst_n : in std_logic;
		mclk  : in std_logic;
		
		Sdin  : in std_logic;
		Sdout :out std_logic
	);
	end shiftn;
	
architecture rtl of shiftn is
  Component dff 
    port
    (
    rst_n     : in  std_logic;   -- Reset
    mclk      : in  std_logic;   -- Clock
    din       : in  std_logic;   -- Data in
    dout      : out std_logic    -- Data out
    );
  end Component;
  
	signal parallel_data : std_logic_vector (n-2 downto 0);
	
	
begin
	
	process (rst_n,mclk)
	begin
	if rising_edge (mclk) then
		Shift_REG: for i in 0 to n-1 generate
		begin
		
			dff_left : if i = 0 generate
			begin
			
				dffx: component dff
					port map ( rst_n,mclk,sdin,parallel_data(i));
			end generate dff_left;
			dff_others: if ((i> 0 ) and (i < n-1)) generate
			begin	
				dffx: component dff
					port map ( rst_n,mclk,parallel_data(i-1),parallel_data(i));
			end generate dff_others;
			dff_end: if i = n-2 generate
			begin	
				dffx: component dff
					port map ( rst_n,mclk,parallel_data(i-1),Sdout);
				end generate dff_end;
		end generate Shift_REG;
	end if;
end	architecture;
			
				