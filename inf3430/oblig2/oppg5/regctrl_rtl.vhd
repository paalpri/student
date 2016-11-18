library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.seg7_pkg.all;

architecture rtl of regctrl is

	component teller
	port
	(
		rst	 	: in std_logic;
		mclk 	: in std_logic;
		mclk_div: out std_logic;
		go		: in boolean
	);
	end component teller;
	
	signal teller_i : std_logic;
	signal disp		: unsigned (15 downto 0);
	signal go_i		: boolean := false;
	


begin

	D_OUT0 <= std_logic_vector (disp(3 downto 0));
	D_OUT1 <= std_logic_vector (disp(7 downto 4));
	D_OUT2 <= std_logic_vector (disp(11 downto 8));
	D_OUT3 <= std_logic_vector (disp(15 downto 12));
	
	UUT: teller
	port map 
	(
		rst	 		=> RESET,
	    mclk 		=> CLK,
	    mclk_div	=> teller_i,
		go 			=> go_i
	);
	
	clock_teller :
	process(CLK)
	begin
	if(rising_edge(CLK)) then
		if(stop = '1' or RESET = '1') then
			go_i <= false;
		end if;
		if(start = '1') then 
			go_i <= true;
		end if;
	end if;
	
	end process clock_teller;
		
	REG_CTRL :
	process(teller_i,start,stop)

	begin
		
		if(RESET) = '1' then
			disp <= (others => '0'); 
			
		elsif rising_edge(teller_i)then
			if(go_i) then
				disp <= disp + 1;
				if(disp(3 downto 0) = "1001") then
					disp(3 downto 0) <= "0000";
					disp(7 downto 4) <= disp(7 downto 4) + 1;
				end if;
				if(disp(7 downto 4) = "1001") then
					disp(7 downto 4) <= "0000";
					disp(11 downto 8) <= disp(11 downto 8) + 1;
				end if;
				if(disp(11 downto 8) = "1001") then
					disp(11 downto 8) <= "0000";
					disp(15 downto 12) <= disp(15 downto 12) + 1;
				end if;
				if(disp(15 downto 12) = "1001") then
					disp <= (others => '0'); 
				end if;
			end if;	
					
		end if;
	end process REG_CTRL;
	

end architecture rtl;
		